`timescale 1ns / 1ns
module S2_Register (
    output reg [31:0] S2_RD1,          // Latched Read Data 1
    output reg [31:0] S2_RD2,          // Latched Read Data 2
    output reg [31:0] S2_IMM,          // IMM
    output reg        S2_DataSource,   // Selection
    output reg [ 2:0] S2_ALUOp,
    output reg        S2_WriteEnable,  // Latched write enable
    output reg [ 4:0] S2_WriteSelect,  // Latched write select

    input        clk,
    input        rst,
    input [31:0] RD1,  // Register File Read Data 1
    input [31:0] RD2,  // Register File Read Data 2

    input [31:0] S1_IMM,
    input        S1_DataSource,
    input [ 2:0] S1_ALUOp,
    input        S1_WriteEnable,  // Write enable signal
    input [ 4:0] S1_WriteSelect   // Write select (destination register)



);

  always @(posedge clk) begin
    if (rst) begin
      S2_RD1         <= 32'd0;
      S2_RD2         <= 32'd0;
      S2_IMM         <= 32'd0;
      S2_DataSource  <= 1'd0;
      S2_ALUOp       <= 3'd0;
      S2_WriteEnable <= 1'b0;
      S2_WriteSelect <= 5'd0;
    end else begin
      S2_RD1         <= RD1;
      S2_RD2         <= RD2;
      S2_IMM         <= S1_IMM;
      S2_DataSource  <= S1_DataSource;
      S2_ALUOp       <= S1_ALUOp;
      S2_WriteEnable <= S1_WriteEnable;
      S2_WriteSelect <= S1_WriteSelect;
    end
  end

endmodule
