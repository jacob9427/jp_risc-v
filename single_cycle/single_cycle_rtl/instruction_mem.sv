module instruction_mem ( //provided by ddca textbook
  input  logic [31:0] instruction_addr,
  output logic [31:0] instruction_read
);

logic [31:0] I_RAM [0:63];

// initial
//   $readmemh("file.txt",I_RAM);

assign instruction_read = I_RAM[instruction_addr[31:2]]; //ignore the 2 LSBs

endmodule