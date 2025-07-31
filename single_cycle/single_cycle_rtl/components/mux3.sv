module mux3 #(parameter WIDTH = 32) (
  input  logic [WIDTH-1:0]  in2,in1,in0,
  input  logic [1:0]        select,
  output logic [WIDTH-1:0]  out
);

assign out = select[1] ? in2: 
            (select[0] ? in1 : in0);

endmodule