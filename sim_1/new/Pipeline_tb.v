`timescale 1ns / 1ns
module Pipeline_tb;

  // Inputs
  reg clk;
  reg rst;
  reg [31:0] InstrIn;

  // Outputs
  wire [31:0] Out;

  // Instantiate the Unit Under Test (UUT)
  Pipeline uut (
      .clk(clk),
      .rst(rst),
      .InstrIn(InstrIn),
      .Out(Out)
  );

  // Define clk
  always #5 assign clk = ~clk;

  initial begin
    // Initialize Inputs
    clk = 0;
    rst = 1;
    InstrIn = 0;

    // Wait 10 ns for global reset to finish
    #10;
    rst = 0;
    InstrIn = 32'b000000_00010_00001_00010_00000000000;  // Read out R1 and R2, write result to R2

    #10;
    InstrIn = 32'b000000_00100_00011_00100_00000000000;  // Read out R3 and R4, write result to R4

    #10;
    InstrIn = 32'b000000_00110_00101_00110_00000000000;  // Read out R5 and R6, write result to R6

    #10;
    InstrIn = 32'b000000_01000_00111_01000_00000000000;  // Read out R7 and R8, write result of R8.

    #10;
    InstrIn = 32'b000000_00000_00000_00000_00000000000;  // Do nothing


    #100;
    $finish;

  end

endmodule

