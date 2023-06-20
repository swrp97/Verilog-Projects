`timescale 1ns/100ps
module comparator(z,x,y);
input [1:0]x,y ; output z;

assign z = (~x[1] & ~x[0] & ~y[1] & ~y[0]) |
           (~x[1] & x[0]  & ~y[1] & y[0] ) |
           ( x[1] & ~x[0] &  y[1] & ~y[0]) |
           ( x[1] &  x[0] &  y[1] &  y[0]);
endmodule
