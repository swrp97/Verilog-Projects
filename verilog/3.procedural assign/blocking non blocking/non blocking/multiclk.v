// More than one clock in a module 
    module multi_clk(clk1,clk2,a,b,c,f1,f2);
    input clk1,clk2,a,b,c;
    output reg f1,f2;
    always @(posedge clk1)
    f1 <= a & b;
    always @(negedge clk2)
    f2 <= b ^ c;
    endmodule

// Multiple edges of same clk

module mult_edge_clk (a,b,f,clk);
input a,b,clk;
output reg f; reg t;
always @(posedge clk)
 f <= t & b;
always @(negedge clk)
 t <= a | b;
endmodule
