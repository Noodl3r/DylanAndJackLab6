`timescale 1ns / 1ns

module Pipeline (
    input         clk,
    input         rst,
    input  [31:0] InstrIn,  // Instruction input (from testbench)
    output [31:0] Out       // Final ALU output
);

  // --- S1 Stage: Instruction Decode (IF/ID Register) ---
  wire [4:0] S1_ReadSelect1, S1_ReadSelect2;
  wire [31:0] S1_IMM;
  wire        S1_DataSource;
  wire [ 2:0] S1_ALUOp;
  wire [ 4:0] S1_WriteSelect;
  wire        S1_WriteEnable;



  S1_Register S1_Reg (
      .S1_ReadSelect1(S1_ReadSelect1),
      .S1_ReadSelect2(S1_ReadSelect2),
      .S1_IMM(S1_IMM),
      .S1_DataSource(S1_DataSource),
      .S1_ALUOp(S1_ALUOp),
      .S1_WriteSelect(S1_WriteSelect),
      .S1_WriteEnable(S1_WriteEnable),

      .clk(clk),
      .rst(rst),
      .InstrIn(InstrIn)
  );

  // --- Register File ---
  wire [31:0] RF_ReadData1, RF_ReadData2;
  nbit_register_file RF (
      .clk(clk),
      .RegWrite(S3_WriteEnable),
      .write_address(S3_WriteSelect),
      .write_data(S3_ALUOut),
      .read_sel_1(S1_ReadSelect1),
      .read_sel_2(S1_ReadSelect2),
      .read_data_1(RF_ReadData1),
      .read_data_2(RF_ReadData2)
  );

  // --- S2 Stage: Execute (ID/EX Register) ---
  wire [31:0] S2_RD1, S2_RD2, S2_IMM;
  wire       S2_DataSrc;
  wire [2:0] S2_ALUOp;
  wire       S2_WriteEnable;
  wire [4:0] S2_WriteSelect;

  S2_Register S2_Reg (
      .S2_RD1(S2_RD1),
      .S2_RD2(S2_RD2),
      .S2_IMM(S2_IMM),
      .S2_DataSource(S2_DataSrc),
      .S2_ALUOp(S2_ALUOp),
      .S2_WriteEnable(S2_WriteEnable),
      .S2_WriteSelect(S2_WriteSelect),


      .clk(clk),
      .rst(rst),
      .RD1(RF_ReadData1),
      .RD2(RF_ReadData2),
      .S1_IMM(S1_IMM),
      .S1_DataSource(S1_DataSource),
      .S1_ALUOp(S1_ALUOp),
      .S1_WriteEnable(S1_WriteEnable),
      .S1_WriteSelect(S1_WriteSelect)
  );


  // --- ALU Operand MUX ---
  wire [31:0] ALU_R3;

  S3_Mux S3_mux (
      .R3(ALU_R3),
      .RD2(S2_RD2),
      .IMM(S2_IMM),
      .DataSrc(S2_DataSource)
  );

  // --- ALU ---

  ALU alu (
      .R1(S3_ALUOut),
      .OpCode(S2_ALUOp),
      .R2(S2_RD1),
      .R3(ALU_R3),
  );

  // --- S3 Stage: Write Back (EX/WB Register) ---
  wire [31:0] S3_ALUOut;
  wire [ 4:0] S3_WriteSelect;
  wire        S3_WriteEnable;


  // S3_Register

  // --- Final Output ---
  assign Out = S3_ALUOut;

endmodule
