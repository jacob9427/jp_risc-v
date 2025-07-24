//control parameters
parameter [2:0] add_ctrl_alu  = 3'b000;
parameter [2:0] sub_ctrl_alu  = 3'b001;
parameter [2:0] and_ctrl_alu  = 3'b010;
parameter [2:0] or_ctrl_alu   = 3'b011;
parameter [2:0] slt_ctrl_alu  = 3'b101;

module alu (
  input  logic [2:0]  ALU_control,
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
      ALU_result = ($signed(src1) < $signed(src2)) ? 32'b1 : 32'b0;
    end

    default: begin
      ALU_result = 32'b0;
    end
  endcase
  
  Z = (ALU_result == 32'b0);
end


endmodule