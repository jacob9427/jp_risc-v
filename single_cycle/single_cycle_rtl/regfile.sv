module regfile (
  input  logic        clk,
  input  logic        regfile_wren,
  input  logic [4:0]  read_addr1,
  input  logic [4:0]  read_addr2,
  input  logic [4:0]  write_addr3,
  input  logic [31:0] regfile_data_in3,
  output logic [31:0] regfile_data_out1,
  output logic [31:0] regfile_data_out2
);

//32 32 bit register
logic [31:0] register [0:31];

//for riscv, register 0 is hardwired to 0
assign regfile_data_out1 = (read_addr1 == 5'b0) ? 32'b0 : register[read_addr1];
assign regfile_data_out2 = (read_addr2 == 5'b0) ? 32'b0 : register[read_addr2];

always_ff @(posedge clk) begin
  if (regfile_wren && (write_addr3 != 5'b0) )
    register[write_addr3] <= regfile_data_in3;
end

endmodule