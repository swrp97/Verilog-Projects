module test_parity;
reg clk,x; wire z;

parity_gen PAR(x,clk,z);

initial 
begin
    $dumpfile ("parity.vcd"); $dumpvars (0,test_parity);
    $monitor ($time," x = %b, z = %b",x,z);
    clk = 1'b0;
end

always #5 clk = ~clk;

initial 
begin
    #2 x = 0; #10 x = 1; #10 x = 1; #10 x = 1; #10 x = 1;
    #10 x = 0; #10 x = 1; #10 x = 1; #10 x = 1; #10 x = 1;
    #10 x = 1; #10 x = 1; #10 x = 0; #10 x = 1; #10 x = 0;
    #50 $finish;
end
endmodule