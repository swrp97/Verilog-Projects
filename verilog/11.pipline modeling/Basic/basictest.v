module pipe1_test; 

parameter N = 10;
wire [N-1:0] F;
reg [N-1:0] A,B,C,D;
reg clk;

pipe_ex DUT (F,A,B,C,D,clk);

initial clk = 0;

always #10 clk = ~clk;              // clock period 20 so 1st input given at #5 then 2nd inputs given at #25. 1st +ve clk comes at #10, 2nd +ve clk comes at #30

initial 
begin
    #5 A=10; B=12; C=6; D=3; // output F = 75
   #20 A=10; B=10; C=5; D=3; // output F = 66
   #20 A=20; B=11; C=1; D=4; // output F = 112
   #20 A=15; B=10; C=8; D=2; // output F = 62 
   #20 A=8; B=15; C=5; D=0; // output F = 0
   #20 A=10; B=10; C=5; D=3; // output F = 66
   #20 A=10; B=10; C=30; D=1; // output F = 49
   #20 A=30; B=1; C=2; D=4; // output F = 166
end

initial
begin
    $dumpfile("pipe1.vcd");
    $dumpvars(0,pipe1_test);
    $monitor ("Time: %2d, F: %2d",$time,F);
    #300 $finish;
end
endmodule

