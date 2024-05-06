module LabL3;
parameter SIZE = 32;
reg[SIZE-1:0] a,b; 
reg c;
wire [SIZE-1:0] z;

// Same thing but with 32 bit size 
yMux #(32) m2(z,a,b,c);



// Using random because 
// can't use exhaustive testing as there are a large amount of space
// Random system returns a randomly chosen 32 bit integer. 
initial
begin
	repeat(500)
	begin
		a = $random; 
		b = $random;
		c = $random % 2; // c is a single bit therefore % 2 for values 0 or 1
		#1;
		if(c === 1 && z === b) // but with large bits
		$display("PASS: a=%d b=%d c=%d z=%d", a, b, c, z);
		else if(c === 0 && z === a) 
		$display("PASS: a=%d b=%d c=%d z=%d", a, b, c, z);
		else
		$display("FAIL: a=%d b=%d c=%d z=%d", a, b, c, z);
end

$finish;

end
endmodule