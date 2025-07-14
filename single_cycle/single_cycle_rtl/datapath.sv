module datapath (
  input  logic        clk,
  input  logic        reset,
  input  logic        regfile_wren,
  input  logic        PC_sel,
  input  logic        ALU_bsel,
  input  logic [1:0]  result_sel,
  input  logic [1:0]  ximm_sel,
  input  logic [2:0]  ALU_control,
  input  logic [31:0] instruction,
  input  logic [31:0] dmem_data_out,
  output logic        N,Z,C,V,
  output logic [31:0] PC,
  output logic [31:0] ALU_result,
  output logic [31:0] dmem_data_in
);

logic [31:0] result;
logic [31:0] src1,src2; //data read from addr1 and addr2 of regfile

logic [31:0] PC_next;

myDFF #(
  .n(32)
) PC_register (
  .clk    (clk),
  .reset  (reset),
  .d      (PC_next),
  .q      (PC)
);

regfile REGFILE (
  .clk                (clk),
  .regfile_wren       (regfile_wren),
  .read_addr1         (instruction[19:15]),
  .read_addr2         (instruction[24:20]),
  .write_addr3        (instruction[11:7]),
  .regfile_data_in3   (result),
  .regfile_data_out1  (src1),
  .regfile_data_out2  (src2)
);

endmodule