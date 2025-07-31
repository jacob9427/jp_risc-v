module riscv_single (
  input  logic clk,
  input  logic reset,
  input  logic [31:0] instruction,
  input  logic [31:0] dmem_data_out,
  output logic        dmem_wren,
  output logic [31:0] PC,
  output logic [31:0] ALU_result,
  output logic [31:0] dmem_data_in
);

//datapath to controller signals
logic N,Z,C,V; //neg,zero,carry,overflow control signals
//usage tbd

//controller to datapath signals:
logic         PC_sel;           //mux for nextPC
logic         ALU_bsel;         //mux which value to use for alu b input
logic         regfile_wren;     //write enable for registerfile
logic [1:0]   result_sel;       //mux for which result to writeback to regfile
logic [1:0]   ximm_sel;         //select what type of sign extension to do
logic [3:0]   ALU_control;      //choose which operation ALU should perform


controller CONTROLLER (
  .opcode       (instruction[6:0]),
  .funct3       (instruction[14:12]),
  .funct7b5     (instruction[30]),
  .N            (N),
  .Z            (Z),
  .C            (C),
  .V            (V),
  .dmem_wren    (dmem_wren),
  .PC_sel       (PC_sel),
  .ALU_bsel     (ALU_bsel),
  .regfile_wren (regfile_wren),
  .result_sel   (result_sel),
  .ximm_sel     (ximm_sel),
  .ALU_control  (ALU_control)
);

datapath DATAPATH (
  .clk            (clk),
  .reset          (reset),
  .regfile_wren   (regfile_wren),
  .PC_sel         (PC_sel),
  .ALU_bsel       (ALU_bsel),
  .result_sel     (result_sel),
  .ximm_sel       (ximm_sel),
  .ALU_control    (ALU_control),
  .instruction    (instruction),
  .dmem_data_out  (dmem_data_out),
  .N              (N),
  .Z              (Z),
  .C              (C),
  .V              (V),
  .PC             (PC),
  .ALU_result     (ALU_result),
  .dmem_data_in   (dmem_data_in)
);

endmodule