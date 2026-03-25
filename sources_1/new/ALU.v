module ALU (
    output reg  [31:0] R1,
    input  wire [ 2:0] OpCode,
    input  wire [31:0] R2,
    input  wire [31:0] R3
);
  always @(*) begin
    case (OpCode)
      3'b000: R1 = R2;
      3'b001: R1 = ~R2;
      3'b011: R1 = R2 + R3;
      3'b100: R1 = ~(R2 | R3);
      3'b010: R1 = R2 - R3;  // SUB
      3'b101: R1 = ~(R2 & R3);
      3'b110: R1 = R2 & R3;  // AND TYPO Here, FIX LATER
      3'b110: R1 = R2 & R3;
      3'b111: R1 = ($signed(R2) < $signed(R3)) ? 32'd1 : 32'd0;

      default: R1 = 0;
    endcase
  end
endmodule
