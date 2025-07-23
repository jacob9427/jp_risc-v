module controller (
  input  logic [6:0]  opcode,
  input  logic [2:0]  funct3,
  input  logic        funct7b5,         //only fifth bit of funct7 matters for RV32I ISA
  input  logic        N,Z,C,V,          //status flags
  output logic        dmem_wren,        
  output logic        jump,
  output logic        PC_sel,           //mux for nextPC 
  output logic        ALU_bsel,         //mux which value to use for alu b input
  output logic        regfile_wren,     //write enable for registerfile 
  output logic [1:0]  result_sel,       //mux for which result to writeback to regfile
  output logic [1:0]  ximm_sel,         //select what type of extension to do
  output logic [2:0]  ALU_control       //choose which operation ALU should perform
);

logic [1:0] ALU_op;
logic       branch;

main_decoder MAIN_DECODER (
  .opcode       (opcode),
  .dmem_wren    (dmem_wren),
  .jump         (jump),
  .branch       (branch),
  .ALU_bsel     (ALU_bsel),
  .regfile_wren (regfile_wren),
  .result_sel   (result_sel),
  .ximm_sel     (ximm_sel),
  .ALU_op       (ALU_op)
);

alu_decoder ALU_DECODER (
  .opcodeb5     (opcode[5]),
  .ALU_op       (ALU_op),
  .funct3       (funct3),
  .funct7b5     (funct7b5),
  .ALU_control  (ALU_control)
);

assign PC_sel = (branch & Z) | jump;    //when to alter PC from something other than standard + 4 increment

endmodule