module controller (
  input  logic [6:0]  opcode,
  input  logic [2:0]  funct3,
  input  logic        funct7b5,         //only fifth bit of funct7 matters for RV32I ISA
  input  logic        N,Z,C,V,          //status flags
  output logic        dmem_write,        
  output logic        jump,
  output logic        PC_sel,           //mux for nextPC 
  output logic        ALU_bsel,         //mux which value to use for alu b input
  output logic        regfile_wren,     //write enable for registerfile 
  output logic [1:0]  result_sel,       //mux for which result to writeback to regfile
  output logic [1:0]  ximm_sel,         //select what type of extension to do
  output logic [2:0]  ALU_control       //choose which operation ALU should perform
);

logic [1:0] ALUop;
logic       branch;

main_decoder MAIN_DECODER (

);

alu_decoder ALU_DECODER (

);

assign PC_sel = (branch & Z) | jump;    //when to alter PC from something other than standard + 4 increment

endmodule