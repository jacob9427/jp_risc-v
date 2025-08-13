module instruction_mem ( //provided by ddca textbook
  input  logic [31:0] instruction_addr,
  output logic [31:0] instruction_read
);

//for synthesis
//(* ram_init_file = "program1.hex" *)
logic [31:0] I_RAM [0:1023];

//for simulation
initial $readmemh("C:/Users/jacob/Downloads/jp_risc-v/single_cycle/programs/program4.hex",I_RAM);

assign instruction_read = I_RAM[instruction_addr[31:2]]; //ignore the 2 LSBs

endmodule