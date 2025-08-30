//operation parameters
parameter [1:0] add_op    = 2'b00; //lw/sw/jalr
parameter [1:0] branch_op = 2'b01; //branch operations
parameter [1:0] irrr_op   = 2'b10; //integer register & register reigster ops
parameter [1:0] ui_op     = 2'b11; //for upper immmediate instructions

//irrr function parameters (funct3)
parameter [2:0] add_sub_funct = 3'b000; //includes immediate for add
parameter [2:0] sll_funct     = 3'b001; //includes immediate
parameter [2:0] slt_funct     = 3'b010; //includes immediate
parameter [2:0] sltu_funct    = 3'b011; //includes immediate
parameter [2:0] xor_funct     = 3'b100; //includes immediate
parameter [2:0] srl_sra_funct = 3'b101; //includes immediate
parameter [2:0] or_funct      = 3'b110; //includes immediate
parameter [2:0] and_funct     = 3'b111; //includes immediate

//branch function parameters (funct3)
parameter [2:0] beq_funct   = 3'b000;
parameter [2:0] bne_funct   = 3'b001;
parameter [2:0] blt_funct   = 3'b100;
parameter [2:0] bltu_funct  = 3'b110;
parameter [2:0] bge_funct   = 3'b101;
parameter [2:0] bgeu_funct  = 3'b111;

//control parameters
parameter [3:0] add_ctrl  = 4'b0000;
parameter [3:0] sub_ctrl  = 4'b0001;
parameter [3:0] and_ctrl  = 4'b0010;
parameter [3:0] or_ctrl   = 4'b0011;

parameter [3:0] slt_ctrl  = 4'b0100;
parameter [3:0] sltu_ctrl = 4'b0101;

parameter [3:0] sll_ctrl  = 4'b1000;
parameter [3:0] sra_ctrl  = 4'b1001;
parameter [3:0] srl_ctrl  = 4'b1010;

parameter [3:0] xor_ctrl  = 4'b0110;

parameter [3:0] lui_dec_ctrl    = 4'b0111;
parameter [3:0] auipc_dec_ctrl  = 4'b1011;

module alu_decoder (
  input  logic        opcodeb5, //fifth bit of opcode
  input  logic  [1:0] ALU_op,
  input  logic  [2:0] funct3,
  input  logic        funct7b5,
  output logic  [3:0] ALU_control
);

always_comb begin
  case (ALU_op)
    add_op:     ALU_control = add_ctrl;
    branch_op:  case (funct3)
      beq_funct:  ALU_control = sub_ctrl;
      bne_funct:  ALU_control = sub_ctrl;
      blt_funct:  ALU_control = slt_ctrl;
      bltu_funct: ALU_control = sltu_ctrl;
      bge_funct:  ALU_control = slt_ctrl;
      bgeu_funct: ALU_control = sltu_ctrl;
      default:    ALU_control = 4'bx;
    endcase
    irrr_op:    case (funct3)
      add_sub_funct: begin 
        if (funct7b5 & opcodeb5)
            ALU_control = sub_ctrl;
        else
            ALU_control = add_ctrl;
      end
      srl_sra_funct: begin
        if (funct7b5)
          ALU_control = sra_ctrl;
        else
          ALU_control = srl_ctrl;
      end
      sll_funct:  ALU_control = sll_ctrl;
      slt_funct:  ALU_control = slt_ctrl;
      sltu_funct: ALU_control = sltu_ctrl;
      xor_funct:  ALU_control = xor_ctrl;
      or_funct:   ALU_control = or_ctrl;
      and_funct:  ALU_control = and_ctrl;
      default:    ALU_control = 4'bx;
    endcase
    ui_op:      ALU_control = opcodeb5 ? lui_dec_ctrl : auipc_dec_ctrl;
    default:    ALU_control = 4'bx;
  endcase
end


endmodule