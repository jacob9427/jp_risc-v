parameter [3:0] sll_ctrl_shift  = 4'b1000;
parameter [3:0] sra_ctrl_shift  = 4'b1001;
parameter [3:0] srl_ctrl_shift  = 4'b1010;

module shifter (
  input  logic [3:0]  sh_op,
  input  logic [4:0]  shamt,
  input  logic [31:0] sh_in,
  output logic [31:0] sh_out
);

always_comb begin
  case (sh_op)
    sll_ctrl_shift: sh_out = sh_in << shamt;            //SLL
    srl_ctrl_shift: sh_out = sh_in >> shamt;            //SRL
    sra_ctrl_shift: sh_out = $signed(sh_in) >>> shamt;  //SRA
    default:        sh_out = sh_in;                     //no shift
  endcase
end

endmodule