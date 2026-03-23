`timescale 1ns / 1ns
module Pipeline_tb;
    reg         clk, rst;
    reg  [31:0] InstrIn;
    wire [31:0] Out;

    Pipeline dut (
        .clk(clk),
        .rst(rst),
        .InstrIn(InstrIn),
        .Out(Out)
    );

    always #5 clk = ~clk;

    // NOP: bit30=1, ALUOp=000 (MOV r0=r0)
    localparam NOP = 32'b010000_00000_00000_0000000000000000;

    initial begin
        clk     = 0;
        rst     = 1;
        InstrIn = NOP;
        #20;
        rst = 0;
        #10;

        // Register file initializes to 10*i
        // r0=0, r1=10, r2=20, r3=30 ...

        // --------------------------------------------------
        // ADDI r5 = r1 + 10  (10 + 10 = 20 = 0x14)
        // opcode: bit30=1, bit29=1, ALUOp=011 -> 011011
        // expect Out=0x14 after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b011011_00101_00001_0000000000001010;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // ADD r6 = r1 + r2  (10 + 20 = 30 = 0x1E)
        // opcode: bit30=1, bit29=0, ALUOp=011 -> 010011
        // expect Out=0x1E after 4 cycles;
        // --------------------------------------------------
        InstrIn = 32'b010011_00110_00001_00010_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // SUB r7 = r2 - r1  (20 - 10 = 10 = 0x0A)
        // opcode: bit30=1, bit29=0, ALUOp=110 -> 010110
        // expect Out=0x0A after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010110_00111_00010_00001_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // SUB r8 = r1 - r2  (10 - 20 = -10 = 0xFFFFFFF6)
        // expect Out=0xFFFFFFF6 after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010110_01000_00001_00010_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // MOV r9 = r1  (r9 = 10 = 0x0A)
        // opcode: bit30=1, bit29=0, ALUOp=000 -> 010000
        // expect Out=0x0A after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010000_01001_00001_00000_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // NOT r10 = ~r1  (~10 = 0xFFFFFFF5)
        // opcode: bit30=1, bit29=0, ALUOp=001 -> 010001
        // expect Out=0xFFFFFFF5 after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010001_01010_00001_00000_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // NOR r11 = ~(r1 | r2)
        // 0x0A | 0x14 = 0x1E, ~0x1E = 0xFFFFFFE1
        // opcode: bit30=1, bit29=0, ALUOp=100 -> 010100
        // expect Out=0xFFFFFFE1 after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010100_01011_00001_00010_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // NAND r12 = ~(r1 & r2)
        // 0x0A & 0x14 = 0x00, ~0x00 = 0xFFFFFFFF
        // opcode: bit30=1, bit29=0, ALUOp=101 -> 010101
        // expect Out=0xFFFFFFFF after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010101_01100_00001_00010_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // SLT true: r13 = 1 if r1 < r2  (10 < 20 = true)
        // opcode: bit30=1, bit29=0, ALUOp=111 -> 010111
        // expect Out=0x1 after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010111_01101_00001_00010_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // SLT false: r14 = 1 if r2 < r1  (20 < 10 = false)
        // expect Out=0x0 after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b010111_01110_00010_00001_00000000000;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // ADDI r15 = r0 + (-1) = 0xFFFFFFFF (signed immediate)
        // imm = 0xFFFF sign extends to -1
        // opcode: bit30=1, bit29=1, ALUOp=011 -> 011011
        // expect Out=0xFFFFFFFF after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b011011_01111_00000_1111111111111111;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // SLTI r16 = 1 if r1 < 20  (10 < 20 = true)
        // opcode: bit30=1, bit29=1, ALUOp=111 -> 011111
        // expect Out=0x1 after 4 cycles
        // --------------------------------------------------
        InstrIn = 32'b011111_10000_00001_0000000000010100;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        // --------------------------------------------------
        // SLTI false: r17 = 1 if r1 < 5  (10 < 5 = false)
        // expect Out=0x0 after 4 cycles
        // --------------------------------------------------

        InstrIn = 32'b011111_10001_00001_0000000000000101;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10; InstrIn = NOP;
        #10;

        $display("All tests complete.");
        $finish;
    end

    initial begin
        $monitor("T=%0t | InstrIn=%b | Out=%h", $time, InstrIn, Out);
    end

endmodule
