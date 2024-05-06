module yArith(z, cout, a, b, ctrl);
// add if ctrl=0, subtract if ctrl=1
output [31:0] z;
output cout;
input [31:0] a, b;
input ctrl;
wire[31:0] notB, tmp; // notB is 2's complement (flipped binary without +1)
wire cin;

// instantiate the components and connect them
// Hint: about 4 lines of code


not myNot[31:0](notB, b);
assign cin = ctrl;
// 32 bit mux - if b is 0 then ctrl 0 = add operator calculated 
// otherwise b = notB meaning 1; ctrl = 1 and subtract operator calculated
// selected value stored in tmp or z 
yMux #(32) m(tmp, b, notB, cin); 
yAdder adder(z, cout, a ,tmp , cin); // performs operation



endmodule