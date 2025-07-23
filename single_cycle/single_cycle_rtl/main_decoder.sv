//opcode parameters
parameter [6:0] lw_op     = 7'b0000011;
parameter [6:0] sw_op     = 7'b0100011;
parameter [6:0] r_type_op = 7'b0110011;
parameter [6:0] beq_op    = 7'b1100011;
parameter [6:0] i_type_op = 7'b0010011;
parameter [6:0] jal_op    = 7'b1101111;

//control parameters
parameter [10:0] lw_ctrl     = 11'b1_00_1_0_01_0_00_0;
parameter [10:0] sw_ctrl     = 11'b0_01_1_1_00_0_00_0;
parameter [10:0] r_type_ctrl = 11'b1_xx_0_0_00_0_10_0;
parameter [10:0] beq_ctrl    = 11'b0_10_0_0_00_1_01_0;
parameter [10:0] i_type_ctrl = 11'b1_00_1_0_00_0_10_0;
parameter [10:0] jal_ctrl    = 11'b1_11_0_0_10_0_00_1;

module main_decoder (
  input  logic  [6:0] opcode,
  output logic        dmem_wren,
  output logic        jump,
  output logic        branch,
  output logic        ALU_bsel,
  output logic        regfile_wren,
  output logic  [1:0] result_sel,
  output logic  [1:0] ximm_sel, 
  output logic  [1:0] ALU_op
);

logic [10:0] controls;

assign {regfile_wren,ximm_sel,ALU_bsel,dmem_wren,result_sel,branch,ALU_op,jump} = controls;

always_comb begin
  case (opcode)
    lw_op:        controls = lw_ctrl;
    sw_op:        controls = sw_ctrl;
    r_type_op:    controls = r_type_ctrl;
    beq_op:       controls = beq_ctrl;
    i_type_op:    controls = i_type_ctrl;
    jal_op:       controls = jal_ctrl;
    default:      controls = 11'b0;
  endcase
end

endmodule