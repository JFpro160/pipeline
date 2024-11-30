module imem (
    input wire [31:0] a,
    output wire [31:0] rd
);
    // Memory array
    reg [31:0] RAM [63:0];

    // Initialize memory with direct values
    initial begin
        RAM[0]  = 32'hE04F000F;
        RAM[1]  = 32'hE04F100F;
        RAM[2]  = 32'hE04F200F;
        RAM[3]  = 32'hE04F300F;
        RAM[4]  = 32'hE04F400F;
        RAM[5]  = 32'hE04F500F;
        RAM[6]  = 32'hE04F600F;
        RAM[7]  = 32'hE04F700F;
        RAM[8]  = 32'hE04F800F;
        RAM[9]  = 32'hE04F900F;
        RAM[10] = 32'hE04FA00F;
        RAM[11] = 32'hE04FB00F;
        RAM[12] = 32'hE04FC00F;
        RAM[13] = 32'hE04FD00F;
        RAM[14] = 32'hE04FE00F;
        RAM[15] = 32'hE2800000;
        RAM[16] = 32'hE2811001;
        RAM[17] = 32'hE1700001;
        RAM[18] = 32'h0A000000;
        RAM[19] = 32'hEA000001;
        RAM[20] = 32'hE0802001;
        RAM[21] = 32'hEA000001;
        RAM[22] = 32'hE0403001;
        RAM[23] = 32'hEAFFFFFF;
        RAM[24] = 32'hE2800002;
        RAM[25] = 32'hE1700001;
        RAM[26] = 32'hCA000000;
        RAM[27] = 32'hEA000001;
        RAM[28] = 32'hE0804001;
        RAM[29] = 32'hEAFFFFFF;
        RAM[30] = 32'hE2400004;
        RAM[31] = 32'hE1700001;
        RAM[32] = 32'hBA000000;
        RAM[33] = 32'hEA000001;
        RAM[34] = 32'hE0805001;
        RAM[35] = 32'hEAFFFFFF;
        RAM[36] = 32'hE1700001;
        RAM[37] = 32'hAA000000;
        RAM[38] = 32'hEA000001;
        RAM[39] = 32'hE0206001;
        RAM[40] = 32'hEA000005;
        RAM[41] = 32'hE2800001;
        RAM[42] = 32'hE1700001;
        RAM[43] = 32'hDA000000;
        RAM[44] = 32'hEA000001;
        RAM[45] = 32'hE0807001;
        RAM[46] = 32'hEAFFFFFF;
        RAM[47] = 32'hE1700001;
        RAM[48] = 32'h4A000000;
        RAM[49] = 32'hEA000001;
        RAM[50] = 32'hE0408001;
        RAM[51] = 32'hEAFFFFFF;
        RAM[52] = 32'hE0009001;
        RAM[53] = 32'hEAFFFFFF;
    end

    // Read from memory
    assign rd = RAM[a[22:2]]; // Word-aligned access

endmodule
