//operation parameters
parameter [1:0] add_op    = 2'b00; //lw/sw
parameter [1:0] sub_op    = 2'b01; //beq (for now)
parameter [1:0] other_op  = 2'b10; //

//function parameters (funct3)
parameter [2:0] add_sub_funct = 3'b000; //includes immediate for add
parameter [2:0] sll_funct     = 3'b001; //includes immediate
parameter [2:0] slt_funct     = 3'b010; //includes immediate
parameter [2:0] sltu_funct    = 3'b011; //includes immediate
parameter [2:0] xor_funct     = 3'b100; //includes immediate
parameter [2:0] srl_sra_funct = 3'b101; //includes immediate
parameter [2:0] or_funct      = 3'b110; //includes immediate
parameter [2:0] and_funct     = 3'b111; //includes immediate

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

//shift operation parameters
parameter [1:0] sll_sh_op = 2'b01;
parameter [1:0] srl_sh_op = 2'b10;
parameter [1:0] sra_sh_op = 2'b11;

module alu_decoder (
  input  logic        opcodeb5, //fifth bit of opcode
  input  logic  [1:0] ALU_op,
  input  logic  [2:0] funct3,
  input  logic        funct7b5,
  output logic  [3:0] ALU_control
);

always_comb begin
  case (ALU_op)
    add_op:   ALU_control = add_ctrl;
    sub_op:   ALU_control = sub_ctrl;
    other_op: case (funct3)
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
              default:    ALU_control = 3'bx;
    endcase
    default:  ALU_control = 3'bx;
  endcase
end


endmodule