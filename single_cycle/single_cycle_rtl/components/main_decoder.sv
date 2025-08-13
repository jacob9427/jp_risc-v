//opcode parameters
parameter [6:0] lw_op     = 7'b0000011;
parameter [6:0] sw_op     = 7'b0100011;
parameter [6:0] jal_op    = 7'b1101111;
parameter [6:0] jalr_op   = 7'b1100111;
parameter [6:0] r_type_op = 7'b0110011; //signed and unsigned
parameter [6:0] b_type_op = 7'b1100011;
parameter [6:0] i_type_op = 7'b0010011; //signed and unsigned
parameter [6:0] lui_op    = 7'b0110111;
parameter [6:0] auipc_op  = 7'b0010111;

//control parameters
parameter [12:0] lw_ctrl     = 13'b1_000_1_0_01_0_00_0_0;
parameter [12:0] sw_ctrl     = 13'b0_001_1_1_00_0_00_0_0;
parameter [12:0] jal_ctrl    = 13'b1_011_0_0_10_0_00_1_0;
parameter [12:0] jalr_ctrl   = 13'b1_000_0_0_10_0_00_1_1;
parameter [12:0] r_type_ctrl = 13'b1_xxx_0_0_00_0_10_0_0;
parameter [12:0] b_type_ctrl = 13'b0_010_0_0_00_1_01_0_0;
parameter [12:0] i_type_ctrl = 13'b1_000_1_0_00_0_10_0_0;
parameter [12:0] lui_ctrl    = 13'b1_100_1_0_00_0_11_0_0;
parameter [12:0] auipc_ctrl  = 13'b1_100_x_0_11_0_11_0_0;

module main_decoder (
  input  logic  [6:0] opcode,
  output logic        dmem_wren,
  output logic        jump,
  output logic        branch,
  output logic        ALU_bsel,
  output logic        regfile_wren,
  output logic        PC_target_sel,
  output logic  [1:0] result_sel,
  output logic  [2:0] ximm_sel,
  output logic  [1:0] ALU_op
);

logic [12:0] controls;

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
    lui_op:       controls = lui_ctrl;
    auipc_op:     controls = auipc_ctrl;
    default:      controls = 13'b0;
  endcase
end

endmodule