module imem (
    input wire [31:0] a,
    output wire [31:0] rd
);
    // Memory array
    reg [31:0] RAM [63:0];

    // Initialize memory with direct values
initial begin
    RAM[0]  = 32'hE04F000F;
    RAM[1]  = 32'hE2801004;
    RAM[2]  = 32'hE2812008;
    RAM[3]  = 32'hE2423005;
    RAM[4]  = 32'hE1824003;
    RAM[5]  = 32'hE0025003;
    RAM[6]  = 32'hE5804000;
    RAM[7]  = 32'hE5906000;
    RAM[8]  = 32'hE5805004;
    RAM[9]  = 32'hE5907004;
    RAM[10] = 32'hE2808004;
    RAM[11] = 32'hE2409005;
    RAM[12] = 32'hE280A006;
    RAM[13] = 32'hE220B007;
    RAM[14] = 32'hE380C00A;
    RAM[15] = 32'hE200D014;
    RAM[16] = 32'hE280E038;
    RAM[17] = 32'hE2522001;
    RAM[18] = 32'h1AFFFFFD;
    RAM[19] = 32'hE2802005;
    RAM[20] = 32'hE2803003;
    RAM[21] = 32'hE2533001;
    RAM[22] = 32'h1AFFFFFD;
    RAM[23] = 32'hE2522001;
    RAM[24] = 32'h1AFFFFFA;
    RAM[25] = 32'hEAFFFFFF;
    RAM[26] = 32'hE28CC001;
    RAM[27] = 32'hE24C000A;
    RAM[28] = 32'h1AFFFFF3;
    RAM[29] = 32'hE0440005;
    RAM[30] = 32'h0A000000;
    RAM[31] = 32'h1A000001;
    RAM[32] = 32'hE2866002;
    RAM[33] = 32'hEA000000;
    RAM[34] = 32'hE2466001;
    RAM[35] = 32'hE2577001;
    RAM[36] = 32'h1AFFFFF7;
end


    // Read from memory
    assign rd = RAM[a[22:2]]; // Word-aligned access

endmodule
