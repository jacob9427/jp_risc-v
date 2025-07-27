module riscv_single_top_tb ();

logic clk = 0;
logic reset;

riscv_single_top DUT (
  .clk    (clk),
  .reset  (reset)
);

always
  #5 clk = ~clk;

initial begin
  reset = 1;
  #20;
  reset = 0;
end

always @(negedge clk) begin
  if (DUT.DATA_MEM.D_RAM[100] == 32'd25) begin
    $display("end of program reached!");
    $finish;
  end
end

endmodule