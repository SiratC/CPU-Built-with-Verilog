module labL; // for sign less than operator
reg signed [31:0] a, b; // 32 bit a and b registers
reg [31:0] expect; // 32 bit expect register
reg [2:0] op; // 2 bit opcode register
wire ex; // 1 bit wire ex
wire [31:0] z; // 32 bit z wire
reg ok, flag; // 1 bit ok and flag register


yAlu mine(z, ex, a, b, op); // calling on Alu module

initial
begin
    repeat(10) // random testing
    begin
        a = $random;
        b = $random;
        op = 6; // performs subtraction since 6 
        ok = 0;
        if(op === 0) 
        expect = a & b; // and operator
        else if(op === 1)
        expect = a | b; // or operator
        else if(op === 2)
        expect = a + b; // add operator
        else if(op === 6)
        expect = a + (~b) + 1; // subtract operator (2's complement)
        else if(op === 3'b111) // sign less than operator if a less than b then expect = 1 otherwise 0
        expect = (a < b) ? 1 : 0;
        else 
        $display("Error"); // Give error if anything other than the above op values
        #1;

        // Compare the circuit's output with "expect"
        // and set "ok" accordingly
        if(expect === z)
        ok = 1;
        if(ok === 1) 
        // Display ok and the various signals
        $display("PASS: a=%d b=%d expect=%d z=%d ok=%d op=%d", a, b, expect, z, ok, op);
        else
        $display("FAIL: a=%d b=%d expect=%d z=%d ok=%d op=%d", a, b, expect, z, ok, op);
        $finish;
    end
end

endmodule