// A sequential logic example 

module dff_negedge (D,clk,Q,Qbar);
 input D,clk;
 output reg Q,Qbar;

 always @ (negedge clk)
  begin 
    Q = D;
    Qbar = ~D;
  end
endmodule
