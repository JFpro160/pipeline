module dmem (
    clk,
    we,
    a,
    wd,
    rd
);
    input wire clk;
    input wire we;
    input wire [31:0] a;
    input wire [31:0] wd;
    output wire [31:0] rd;

    // Memory array
    reg [31:0] RAM [63:0];

    // Initialize memory with contents from "memfile.dat"
    initial begin
        //$readmemh("memfile.dat", RAM);
    end

    // Read from memory
    assign rd = RAM[a[22:2]]; // Word-aligned access

    // Write to memory
    always @(posedge clk) begin
        if (we) begin
            RAM[a[22:2]] <= wd;
        end
    end

endmodule