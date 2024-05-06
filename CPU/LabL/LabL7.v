module LabL; // Signed bit accepted
reg signed [31:0] a, b, expect; // 32 bit
reg cin, ok; // single bit
wire [31:0]z; // 32 bit
wire cout;
yAdder adder(z, cout, a, b, cin);

initial
repeat(50) // since a lot of bits input we use random testing
begin
	
	a = $random;
	b = $random;
	cin = 0; // cin fixed to 0

	expect = a + b + cin;
	ok = 0;
	#1;
	if(expect === z)
		ok = 1;
	if(ok === 1)
		$display("PASS: a=%d b=%d cin=%d cout=%d z=%d",a, b, cin, cout, z);
	else 
		$display("FAIL: a=%d b=%d cin=%d cout=%d z=%d", a, b, cin, cout, z);
end
endmodule