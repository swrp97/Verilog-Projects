module MUL_test; 
reg [15:0] data_in;
reg clk, start;
wire done; 

MUL_datapath DP (eqz,LdA,LdB,LdP,clrp,decB,data_in,clk);
controller CON (LdA,LdB,LdP,clrp,decB,done,clk,eqz,start);

initial 
begin
    clk = 1'b0;
    #3 start =1'b1;
    #500 $finish;
end

always #5 clk = ~clk;

initial
begin
    #17 data_in = 17;
    #10 data_in = 5;
end
initial 
begin
    $monitor ($time, " in = %b , start = %b, OUT = %d, Done = %b, State = %b",data_in,start,DP.Y,done, CON.state);
    $dumpfile ("mul.vcd"); $dumpvars (0,MUL_test);
end
endmodule