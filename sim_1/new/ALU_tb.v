`timescale 1ns / 1ns
module ALU_tb;
  reg [2:0] OpCode;
  reg [31:0] R2, R3;
  wire [31:0] R1;

  ALU alu (
      .R1(R1),
      .OpCode(OpCode),
      .R2(R2),
      .R3(R3)
  );

  initial begin
    // MOV: R1 = R2
    OpCode = 3'b000;
    R2 = 32'd42;
    R3 = 32'd0;
    #10;  // expect R1 = 42

    // NOT: R1 = ~R2
    OpCode = 3'b001;
    R2 = 32'h0000FFFF;
    R3 = 32'd0;
    #10;  // expect R1 = 0xFFFF0000


    // NOR: R1 = ~(R2 | R3)
    OpCode = 3'b100;
    R2 = 32'hF0F0F0F0;
    R3 = 32'h0F0F0F0F;
    #10;  // expect R1 = 0x00000000

    // NAND: R1 = ~(R2 & R3)
    OpCode = 3'b101;
    R2 = 32'hFFFFFFFF;
    R3 = 32'hFFFFFFFF;
    #10;  // expect R1 = 0x00000000

    // ADD: R1 = R2 + R3
    OpCode = 3'b011;
    R2 = 32'd10;
    R3 = 32'd20;
    #10;  // expect R1 = 30

    // SUB: R1 = R2 - R3
    OpCode = 3'b110;
    R2 = 32'd10;
    R3 = 32'd3;
    #10;  // expect R1 = 7

    // ADD with zero
    OpCode = 3'b011;
    R2 = 32'd42;
    R3 = 32'd0;
    #10;  // expect R1 = 42

    // ADD negative numbers (two's complement)
    OpCode = 3'b011;
    R2 = 32'hFFFFFFFF;
    R3 = 32'd1;  // -1 + 1
    #10;  // expect R1 = 0

    // SUB resulting in zero
    OpCode = 3'b110;
    R2 = 32'd10;
    R3 = 32'd10;
    #10;  // expect R1 = 0

    // SUB resulting in negative
    OpCode = 3'b110;
    R2 = 32'd3;
    R3 = 32'd10;
    #10;  // expect R1 = 0xFFFFFFF9 (-7 in two's complement)

    // SUB with zero
    OpCode = 3'b110;
    R2 = 32'd42;
    R3 = 32'd0;
    #10;  // expect R1 = 42

    // SUB negative from positive
    OpCode = 3'b110;
    R2 = 32'd10;
    R3 = 32'hFFFFFFFF;  // 10 - (-1)
    #10;  // expect R1 = 11

          // SLT: signed comparison
    OpCode = 3'b111;
    R2 = 32'hFFFFFFFF;
    R3 = 32'd0;  // -1 < 0
    #10;  // expect R1 = 1

    // SLT: false case
    OpCode = 3'b111;
    R2 = 32'd5;
    R3 = 32'd3;  // 5 < 3 is false
    #10;  // expect R1 = 0

    // SLT : equal case
    OpCode = 3'b111;
    R2 = 32'd5;
    R3 = 32'd5;  // 5 = 5 is false too!
    #10;  // expect R1 = 0

    $finish;
  end
endmodule
