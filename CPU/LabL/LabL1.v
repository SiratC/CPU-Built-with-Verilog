module LabL1;
reg a,b,c;
wire z;
integer i, j, p;

yMux1 m1(z,a,b,c);

initial
begin
	for (i = 0; i < 2; i = i + 1) //each going to have either 0 or 1 for a , b , and c whereas z is the output; therefore 3 times 2 = 6 
		begin // Using exhaustive testing
		for (j = 0; j < 2; j = j + 1)
			begin
			for (p = 0; p < 2; p = p + 1)
			begin
				a = i; b = j; c = p;
				$display("a=%d b=%d c=%d z=%d", a, b, c, z);
	 		end
		end
	end
$finish;
end

endmodule