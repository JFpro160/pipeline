module controller (
    input wire clk, reset, FlushE,
    input wire [3:0] ALUFlagsE,
    input wire [31:12] InstrD,
    output wire [1:0] RegSrcD, ImmSrcD, ALUControlE, 
    output wire MemtoRegE, ALUSrcE, BranchTakenE, 
                RegWriteM, MemWriteM, PCSrcW, RegWriteW, MemtoRegW, PCWrPendingF
);
    // Internal signals
    reg [1:0] ALUControlD, FlagWriteD;
    reg [9:0] controlsD;
    wire [3:0] FlagsNextE, CondE, FlagsE;
    wire [1:0] FlagWriteE; // wire porque entra como wire en cond
    wire PCSrcD, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUOpD,
         PCSrcE, RegWriteE, MemWriteE, BranchE, 
         CondExE, RegWriteGatedE, MemWriteGatedE, 
         PCSrcMwire, MemtoRegM; 

    // Decode stage
    always @(*) begin
        case (InstrD[27:26])
            2'b00: controlsD = InstrD[25] ? 10'b0000101001 : 10'b0000001001; // DP imm or reg
            2'b01: controlsD = InstrD[20] ? 10'b0001111000 : 10'b1001110100; // LDR or STR
            2'b10: controlsD = 10'b0110100010; // B
            default: controlsD = 10'bxxxxxxxxxx;
        endcase
    end

    assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, MemWriteD, BranchD, ALUOpD} = controlsD;

    always @(*) begin
        if (ALUOpD) begin
            case (InstrD[24:21])
                4'b0100: ALUControlD = 2'b00; // ADD
                4'b0010: ALUControlD = 2'b01; // SUB
                4'b0000: ALUControlD = 2'b10; // AND
                4'b1100: ALUControlD = 2'b11; // ORR
                default: ALUControlD = 2'bxx;  // Unimplemented
            endcase
            FlagWriteD[1] = InstrD[20]; // Update N and Z flags if S bit is set
            FlagWriteD[0] = InstrD[20] & ((ALUControlD == 2'b00) | (ALUControlD == 2'b01)); // Only for ADD/SUB
        end else begin
            ALUControlD = 2'b00; // Addition for non-DP instructions
            FlagWriteD = 2'b00;  // Don't update flags
        end
    end

    assign PCSrcD = (((InstrD[15:12] == 4'b1111) & RegWriteD) | BranchD);

    // Execute stage
    floprc #(7) flushedregsE(
        .clk(clk),
        .reset(reset),
        .clear(FlushE),
        .d({FlagWriteD, BranchD, MemWriteD, RegWriteD, PCSrcD, MemtoRegD}),
        .q({FlagWriteE, BranchE, MemWriteE, RegWriteE, PCSrcE, MemtoRegE})
    );

    flopr #(3) regsE(
        .clk(clk),
        .reset(reset),
        .d({ALUSrcD, ALUControlD}),
        .q({ALUSrcE, ALUControlE})
    );

    flopr #(4) condregE(
        .clk(clk),
        .reset(reset),
        .d(InstrD[31:28]),
        .q(CondE)
    );

    flopr #(4) flagsreg(
        .clk(clk),
        .reset(reset),
        .d(FlagsNextE),
        .q(FlagsE)
    );

    // Conditional logic
    conditional Cond(
        .Cond(CondE),
        .Flags(FlagsE),
        .ALUFlags(ALUFlagsE),
        .FlagsWrite(FlagWriteE),
        .CondEx(CondExE),
        .FlagsNext(FlagsNextE)
    );

    assign BranchTakenE = BranchE & CondExE;
    assign RegWriteGatedE = RegWriteE & CondExE;
    assign MemWriteGatedE = MemWriteE & CondExE;
    assign PCSrcGatedE = PCSrcE & CondExE;

    // Memory stage
    flopr #(4) regsM(
        .clk(clk),
        .reset(reset),
        .d({MemWriteGatedE, MemtoRegE, RegWriteGatedE, PCSrcGatedE}),
        .q({MemWriteM, MemtoRegM, RegWriteM, PCSrcM})
    );

    // Writeback stage
    flopr #(3) regsW(
        .clk(clk),
        .reset(reset),
        .d({MemtoRegM, RegWriteM, PCSrcM}),
        .q({MemtoRegW, RegWriteW, PCSrcW})
    );

    // Hazard prediction
    assign PCWrPendingF = PCSrcD | PCSrcE | PCSrcM;

endmodule