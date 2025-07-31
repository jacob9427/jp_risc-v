module imm_extend (
  input  logic [31:7] instruction,
  input  logic [1:0]  ximm_sel, //modify
  output logic [31:0] ximm
);

always_comb begin
  case (ximm_sel)
              //I type, 12bit signed immediate
    2'b00:    ximm = {{20{instruction[31]}},instruction[31:20]};  
              //S type, 12bit signed immediate (store)
    2'b01:    ximm = {{20{instruction[31]}},instruction[31:25],instruction[11:7]}; 
              //B type, 13bit signed immediate (branch)
    2'b10:    ximm = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};
              //J type, 21bit signed immediate
    2'b11:    ximm = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0}; 
              //U type, top 20bits of register
              // ximm = {instruction[31:12],12'b0};
    default:  ximm = 32'b0;
  endcase
end

endmodule