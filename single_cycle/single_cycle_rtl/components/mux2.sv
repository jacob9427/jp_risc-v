module mux2 #(parameter WIDTH = 32) (
  input  logic [WIDTH-1:0]  in1,in0,
  input  logic              select,
  output logic [WIDTH-1:0]  out
);

assign out = select ? in1 : in0;

endmodule