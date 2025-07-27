//operation parameters
parameter [1:0] add_op    = 2'b00;
parameter [1:0] sub_op    = 2'b01;
parameter [1:0] other_op  = 2'b10;

//function parameters
parameter [2:0] add_sub_funct = 3'b000;
parameter [2:0] and_funct     = 3'b111;
parameter [2:0] or_funct      = 3'b110;
parameter [2:0] slt_funct     = 3'b010;

//control parameters
parameter [2:0] add_ctrl  = 3'b000;
parameter [2:0] sub_ctrl  = 3'b001;
parameter [2:0] and_ctrl  = 3'b010;
parameter [2:0] or_ctrl   = 3'b011;
parameter [2:0] slt_ctrl  = 3'b101;

module alu_decoder (
  input  logic        opcodeb5, //fifth bit of opcode
  input  logic  [1:0] ALU_op,
  input  logic  [2:0] funct3,
  input  logic        funct7b5,
  output logic  [2:0] ALU_control
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
              and_funct:  ALU_control = and_ctrl;
              or_funct:   ALU_control = or_ctrl;
              slt_funct:  ALU_control = slt_ctrl;
              default:    ALU_control = 3'bx;
    endcase
    default:  ALU_control = 3'bx;
  endcase
end


endmodule