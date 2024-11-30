module controller (
    input wire clk, reset, FlushE,
    input wire [4:0] ALUFlagsE,
    input wire [31:0] InstrD,
    output wire [1:0] RegSrcD, ImmSrcD,ShiftControlE, 
    output wire MemWriteE,SaturatedOpE,ShiftE,PreIndexE,PostIndexE,CarryE,WriteBackW,WriteBackM,MulOpD,MulOpE,RegShiftE,
    output wire [3:0] ALUControlE, 
    output wire BranchTakenD, MemtoRegE, ALUSrcE, WriteBackE,
                RegWriteM, MemWriteM, PCSrcW, RegWriteW, MemtoRegW, PCWrPendingF, BranchD 
);
    // Internal signals
    reg NoWriteD;
    reg [2:0] FlagWriteD;
    reg [3:0] ALUControlD;
    reg [9:0] controlsD;
    wire [3:0] CondE;
    wire [4:0] FlagsNextE, FlagsE;
    wire [2:0] FlagWriteE; // wire porque entra como wire en cond
    wire PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUOpD, CondExEarlyD,
         PCSrcE, RegWriteE, 
         CondExE, RegWriteGatedE, MemWriteGatedE, 
         PCSrcM, MemtoRegM, ALUSrcD; 
    wire RegShiftD,SaturatedOpD,ShiftD,PreIndexD,PostIndexD,WriteBackD;

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
    assign MulOpD = ((InstrD[25:24] == 2'b00) & (InstrD[7:4] == 4'b1001) & InstrD[27:26] == 2'b00);
	assign SaturatedOpD = (InstrD[7:4] == 4'b0101 & InstrD[27:26] == 2'b00 & InstrD[24] &~InstrD[23] & ~InstrD[20]);
	assign ShiftD = (InstrD[24:21] == 4'b1101 & InstrD[27:26] == 2'b00);
	assign RegShiftD = (ALUOpD & InstrD[7] == 1'b0 & InstrD[4]== 1'b1 & InstrD[25] == 1'b0);
	assign PreIndexD = (InstrD[27:26] == 2'b01 & InstrD[24]);
	assign PostIndexD = (InstrD[27:26] == 2'b01 & ~InstrD[24]);
	assign WriteBackD = (InstrD[27:26] == 2'b01 & InstrD[21] & InstrD[24]) | (InstrD[27:26] == 2'b01 & ~InstrD[24]);
    always @(*) begin
        if (ALUOpD) begin
            case (InstrD[24:21])
                4'b0100: ALUControlD = 3'b000;//add
				4'b0010: ALUControlD = 3'b001;//sub
				4'b0000: ALUControlD = 3'b010;//and
				4'b1100: ALUControlD = 3'b011;//orr
				4'b0001: ALUControlD = 3'b110; //eor
                4'b1010: ALUControlD = 3'b001; //cmp subs no write
				4'b1011: ALUControlD = 3'b000; //cmn add no write
				4'b1000: ALUControlD = 3'b010; //TST and no write
				4'b1001: ALUControlD = 3'b110; //TEQ eor no write
				4'b1111: ALUControlD = 3'b111; //mvn
				4'b1110: ALUControlD = 4'b1010; //bic
				default: ALUControlD = 3'bxxx;
			endcase
			if(MulOpD)
			begin
			case (InstrD[23:21])
			 3'b000: ALUControlD = 3'b100; //MUL
			 3'b001: ALUControlD = 3'b101; //MAL
			 default: ALUControlD = 3'bxxx; //xd?
			 endcase
			end
			if(SaturatedOpD) begin
			case (InstrD[22:21])
			2'b00: ALUControlD = 4'b1000;
			2'b01: ALUControlD = 4'b1001;
			default: ALUControlD = 4'bxxxx;
			endcase
			end
            FlagWriteD[2] = InstrD[20]; // Update N and Z flags if S bit is set
            FlagWriteD[1] = InstrD[20] & ((ALUControlD == 2'b00) | (ALUControlD == 2'b01));
            FlagWriteD[0] = SaturatedOpD; //if overflow occurs, then saturation
            NoWriteD = (InstrD[24:23] == 2'b10 & InstrD[27:26] == 2'b00);

		end
		else begin
		    ALUControlD = (InstrD[27:26] == 2'b01 & ~InstrD[23]) ? 3'b001:3'b000;
			FlagWriteD = 3'b000;
			NoWriteD = 2'b00;
		end
    end

    assign PCSrcD = (((InstrD[15:12] == 4'b1111) & RegWriteD)); // Ya no BranchD
    
    conditional CondEarly(
        .Cond(InstrD[31:28]),
        .Flags(FlagsNextE),
        .ALUFlags(5'bx),
        .FlagsWrite(3'bx),
        .CondEx(CondExEarlyD)
    );
    
    assign BranchTakenD = BranchD & CondExEarlyD;
    assign CarryE = FlagsE[2];

    // Execute stage
    floprc #(8) flushedregsE(
        .clk(clk),
        .reset(reset),
        .clear(FlushE),
        .d({FlagWriteD, MemWriteD, RegWriteD, PCSrcD, MemtoRegD, NoWriteD}),
        .q({FlagWriteE, MemWriteE, RegWriteE, PCSrcE, MemtoRegE, NoWriteE})
    );

    flopr #(5) regsE(
        .clk(clk),
        .reset(reset),
        .d({ALUSrcD, ALUControlD}),
        .q({ALUSrcE, ALUControlE})
    );
    
    flopr #(6) controlsignalsreg(
        .clk(clk),
        .reset(reset),
        .d({SaturatedOpD,ShiftD,PreIndexD,PostIndexD,RegShiftD}),
        .q({SaturatedOpE,ShiftE,PreIndexE,PostIndexE,RegShiftE})
    );
    
    flopr #(1) writebacke(
        .clk(clk),
        .reset(reset),
        .d(WriteBackD),
        .q(WriteBackE)
    );
    
   flopr #(1) writebackm(
        .clk(clk),
        .reset(reset),
        .d(WriteBackE),
        .q(WriteBackM)
    );
    
   flopr #(1) writebackw(
        .clk(clk),
        .reset(reset),
        .d(WriteBackM),
        .q(WriteBackW)
    );
    
    flopr #(4) condregE(
        .clk(clk),
        .reset(reset),
        .d(InstrD[31:28]),
        .q(CondE)
    );
    
    flopr #(2) shcontrol(
	   .clk(clk),
	   .reset(reset),
	   .d(InstrD[6:5]),
	   .q(ShiftControlE)
	);
	
    flopr #(5) flagsreg(
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
    
    assign PCSrcGatedE = PCSrcE & CondExE;
    assign RegWriteGatedE = RegWriteE & CondExE & ~NoWriteE;
    assign MemWriteGatedE = MemWriteE & CondExE;

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