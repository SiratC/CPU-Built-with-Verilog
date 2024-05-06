module yMux(z, a, b, c);
output [SIZE - 1:0] z;
parameter SIZE = 2;
input [SIZE - 1:0] a, b;
input c;


yMux1 mine[SIZE - 1 :0](z, a, b, c);




endmodule