module F_D_Register (
    input wire clk,
    input wire reset,
    input wire stall,
    // Inputs from IF stage
    input wire [31:0] instruction_in,
    input wire [31:0] pc_plus4_in,
    // Outputs to ID stage
    output reg [31:0] instruction_out,
    output reg [31:0] pc_plus4_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction_out <= 32'b0;
            pc_plus4_out <= 32'b0;
        end
        else if (!stall) begin
            instruction_out <= instruction_in;
            pc_plus4_out <= pc_plus4_in;
        end
    end
endmodule

module D_EX_Register (
    input wire clk,
    input wire reset,
    // Control signals
    input wire mem_read_in,
    input wire mem_write_in,
    input wire reg_write_in,
    input wire alu_src_in,
    // Data inputs
    input wire [31:0] reg_data1_in,
    input wire [31:0] reg_data2_in,
    input wire [31:0] imm_ext_in,
    input wire [4:0] rs1_in,
    input wire [4:0] rs2_in,
    input wire [4:0] rd_in,
    input wire [3:0] alu_control_in,
    // Control outputs
    output reg mem_read_out,
    output reg mem_write_out,
    output reg reg_write_out,
    output reg alu_src_out,
    // Data outputs
    output reg [31:0] reg_data1_out,
    output reg [31:0] reg_data2_out,
    output reg [31:0] imm_ext_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,
    output reg [3:0] alu_control_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Control signals
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            alu_src_out <= 1'b0;
            // Data signals
            reg_data1_out <= 32'b0;
            reg_data2_out <= 32'b0;
            imm_ext_out <= 32'b0;
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out <= 5'b0;
            alu_control_out <= 4'b0;
        end
        else begin
            // Control signals
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            alu_src_out <= alu_src_in;
            // Data signals
            reg_data1_out <= reg_data1_in;
            reg_data2_out <= reg_data2_in;
            imm_ext_out <= imm_ext_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out <= rd_in;
            alu_control_out <= alu_control_in;
        end
    end
endmodule

module EX_MEM_Register (
    input wire clk,
    input wire reset,
    // Control signals
    input wire mem_read_in,
    input wire mem_write_in,
    input wire reg_write_in,
    // Data inputs
    input wire [31:0] alu_result_in,
    input wire [31:0] write_data_in,
    input wire [4:0] rd_in,
    // Control outputs
    output reg mem_read_out,
    output reg mem_write_out,
    output reg reg_write_out,
    // Data outputs
    output reg [31:0] alu_result_out,
    output reg [31:0] write_data_out,
    output reg [4:0] rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Control signals
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            reg_write_out <= 1'b0;
            // Data signals
            alu_result_out <= 32'b0;
            write_data_out <= 32'b0;
            rd_out <= 5'b0;
        end
        else begin
            // Control signals
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            reg_write_out <= reg_write_in;
            // Data signals
            alu_result_out <= alu_result_in;
            write_data_out <= write_data_in;
            rd_out <= rd_in;
        end
    end
endmodule

module MEM_WB_Register (
    input wire clk,
    input wire reset,
    // Control signals
    input wire reg_write_in,
    // Data inputs
    input wire [31:0] read_data_in,
    input wire [31:0] alu_result_in,
    input wire [4:0] rd_in,
    // Control outputs
    output reg reg_write_out,
    // Data outputs
    output reg [31:0] read_data_out,
    output reg [31:0] alu_result_out,
    output reg [4:0] rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Control signals
            reg_write_out <= 1'b0;
            // Data signals
            read_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            rd_out <= 5'b0;
        end
        else begin
            // Control signals
            reg_write_out <= reg_write_in;
            // Data signals
            read_data_out <= read_data_in;
            alu_result_out <= alu_result_in;
            rd_out <= rd_in;
        end
    end
endmodule