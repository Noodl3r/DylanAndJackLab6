module nbit_register_file_tb;
  reg clk, RegWrite;
  reg [31:0] write_data;
  reg [4:0] read_sel_1, read_sel_2, write_address;
  wire [31:0] read_data_1, read_data_2;

  nbit_register_file RF (
      .write_data(write_data),
      .read_data_1(read_data_1),
      .read_data_2(read_data_2),
      .read_sel_1(read_sel_1),
      .read_sel_2(read_sel_2),
      .write_address(write_address),
      .RegWrite(RegWrite),
      .clk(clk)
  );
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    RegWrite = 0;

    read_sel_1 = 5'd1;
    read_sel_2 = 5'd2;
    #10;

    RegWrite = 1;
    write_address = 5'd1;
    write_data = 32'hDEADBEEF;
    #10;

    read_sel_1 = 5'd1;
    #10;

    RegWrite = 0;
    write_address = 5'd2;
    write_data = 32'hFFFFFFFF;
    #10;
    read_sel_1 = 5'd2;
    #10;

    $finish;
  end
endmodule
