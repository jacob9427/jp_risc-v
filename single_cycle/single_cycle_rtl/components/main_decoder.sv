//opcode parameters
parameter [6:0] lw_op     = 7'b0000011;
parameter [6:0] sw_op     = 7'b0100011;
parameter [6:0] jal_op    = 7'b1101111;
parameter [6:0] jalr_op   = 7'b1100111;
parameter [6:0] r_type_op = 7'b0110011; //signed and unsigned
parameter [6:0] b_type_op = 7'b1100011;
parameter [6:0] i_type_op = 7'b0010011; //signed and unsigned
parameter [6:0] u_type_op = 7'b0110111;

//control parameters
parameter [11:0] lw_ctrl     = 12'b1_00_1_0_01_0_00_0_0;
parameter [11:0] sw_ctrl     = 12'b0_01_1_1_00_0_00_0_0;
parameter [11:0] jal_ctrl    = 12'b1_11_0_0_10_0_00_1_0;
parameter [11:0] jalr_ctrl   = 12'b1_00_0_0_10_0_00_1_1;
parameter [11:0] r_type_ctrl = 12'b1_xx_0_0_00_0_10_0_0;
parameter [11:0] b_type_ctrl = 12'b0_10_0_0_00_1_01_0_0;
parameter [11:0] i_type_ctrl = 12'b1_00_1_0_00_0_10_0_0;

module main_decoder (
  input  logic  [6:0] opcode,
  output logic        dmem_wren,
  output logic        jump,
  output logic        branch,
  output logic        ALU_bsel,
  output logic        regfile_wren,
  output logic        PC_target_sel,
  output logic  [1:0] result_sel,
  output logic  [1:0] ximm_sel,
  output logic  [1:0] ALU_op
);

logic [11:0] controls;

assign {regfile_wren,ximm_sel,ALU_bsel,dmem_wren,result_sel,branch,ALU_op,jump,PC_target_sel} = controls;

always_comb begin
  case (opcode)
    lw_op:        controls = lw_ctrl;
    sw_op:        controls = sw_ctrl;
    jal_op:       controls = jal_ctrl;
    jalr_op:      controls = jalr_ctrl;
    r_type_op:    controls = r_type_ctrl;
    b_type_op:    controls = b_type_ctrl;
    i_type_op:    controls = i_type_ctrl;
    default:      controls = 11'b0;
  endcase
end

endmodule