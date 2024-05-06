module LabL8;

reg signed[31: 0] a, b, expect; // signed values both positive and negative accepted.
wire [31: 0] z;
wire cout;
reg ctrl, cin;

yArith arith(z, cout, a, b, ctrl);

initial
begin
repeat(50)
    begin
        a = $random;
        b = $random;
        ctrl = $random % 2;
        #1;

        if(ctrl === 1) 
        expect = a + (~b) + 1; // performs 2's complement with +1 (subtraction operator)
        else
        expect = a + b; // (addition operator)

        if(z === expect) 
        $display("PASS: a=%d b=%d ctrl=%d z=%d", a, b, ctrl, z);
        else
        $display("FAIL: a=%d b=%d ctrl=%d z=%d", a, b, ctrl, z);
    end
$finish;
end

endmodule