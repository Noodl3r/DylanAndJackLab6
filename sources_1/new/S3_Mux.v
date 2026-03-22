module S3_Mux (
    output wire [31:0] R3,
    input wire [31:0] RD2,
    input wire [31:0] IMM,
    input wire DataSrc
);
  assign R3 = (DataSrc ? IMM : RD2);
endmodule
