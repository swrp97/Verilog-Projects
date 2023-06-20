module pipe_test;
wire [15:0] Z;
reg [3:0] rs1, rs2 , rd , func;
reg [7:0] addr;
reg clk1, clk2;
integer k;

pipeline_ex2 DUT (Z,rs1,rs2,rd,func,addr,clk1,clk2);

initial
 begin
 clk1 = 0; clk2 = 0; 
 repeat (20)        // Generate 2 phase clock
  begin            
   #5 clk1 = 1; #5 clk1 = 0; #5 clk2 = 1; #5 clk2 = 0;   
  end
 end

initial
for (k=0;k<16;k=k+1)
    DUT.regbank[k] = k;         // initialize registers 

initial begin
    #5 rs1 = 3; rs2 = 5; rd = 10; func = 0; addr = 125;     // ADD
   #20 rs1 = 3; rs2 = 8; rd = 12; func = 2; addr = 126;     // MUL      The 2nd input is given after delay #20 because stage 1 will only trigger at the next +ve edge of clock 1 which is after #20. i.e clock period is 20
   #20 rs1 = 10; rs2 = 5; rd = 14; func = 1; addr = 128;     // SUB     Register 10 has been given a value at #5 that value will be used for computation
   #20 rs1 = 7; rs2 = 3; rd = 13; func = 11; addr = 127;     // SLA
   #20 rs1 = 10; rs2 = 5; rd = 15; func = 1; addr = 129;     // SUB
   #20 rs1 = 12; rs2 = 13; rd = 16; func = 0; addr = 130;     // ADD

   #60 for (k=125;k<131;k=k+1)
        $display ("Mem[%3d] = %3d",k,DUT.mem[k]);
end

initial 
    begin 
        $dumpfile ("pipe2.vcd");
        $dumpvars (0, pipe_test);
        $monitor ("Time: %3d, F = %3d", $time, Z);
        #300 $finish;
    end
endmodule