module riscv_single_top_tb ();

logic clk = 0;
logic reset;

riscv_single_top DUT (
  .clk    (clk),
  .reset  (reset)
);

initial begin
  repeat (50) 
    #5 clk = ~clk;
end


initial begin
  reset = 1;
  #20;
  reset = 0;
end

always @(negedge clk) begin
  if (DUT.DATA_MEM.D_RAM[25] == 32'd25) begin // 100/4 = 25
    $display("end of program reached!");
    $finish;
  end
end

endmodule