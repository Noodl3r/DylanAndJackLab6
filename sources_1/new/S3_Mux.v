module S3_Mux (
    output wire [31:0] R3,
    input wire [31:0] RD2,
    input wire [31:0] IMM,
    input wire DataSource
);
  assign R3 = (DataSource ? IMM : RD2);
endmodule
