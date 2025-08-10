module regfile_tb ();

logic        clk = 1'b0;
logic        regfile_wren;
logic [4:0]  read_addr1;
logic [4:0]  read_addr2;
logic [4:0]  write_addr3;
logic [31:0] regfile_data_in3;
logic [31:0] regfile_data_out1;
logic [31:0] regfile_data_out2;

//testbench signals
logic [31:0]  d1,d2,read_val; 

regfile DUT (
.clk                (clk),
.regfile_wren       (regfile_wren),
.read_addr1         (read_addr1),
.read_addr2         (read_addr2),
.write_addr3        (write_addr3),
.regfile_data_in3   (regfile_data_in3),
.regfile_data_out1  (regfile_data_out1),
.regfile_data_out2  (regfile_data_out2)
);

//clock
initial forever begin
  clk = ~clk; #5;
end

//write task
task automatic write_rf (
  input  logic [31:0] addr,
  input  logic [31:0] data
);

@(posedge clk);
regfile_wren      = 1'b1;
write_addr3       = addr;
regfile_data_in3  = data;

@(posedge clk);
regfile_wren      = 1'b0;


endtask

//reading task
task automatic read_rf (
  input  logic [31:0] addr1,
  input  logic [31:0] addr2,
  output logic [31:0] data1,
  output logic [31:0] data2
);

read_addr1 = addr1;
read_addr2 = addr2;

@(posedge clk);
data1 = regfile_data_out1;
data2 = regfile_data_out2;

endtask

initial begin
  //initialize signals
  regfile_wren      = 0;
  write_addr3       = 0;
  regfile_data_in3  = 0;
  read_addr1        = 0;
  read_addr2        = 0;

  for (int i = 0; i < 32; i++) begin
    write_rf (
      .addr(i),
      .data(i + 100)
    );
  end

  //check that if i change data in for writing, the value does not change
  regfile_wren = 0;
  write_addr3 = 5'd5;
  regfile_data_in3 = 32'hDEADBEEF;
  @(posedge clk);

  read_rf (
    .addr1(write_addr3),    
    .addr2(write_addr3),//checks next register
    .data1(read_val),
    .data2(read_val)
  );
  assert(read_val != 32'hDEADBEEF)
    $display("passed wren = 0 test");
  else
    $error("FAIL: write occured when wren = 0");

  //test corner case make sure register 0 is still 0
  read_addr1 = 5'b0;
  @(posedge clk) begin
    assert(regfile_data_out1 == 32'd0)
      $display("register 0 corner case passed");
    else 
      $error("register 0 corner case failed");
  end

  //test register 31 to make next test easier
  read_addr1 = 5'd31;
  @(posedge clk) begin
    assert(regfile_data_out1 == 32'd131)
      $display("register 31 case passed");
    else 
      $error("register 31 case failed");
  end

  //check register 1-30 using both read ports
  for (int j = 1; j < 30; j += 2) begin //goes up to register 30
    read_rf (
      .addr1(j),    
      .addr2(j + 1),//checks next register
      .data1(d1),
      .data2(d2)
    );
    assert(d1 == j + 100)
      $display("register %d passed",j);
    else
      $error("register %d failed",j);

    assert(d2 == j + 101)
      $display("register %d passed",j + 1);
    else
      $error("register %d failed",j + 1);
  end

  $stop;

  
end

endmodule