module datapath (
  input  logic        clk,
  input  logic        reset,
  input  logic        regfile_wren,
  input  logic        PC_sel,
  input  logic        PC_target_sel,
  input  logic        ALU_bsel,
  input  logic [1:0]  result_sel,
  input  logic [1:0]  ximm_sel,
  input  logic [3:0]  ALU_control,
  input  logic [31:0] instruction,
  input  logic [31:0] dmem_data_out,
  output logic        N,Z,C,V,
  output logic [31:0] PC,
  output logic [31:0] ALU_result,
  output logic [31:0] dmem_data_in
);

logic [31:0] result;
logic [31:0] src1,src2; //data read from addr1 and addr2 of regfile

logic [31:0] PC_next,PC_inc_4,PC_target_src1,PC_inc_target_out,PC_inc_target;

logic [31:0] ximm;  //output of immediate extend

///////////////////////////////////////////////////////////////////
//////////////////////// REGFILE LOGIC ////////////////////////////
///////////////////////////////////////////////////////////////////
regfile REGFILE (
  .clk                (clk),
  .regfile_wren       (regfile_wren),
  .read_addr1         (instruction[19:15]),
  .read_addr2         (instruction[24:20]),
  .write_addr3        (instruction[11:7]),
  .regfile_data_in3   (result),
  .regfile_data_out1  (src1),
  .regfile_data_out2  (dmem_data_in) //goes to dmem and alu mux
);

imm_extend IMM_EXTEND (
  .instruction  (instruction[31:7]),
  .ximm_sel     (ximm_sel),
  .ximm         (ximm)
);

///////////////////////////////////////////////////////////////////
/////////////////////////// ALU LOGIC /////////////////////////////
///////////////////////////////////////////////////////////////////
alu ALU (
  .ALU_control  (ALU_control),
  .src1         (src1),
  .src2         (src2),
  .ALU_result   (ALU_result),
  .Z            (Z)
);

mux2 ALU_bmux (
  .in1    (ximm),
  .in0    (dmem_data_in),
  .select (ALU_bsel),
  .out    (src2)
);

mux3 result_mux (
  .in2    (PC_inc_4),
  .in1    (dmem_data_out),
  .in0    (ALU_result),
  .select (result_sel),
  .out    (result)
);

///////////////////////////////////////////////////////////////////
////////////////////////// PC LOGIC ///////////////////////////////
///////////////////////////////////////////////////////////////////
myDFF #(
  .n(32)
) PC_register (
  .clk    (clk),
  .reset  (reset),
  .d      (PC_next),
  .q      (PC)
);

mux2 PC_next_mux (
  .in1    (PC_inc_target),
  .in0    (PC_inc_4),
  .select (PC_sel),
  .out    (PC_next)
);

mux2 PC_target_mux (        //modify DP for jalr
  .in1    (src1),           //from regfile
  .in0    (PC),
  .select (PC_target_sel),
  .out    (PC_target_src1)
);

mux2 PC_target_b0_mask ( //mask bit 0 if instruction is jalr
  .in1    ({PC_inc_target_out[31:1],1'b0}),
  .in0    (PC_inc_target_out),
  .select (PC_target_sel),
  .out    (PC_inc_target)
);

adder PC_increment_4 (
  .a(PC),
  .b(32'd4),
  .f(PC_inc_4)
);

adder PC_increment_target (
  .a(PC_target_src1),
  .b(ximm),
  .f(PC_inc_target_out)
);


endmodule