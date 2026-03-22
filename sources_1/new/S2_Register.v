`timescale 1ns / 1ns
module S2_Register (
    input        clk,
    input        rst,
    input [31:0] RD1,  // Register File Read Data 1
    input [31:0] RD2,  // Register File Read Data 2

    // To Do: implement the rest of the logic according to the figure


    input             S1_WriteEnable,  // Write enable signal
    input      [ 4:0] S1_WriteSelect,  // Write select (destination register)
    output reg [31:0] S2_RD1,          // Latched Read Data 1
    output reg [31:0] S2_RD2,          // Latched Read Data 2


    // To Do: implement the rest of the logic according to the figure

    output reg       S2_WriteEnable,  // Latched write enable
    output reg [4:0] S2_WriteSelect   // Latched write select
);

  always @(posedge clk) begin
    if (rst) begin
      S2_RD1         <= 32'd0;
      S2_RD2         <= 32'd0;

      // To Do: implement the rest of the logic according to the figure

      S2_WriteEnable <= 1'b0;
      S2_WriteSelect <= 5'd0;
    end else begin
      S2_RD1         <= RD1;
      S2_RD2         <= RD2;

      // To Do: implement the rest of the logic according to the figure

      S2_WriteEnable <= S1_WriteEnable;
      S2_WriteSelect <= S1_WriteSelect;
    end
  end

endmodule
