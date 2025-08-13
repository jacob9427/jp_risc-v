//control parameters
parameter [3:0] add_ctrl_alu  = 4'b0000;
parameter [3:0] sub_ctrl_alu  = 4'b0001;
parameter [3:0] and_ctrl_alu  = 4'b0010;
parameter [3:0] or_ctrl_alu   = 4'b0011;

parameter [3:0] slt_ctrl_alu  = 4'b0100;
parameter [3:0] sltu_ctrl_alu = 4'b0101;

parameter [3:0] sll_ctrl_alu  = 4'b1000;
parameter [3:0] sra_ctrl_alu  = 4'b1001;
parameter [3:0] srl_ctrl_alu  = 4'b1010;

parameter [3:0] xor_ctrl_alu  = 4'b0110;

parameter [3:0] lui_ctrl_alu    = 4'b0111;
parameter [3:0] auipc_ctrl_alu  = 4'b1011;

module alu (
  input  logic [3:0]  ALU_control,
  input  logic [31:0] src1,
  input  logic [31:0] src2,
  output logic [31:0] ALU_result,
  output logic        Z
);

always_comb begin
  case (ALU_control)
    add_ctrl_alu: begin
      ALU_result = src1 + src2;
    end
    sub_ctrl_alu: begin
      ALU_result = src1 - src2;
    end
    and_ctrl_alu: begin
      ALU_result = src1 & src2;
    end
    or_ctrl_alu: begin
      ALU_result = src1 | src2;
    end
    slt_ctrl_alu: begin
      ALU_result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'b0;
    end
    sltu_ctrl_alu: begin
      ALU_result = ($unsigned(src1) < $unsigned(src2)) ? 32'd1 : 32'b0;
    end
    xor_ctrl_alu: begin
      ALU_result = src1 ^ src2;
    end
    sll_ctrl_alu: begin
      ALU_result = src1 << src2[4:0];
    end
    sra_ctrl_alu: begin
      ALU_result = $signed(src1) >>> src2[4:0];
    end
    srl_ctrl_alu: begin
      ALU_result = src1 >> src2[4:0];
    end
    lui_ctrl_alu: begin
      ALU_result = src2;
    end
    default: begin
      ALU_result = 32'b0;
    end
  endcase
  
  Z = &(~ALU_result);
end


endmodule