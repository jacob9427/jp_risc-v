module data_mem ( //provided by ddca textbook
  input  logic        clk,
  input  logic        data_wren,
  input  logic [31:0] dmem_data_in,
  input  logic [31:0] dmem_addr,
  output logic [31:0] dmem_data_out
);

logic [31:0] D_RAM [0:63];

assign dmem_data_out = D_RAM[dmem_addr[31:2]];

always_ff @(posedge clk)
  if (data_wren) D_RAM[dmem_addr[31:2]] <= dmem_data_in;

endmodule