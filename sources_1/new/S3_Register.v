module S3_Register (
    output reg [31:0] S3_ALUOut,
    output reg [ 4:0] S3_WriteSelect,
    output reg        S3_WriteEnable,

    input [31:0] S2_R1,
    input [ 4:0] S2_WriteSelect,
    input        S2_WriteEnable,

    input clk,
    input rst
);

  always @(posedge clk) begin
    if (rst) begin
      S3_ALUOut <= 32'b0;
      S3_WriteSelect <= 5'b0;
      S3_WriteEnable <= 0;
    end else begin
      S3_ALUOut <= S2_R1;
      S3_WriteSelect <= S2_WriteSelect;
      S3_WriteEnable <= S2_WriteEnable;
    end
  end

endmodule
