`timescale 1ns/100ps
module testbench; 
reg[1:0] x,y; wire z;
comparator c1(.x(x),.y(y),.z(z));
initial 
 begin
    $dumpfile ("comp.vcd"); $dumpvars (0,testbench);
      x=2'b01; y=2'b00;
  #10 x=2'b10; y=2'b10;
  #10 x=2'b11; y=2'b10;
  #10 x=2'b10; y=2'b11;
 end
initial
 begin 
    $monitor ("t=%d x=%2b y=%2b z=%d", $time,x,y,z);
 end
endmodule