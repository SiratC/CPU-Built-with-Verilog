module LabL2;
reg[1:0] a,b;
reg c;
wire [1:0]z;
integer i, j, p;

yMux2 m2(z,a,b,c); //Now with 2 elements - array indexed 0 and 1; 
// a = 0, 1 in the index 0 and also another 0, 1 in index 1; 4 possibilities
// same for b = 4 possibilities
// z = 4 possibilies 
// c = 2 possibilities 0 or 1 controlling the whole array 

initial
begin
	for (i = 0; i < 4; i = i + 1)
		begin
		for (j = 0; j < 4; j = j + 1)
			begin
			for (p = 0; p < 2; p = p + 1)
			begin
				a = i; b = j; c = p;
	 			#1 $display("a=%d b=%d c=%d z=%d", a, b, c, z);
	 		end
		end
	end
$finish;
end

endmodule