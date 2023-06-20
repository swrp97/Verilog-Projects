// Parameterized design N-bit counter

module counter(clear,clock,count);
parameter N = 7;
input clear,clock;
output reg[0:N] count;

always @(posedge clock, posedge clear)
 if(clear)
 count<=0;
 else 
 count<=count+1;
endmodule
