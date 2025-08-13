module mux4 #(parameter WIDTH = 32) (
  input  logic [WIDTH-1:0]  in3,in2,in1,in0,
  input  logic [1:0]        select,
  output logic [WIDTH-1:0]  out
);

always_comb begin
  case (select)
    2'b00:  out = in0;
    2'b01:  out = in1;
    2'b10:  out = in2;
    2'b11:  out = in3;
  endcase
end

endmodule