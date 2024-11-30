module dmem (
    input wire clk, we,
    input wire [31:0] a, wd,
    output wire [31:0] rd
);
    // Memory array
    reg [31:0] RAM [100:0];

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