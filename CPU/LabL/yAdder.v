module yAdder(z, cout, a, b, cin); 
output [31:0] z; 
output cout; 
input [31:0] a, b; 
input cin; 
wire[31:0] in, out;

yAdder1 mine[31:0](z, out, a, b, in); 

assign in[0] = cin; // single bit cin
assign in[31:1] = out[30:0]; //LSB
assign cout = out[31]; //MSB (overflow)

endmodule