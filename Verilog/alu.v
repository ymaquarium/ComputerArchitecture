module test_alu;
reg [4:0] operation, shift, opr;
reg [31:0] operand1, operand2, result;


function [31:0] alu;
input [4:0] opr, shift;
input [31:0] operand1, operand2;
  case (opr)
    5'd0:alu = operand1 + operand2;
    5'd2:alu = operand1 + operand2;
    5'd8:alu = operand1 & operand2;
    5'd9:alu = operand1 | operand2;
    5'd10:alu = operand1 ^ operand2;
    5'd11:alu = ~(operand1 | operand2);
    5'd16:alu = operand1 << shift;
    5'd17:alu = operand1 >> shift;
    5'd18:alu = operand1 >>> shift;
    default:alu = 32'hffffffff;
  endcase
endfunction

initial begin
      opr = 0; shift = 0;
      operand1 = 32'h00000000; operand2 = 32'h00000000;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'h00000000; operand2 = 32'h00000001;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'h0fffffff; operand2 = 32'h00000001;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'hffffffff; operand2 = 32'hffffffff;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 1;
      operand1 = 32'h00000000; operand2 = 32'h00000000;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'hffffffff; operand2 = 32'hfffffffe;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 8;
      operand1 = 32'h00000000; operand2 = 32'hffffffff;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'h55555555; operand2 = 32'haaaaaaaa;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'hffffffff; operand2 = 32'hffffffff;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 9;
      operand1 = 32'h00000000; operand2 = 32'hffffffff;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'h55555555; operand2 = 32'haaaaaaaa;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 10;
      operand1 = 32'h00000000; operand2 = 32'hffffffff;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'h55555555; operand2 = 32'h55555555;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 11;
      operand1 = 32'h00000000; operand2 = 32'hffffffff;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'h55555555; operand2 = 32'h55555555;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 16;
      operand1 = 32'h12345678; operand2 = 2'h1;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 16;
      operand1 = 32'h12345678; operand2 = 2'h1;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 17;
      operand1 = 32'h12345678; operand2 = 2'h1;
      result = alu(opr, shift, operand1, operand2);
#100  opr = 18;
      operand1 = 32'h12345678; operand2 = 2'h1;
      result = alu(opr, shift, operand1, operand2);
#100  operand1 = 32'h92345678; operand2 = 2'h1;
      result = alu(opr, shift, operand1, operand2);
#100  operation = 2;
      result = alu(opr, shift, operand1, operand2);
end

initial begin
  $monitor($stime, "op = %h, shift = %h, op1 = %h, op2 = %h, result = %h", opr, shift, operand1, operand2, result);
end

endmodule
