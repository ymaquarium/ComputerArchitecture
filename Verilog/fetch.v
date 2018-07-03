//命令フェッチ
module fetch(pc, ins);
  input [31:0] pc;
  output [31:0] ins;
  reg [31:0] ins_mem [0:255];
  initial
    $readmemb("sample.bnr", ins_mem[0:255]);
  assign ins = ins_mem[pc];
endmodule

module tfetch;
  reg clk, rst;
  reg [31:0] pc;
  wire [31:0] ins;

initial begin
  clk = 0; forever #50 clk = !clk;
end

initial begin
  rstd = 1;
  #10 rst = 0;
  #20 rst = 1;
end

always @ (negedge rst or posedge clk) begin
  if (rst == 0) pc <= 0;
  else if (clk == 1) pc <= pc + 1;
end

initial
  $monitor($stime, "\rstd = %b, clk = %b, pc = %d, ins = %b", rstd, clk, pc, ins);

fetch fetch_body(pc, ins);
endmodule
