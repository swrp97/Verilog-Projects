// Positive edge sensitive SR flip flop 

primitive SRFF (q,s,r,clk,clr);
input s ,r,clk,clr;
output reg q;

table 
    // s  r  clk  clr  :  q  :  q_new 
       ?  ?   ?    1   :  ?  :   0 ;          // clear
       ?  ?   ?  (10)  :  ?  :   - ;          // no change clr falling edge 
       ?  ? (10)   0   :  ?  :   - ;          // no change clock falling edge 
       0  0 (01)   0   :  ?  :   - ;          // no change
       0  1 (01)   0   :  ?  :   0 ;          // reset condition 
       1  0 (01)   0   :  ?  :   1 ;          // set condition 
       1  1 (01)   0   :  ?  :   x ;          // invalid condition 
endtable
endprimitive 