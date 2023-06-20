// Ensure that the input syncs with the clock cycle .

module shifttest;
reg clk,clr,in; wire out;  

shiftreg_4bit sr (.clock(clk),.clear(clr),.A(in),.E(out));

initial 
begin
    clk = 1'b0; #2 clr = 0; #5 clr = 1; 
end

always #5 clk = ~clk;

initial 
begin 
    #2;   // Done to ensure that the input signal is given at #12 so that the input remains stable till the next clock cycle at #15, 
          //like wise the rest of the inputs are at #22 #32 .. etc
repeat(2)
begin #10 in=0; #10 in=0; #10 in=1; #10 in=1; end
end

initial begin
    $dumpfile ("shiftreg.vcd");
    $dumpvars (0,shifttest);
    #200 $finish;
end
endmodule