//---------------------------------------- MUX1  ---------------------------------------
module yMux1(z, a, b, c);
output z;
input a, b, c;
wire notC, upper, lower;

not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, c, b);
or my_or(z, upper, lower);

endmodulemodule yMux(z, a, b, c);
output [SIZE - 1:0] z;
parameter SIZE = 2;
input [SIZE - 1:0] a, b;
input c;

/*
yMux1 upper(z[0], a[0], b[0], c);
yMux1 lower(z[1], a[1], b[1], c);
*/

yMux1 mine[SIZE - 1 :0](z, a, b, c);




endmodule

//--------------------------------------------------------------------------------------
//----------------------------------------MUX4to1---------------------------------------
module yMux4to1(z, a0,a1,a2,a3, c);
parameter SIZE = 2;
output [SIZE-1:0] z;
input [SIZE-1:0] a0, a1, a2, a3;
input [1:0] c;
wire [SIZE-1:0] zLo, zHi;

yMux #(SIZE) lo(zLo, a0, a1, c[0]);
yMux #(SIZE) hi(zHi, a2, a3, c[0]);
yMux #(SIZE) final(z, zLo, zHi, c[1]);

endmodulemodule yAdder1(z, cout, a, b, cin);
output z, cout;
input a, b, cin;

xor left_xor(tmp, a, b);
xor right_xor(z, cin, tmp);
and left_and(outL, a, b);
and right_and(outR, tmp, cin);
or my_or(cout, outR, outL);

endmodule

//---------------------------------------------------------------------------------------
//-------------------------------------Adder1--------------------------------------------
module yAdder1(z, cout, a, b, cin); 
output z, cout; 
input a, b, cin; 
xor left_xor(tmp, a, b); 
xor right_xor(z, cin, tmp); 
and left_and(outL, a, b); 
and right_and(outR, tmp, cin); 
or my_or(cout, outR, outL); 
endmodule 

//--------------------------------------------------------------------------------------
//----------------------------------------yAdder---------------------------------------
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

//--------------------------------------------------------------------------------------
//----------------------------------------yArith---------------------------------------
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

//--------------------------------------------------------------------------------------
//----------------------------------------yALU---------------------------------------
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

//--------------------------------------------------------------------------------------------

//-----------------------------------------yIF-------------------------------------------------
module yIF(ins, PC, PCp4, PCin, clk);
output [31:0] ins, PC, PCp4;
input [31:0] PCin;
input clk;
wire zero;
wire read, write, enable;
wire [31:0] a, memIn;
wire [2:0] op;
register #(32) pcReg(PC, PCin, clk, enable);
mem insMem(ins, PC, memIn, clk, read, write);
yAlu myAlu(PCp4, zero, a, PC, op);
assign enable = 1'b1;
assign a = 32'h0004;
assign op = 3'b010;
assign read = 1'b1;
assign write = 1'b0;
endmodule
//-----------------------------------------------------------------------------------------------

//-----------------------------------------yID---------------------------------------------------
module yID(rd1, rd2, immOut, jTarget, branch, ins, wd, RegWrite, clk);
output [31:0] rd1, rd2, immOut;
output [31:0] jTarget;
output [31:0] branch;

input [31:0] ins, wd;
input RegWrite, clk;

wire [19:0] zeros, ones; // For I-Type and SB-Type
wire [11:0] zerosj, onesj; // For UJ-Type
wire [31:0] imm, saveImm; // For S-Type

rf myRF(rd1, rd2, ins[19:15], ins[24:20], ins[11:7], wd, clk, RegWrite);

assign imm[11:0] = ins[31:20];
assign zeros = 20'h00000;
assign ones = 20'hFFFFF;
yMux #(20) se(imm[31:12], zeros, ones, ins[31]);

assign saveImm[11:5] = ins[31:25];
assign saveImm[4:0] = ins[11:7];
yMux #(20) saveImmSe(saveImm[31:12], zeros, ones, ins[31]);

yMux #(32) immSelection(immOut, imm, saveImm, ins[5]);

assign branch[11] = ins[31];
assign branch[10] = ins[7];
assign branch[9:4] = ins[30:25];
assign branch[3:0] = ins[11:8];
yMux #(20) bra(branch[31:12], zeros, ones, ins[31]);

assign zerosj = 12'h000;
assign onesj = 12'hFFF;
assign jTarget[19] = ins[31];
assign jTarget[18:11] = ins[19:12];
assign jTarget[10] = ins[20];
assign jTarget[9:0] = ins[30:21];
yMux #(12) jum(jTarget[31:20], zerosj, onesj, jTarget[19]);

endmodule
//-------------------------------------------------------------------------------------------------------

//-----------------------------------------yEX-----------------------------------------------------------
module yEX(z, zero, rd1, rd2, imm, op, ALUSrc); 
output [31:0] z, b;
output zero;
input [31:0] rd1, rd2, imm; 
input [2:0] op;
input ALUSrc;

yMux #(32) my_mux(b, rd2, imm, ALUSrc);

yAlu #(32) myAlu2(z, zero, b, rd1, op);

endmodule
//-----------------------------------------yDM--------------------------------------------------------------
module yDM(memOut, exeOut, rd2, clk, MemRead, MemWrite); 
output [31:0] memOut;
input [31:0] exeOut, rd2, z; 
input clk, MemRead, MemWrite;

mem my_mem(memOut,z, rd2, clk, MemRead, MemWrite);

endmodule