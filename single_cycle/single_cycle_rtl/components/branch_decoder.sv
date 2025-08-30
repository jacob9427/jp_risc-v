//branch function parameters (funct3)
parameter [2:0] beq_funct_decode   = 3'b000;
parameter [2:0] bne_funct_decode   = 3'b001;
parameter [2:0] blt_funct_decode   = 3'b100;
parameter [2:0] bltu_funct_decode  = 3'b110;
parameter [2:0] bge_funct_decode   = 3'b101;
parameter [2:0] bgeu_funct_decode  = 3'b111;


module branch_decoder (
  input  logic [2:0] funct3,
  input  logic Z,
  input  logic ALU_resultb0, //bit 0
  output logic take_branch
);

always_comb begin
  case (funct3)
    beq_funct_decode:   take_branch = Z;
    bne_funct_decode:   take_branch = ~Z;
    blt_funct_decode:   take_branch = ALU_resultb0;
    bltu_funct_decode:  take_branch = ALU_resultb0;
    bge_funct_decode:   take_branch = ~ALU_resultb0;
    bgeu_funct_decode:  take_branch = ~ALU_resultb0;
    default: take_branch = 1'b0;
  endcase
end

endmodule