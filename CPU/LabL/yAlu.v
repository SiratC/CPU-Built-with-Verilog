module yAlu(z, ex, a, b, op);
input [31:0] a, b;
input [2:0] op; 
output [31:0] z;
output ex;

assign slt[31:1] = 0; // upper bits
assign ex = 0;

// instantiate the components and connect them
// Hint: about 4 lines of code
wire [31:0] and1, m_or, arith1, arith2, slt;
wire cond;

and m_and[31:0](and1, a , b);
or m_or1[31:0](m_or, a, b);
yArith m_arith(arith1, null, a, b, op[2]); // null for cout
                                      // 1'b1 a single bit of 1 and null for cout
yMux4to1 #(32) m_M4(z, and1, m_or, arith1, slt, op[1:0]); // yMux4to1(z, a0,a1,a2,a3, c)

// instantiate a circuit to set slt[0]
// Hint: about 2 lines of code
// for slt operation
xor m_xor(cond, a[31], b[31]);
yArith ari(arith2, null, a, b, 1'b1); // yArith(z, cout, a, b, ctrl), where cout is null
yMux1 m(slt[0], arith2[31], a[31], cond); // yMux(z, a, b, c);
                                        // since slt 31 to 1 all is set to 0 except slt[0] is not set to 0

// The output for ex = 1 when z = 0
wire [15:0] z16;
wire [7:0] z8;
wire [3:0] z4;
wire [1:0] z2;
wire z1;

// Don't understand this 
//series of or operations
// or or16[15:0](z16, z[15:0], z[31:16]);
// or or8[7:0](z8, z16[7:0], z16[15:8]);
// or or4[3:0](z4, z8[3:0], z8[7:4]);
// or or2[1:0](z2, z4[1:0], z4[3:2]);
// or or1[15:0](z1, z2[0:0], z2[1:1]);
// not m_not(ex, z1);

endmodule