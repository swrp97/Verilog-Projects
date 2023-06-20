module boothtest; 
reg [15:0] data_in;
reg clk, start; 
wire done;


BOOTH DP(ldA,ldQ,ldM,clrA,clrQ,clrff,sftA,sftQ,addsub,decr,ldcnt,data_in,clk,qm1,q0,eqz);
boothcontroller CP  (ldA,clrA,sftA,ldQ,clrQ,sftQ,ldM,clrff,addsub,start,decr,ldcnt,done,clk,q0,qm1,eqz);

initial 
 begin
    clk = 1'b0;
#3  start = 1'b1;
#500 $finish;
 end

always #5 clk = ~clk;

initial 
 begin
    #12 data_in = -32768 ;
    #10 data_in = 32767;
 end

initial 
 begin 
    $monitor ($time, " A=%d  Q=%d  done=%b",DP.A,DP.Q,done);
    $dumpfile ("booth.vcd"); $dumpvars (0,boothtest);
 end
endmodule