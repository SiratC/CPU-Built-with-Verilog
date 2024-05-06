module LabM2;
reg [31:0] d, e, expect;
reg clk, enable;
wire [31: 0] z;

register #(32) mine(z, d, clk, enable);

initial
begin  
    repeat(20)
        begin
            #2 d = $random % 100; // wanna make D smaller
            #1;
        end
        $finish;
end
//----------------------------------BLOCK
always
begin
            enable = 1;
            if(clk === 1) 
            e = z === d;
            #1;
            clk = 0; //set the clock equal to 0
            #5 clk = ~clk; // the not makes sure that every 5 units of time the clk goes betweeen 0 and 1
            #1;
end

initial
begin
            #1;
            $monitor("%5d: clk=%b d=%d z=%d expect=%d", $time, clk, d, z, e);
end

endmodule