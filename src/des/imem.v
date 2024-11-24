module imem (
    input wire [31:0] a,
    output wire [31:0] rd
);
    // Memory array
    reg [31:0] RAM [63:0];

    // Initialize memory with contents from "memfile.dat"
    initial begin
        $readmemh("memfile.mem", RAM);
    end

    // Read from memory
    assign rd = RAM[a[22:2]]; // Word-aligned access

endmodule