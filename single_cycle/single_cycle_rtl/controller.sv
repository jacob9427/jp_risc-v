module controller (  
  input  logic [6:0]  opcode,
  input  logic [2:0]  funct3,
  input  logic        funct7b5,         //only fifth bit of funct7 matters for RV32I ISA
  input  logic        ALU_resultb0,
  input  logic        N,Z,C,V,    
  output logic        dmem_wren,
  output logic        PC_sel,           //mux for nextPC
  output logic        PC_target_sel,
  output logic        ALU_bsel,         //mux which value to use for alu b input
  output logic        regfile_wren,     //write enable for registerfile 
  output logic [1:0]  result_sel,       //mux for which result to writeback to regfile
  output logic [2:0]  ximm_sel,         //select what type of extension to do
  output logic [3:0]  ALU_control       //choose which operation ALU should perform
);

logic [1:0] ALU_op;
logic       branch;
logic       jump;
logic       take_branch;

main_decoder MAIN_DECODER (
  .opcode         (opcode),
  .dmem_wren      (dmem_wren),
  .jump           (jump),
  .branch         (branch),
  .ALU_bsel       (ALU_bsel),
  .regfile_wren   (regfile_wren),
  .PC_target_sel  (PC_target_sel),
  .result_sel     (result_sel),
  .ximm_sel       (ximm_sel),
  .ALU_op         (ALU_op)
);

alu_decoder ALU_DECODER (
  .opcodeb5     (opcode[5]),
  .ALU_op       (ALU_op),
  .funct3       (funct3),
  .funct7b5     (funct7b5),
  .ALU_control  (ALU_control)
);

branch_decoder BRANCH_DECODER (
  .funct3       (funct3),
  .Z            (Z),
  .ALU_resultb0 (ALU_resultb0),
  .take_branch  (take_branch)
);

assign PC_sel = (branch & take_branch) | jump;    //when to alter PC from something other than standard + 4 increment

endmodule