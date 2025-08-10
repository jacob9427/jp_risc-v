module riscv_single_top (
  input  logic  clk,
  input  logic  reset
);

//logic clk;
//assign clk = CLOCK_50;

//instruction mem signals
logic [31:0] instruction; //from imem -> controller & datapath
logic [31:0] PC;          //from datapath -> imem

//data mem signals
logic        dmem_wren;     //from controller -> datamem
logic [31:0] dmem_addr;     //from datapath -> datamem
logic [31:0] dmem_data_in;  //from datapath -> datamem
logic [31:0] dmem_data_out; //from datamem -> datapath

riscv_single RISCV_SINGLE (
  .clk            (clk),
  .reset          (reset),
  .instruction    (instruction),
  .dmem_data_out  (dmem_data_out),
  .dmem_wren      (dmem_wren),
  .PC             (PC),
  .ALU_result     (dmem_addr),  //result of ALU computation or address for D RAM
  .dmem_data_in   (dmem_data_in)
);

instruction_mem INSTRUCTION_MEM (
  .instruction_addr (PC),
  .instruction_read (instruction)
);

data_mem DATA_MEM (
  .clk            (clk),
  .data_wren      (dmem_wren),  //write enable
  .dmem_data_in   (dmem_data_in), //actual data
  .dmem_addr      (dmem_addr),  //address
  .dmem_data_out  (dmem_data_out)   //data read from dmem
);

endmodule