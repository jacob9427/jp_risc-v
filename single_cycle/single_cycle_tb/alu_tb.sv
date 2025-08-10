//control parameters
parameter [3:0] add_ctrl_alu_tb  = 4'b0000;
parameter [3:0] sub_ctrl_alu_tb  = 4'b0001;
parameter [3:0] and_ctrl_alu_tb  = 4'b0010;
parameter [3:0] or_ctrl_alu_tb   = 4'b0011;

parameter [3:0] slt_ctrl_alu_tb  = 4'b0100;
parameter [3:0] sltu_ctrl_alu_tb = 4'b0101;

parameter [3:0] sll_ctrl_alu_tb  = 4'b1000;
parameter [3:0] sra_ctrl_alu_tb  = 4'b1001;
parameter [3:0] srl_ctrl_alu_tb  = 4'b1010;

parameter [3:0] xor_ctrl_alu_tb  = 4'b0110;

//RUN ON EDA PLAYGROUND OTHERWISE CERTAIN FEATURES WILL NOT WORK

module alu_tb ();

logic [3:0]  ALU_control;
logic [31:0] src1;
logic [31:0] src2;
logic [31:0] ALU_result;
logic        Z;

//used to prevent type mismatch for signed and unsigned value for sra
logic [31:0] expected_sra;

alu DUT (
  .ALU_control  (ALU_control),
  .src1         (src1),
  .src2         (src2),
  .ALU_result   (ALU_result),
  .Z            (Z)
);

class ALU_inputs;
  rand logic [3:0]  ctrl;
  rand logic [31:0] in1;
  rand logic [31:0] in2;

  //can only be these possibly values
  constraint legal_ctrl {
    ctrl inside {
      add_ctrl_alu_tb,
      sub_ctrl_alu_tb,
      and_ctrl_alu_tb,
      or_ctrl_alu_tb,
      slt_ctrl_alu_tb,
      sltu_ctrl_alu_tb,
      sll_ctrl_alu_tb,
      sra_ctrl_alu_tb,
      srl_ctrl_alu_tb,
      xor_ctrl_alu_tb
    };
  }
endclass


task automatic test_op (
  input  logic [3:0]  control,
  input  logic [31:0] in1,
  input  logic [31:0] in2
);

ALU_control   = control;
src1          = in1;
src2          = in2;
expected_sra  = $signed(src1) >>> src2[4:0];
#1;

  $display("CTRL=%b SRC1=%032b SRC2=%032b RESULT=%032b Z=%b",control,in1,in2,ALU_result,Z);

case (control)
  add_ctrl_alu_tb: begin
    assert(ALU_result == (in1 + in2)) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",in1+in2,ALU_result);
  end
  sub_ctrl_alu_tb: begin
    assert(ALU_result == (in1 - in2)) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",in1-in2,ALU_result);
  end
  and_ctrl_alu_tb: begin
    assert(ALU_result == (in1 & in2)) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",in1&in2,ALU_result);
  end
  or_ctrl_alu_tb:  begin
    assert(ALU_result == (src1 | src2)) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",in1|in2,ALU_result);
  end
  slt_ctrl_alu_tb: begin
    assert(ALU_result == (($signed(in1) < $signed(in2)) ? 32'd1 : 32'b0)) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",($signed(in1)<$signed(in2)),ALU_result);
  end
  sltu_ctrl_alu_tb: begin
    assert(ALU_result == (($unsigned(in1) < $unsigned(in2)) ? 32'd1 : 32'b0)) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",($unsigned(in1)<$unsigned(in2)),ALU_result);
  end
  sll_ctrl_alu_tb: begin
    assert(ALU_result == (src1 << src2[4:0])) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",(src1 << src2[4:0]),ALU_result);
  end
  sra_ctrl_alu_tb: begin
    assert(ALU_result == expected_sra) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",expected_sra,ALU_result);
  end
  srl_ctrl_alu_tb: begin
    assert(ALU_result == (src1 >> src2[4:0])) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",(src1 >> src2[4:0]),ALU_result);
  end
  xor_ctrl_alu_tb: begin
    assert(ALU_result == (src1 ^ src2)) $display("PASS");
    else $display("FAIL \nEXPECTED=%032b \nACTUAL  =%032b",in1^in2,ALU_result);
 end
endcase

endtask

// Run random tests
initial begin
  //declare handle (pointer-like variable) of class type ALU_inputs
  ALU_inputs input_gen;

  //use new() to allocate memory and contruct object of type ALU_inputs
  input_gen = new();

  //corner case to test ZERO signal
  test_op(sub_ctrl_alu_tb, 32'd12345, 32'd12345); // result will be 0
  test_op(and_ctrl_alu_tb, 32'd0, 32'd123);       // result will be 0
  test_op(or_ctrl_alu_tb, 32'd0, 32'd0);          // result will be 0

  for (int i = 0; i < 100; i++) begin
    assert(input_gen.randomize()); //calls the randomaize method on my object
    test_op(input_gen.ctrl, input_gen.in1, input_gen.in2);
  end

  $display("All tests completed.");
  $stop;
end

endmodule