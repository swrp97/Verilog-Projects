// up-down counter (asynchoronus clear,ld,mode)

module counter (mode,clr,ld,d_in,clk,count);
input mode,clr,ld,clk;
input [0:7] d_in;
output reg [0:7] count;

always @ (posedge clk, posedge clr, posedge ld, posedge mode )
 if(ld) count<=d_in;
 else if(clr) count <=0;
 else if(mode) count<= count+1;
 else count <= count-1 ;
endmodule
