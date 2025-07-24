module instruction_mem_tb ();

logic [31:0] instruction_addr;
logic [31:0] instruction_read;

instruction_mem DUT (
  .instruction_addr (instruction_addr),
  .instruction_read (instruction_read)
);

integer i;

initial begin
  $display("reading all instruction memory addresses");

  for (i = 0; i < 24; i = i + 1) begin
    instruction_addr = i << 2;
    #1;
    $display("Address: 0x%08h\nData:    0x%08h\n", instruction_addr,instruction_read);
  end

  $finish;
end
endmodule