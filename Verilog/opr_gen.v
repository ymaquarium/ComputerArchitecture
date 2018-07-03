module test_opr_gen;
  reg [5:0] op;
  reg [4:0] operation;
  reg [4:0] opr;

function [4:0] opr_gen;
input [5:0] op;
input [4:0] operation;
  case(op)
    6'd0:opr_gen = operation;
    6'd1:opr_gen = 5'd0;
    6'd4:opr_gen = 5'd8;
    6'd5:opr_gen = 5'd9;
    6'd6:opr_gen = 5'd10;
    6'd16, 6'd18, 6'd20, 6'd24, 6'd26, 6'd28: opr_gen = 5'd0; //メモリアドレス計算用
    default:opr_gen = 5'h1f;
  endcase
endfunction

initial begin
       op = 6'd0:operation = 5'd0:opr=opr_gen(op, operation);
  #100 op = 6'd0:operation = 5'd8:opr=opr_gen(op, operation);
  #100 op = 6'd0:operation = 5'd11:opr=opr_gen(op, operation);
  #100 op = 6'd1:operation = 5'd0:opr=opr_gen(op, operation);
  #100 op = 6'd4:operation = 5'd3:opr=opr_gen(op, operation);
  #100 op = 6'd5:operation = 5'd9:opr=opr_gen(op, operation);
  #100 op = 6'd6:operation = 5'd11:opr=opr_gen(op, operation);
  #100 op = 6'd2:operation = 5'd0:opr=opr_gen(op, operation);
  #100 op = 6'd10:operation = 5'd11:opr=opr_gen(op, operation);
end

initial begin
  $monitor($stime, "op = %d, operation = %d, opr = %d", op, operation, opr);
end

endmodule
