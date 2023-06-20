// T flip flop 
primitive TFF(q,clk,clr);
input clk,clr;
output reg q;

table 
    // clk clr  :  q  : q_new
        ?   1   :  ?  :  0;           // FF is cleared
        ?  (10) :  ?  :  -;           // ignore -ve edge of "clr"
      (10)  0   :  0  :  1;           // FF toggles at -ve edge of clk (0 to 1)  
      (10)  0   :  1  :  0;           // FF toggles at -ve edge of clk (1 to 0)
      (0?)  0   :  ?  :  -;           // ignore +ve edge of "clk"
endtable
endprimitive



// Constructing a 6- bit ripple counter using 6 - T flip flops 

module ripple_counter (count,clk,clr);
 input clk,clr;
 output [5:0] count;

 TFF F0 (count[0],clk,clr);
 TFF F1 (count[1],count[0],clr);
 TFF F2 (count[2],count[1],clr);
 TFF F3 (count[3],count[2],clr);
 TFF F4 (count[4],count[3],clr);
 TFF F5 (count[5],count[4],clr);   
endmodule