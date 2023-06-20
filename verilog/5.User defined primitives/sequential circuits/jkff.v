// Negative edge sensitive JK flip flop 

primitive JKFF (q,J,K,clk,clr);
input J,K,clk,clr;
output reg q;

table 
    // j  k  clk  clr  :  q  :  q_new 
       ?  ?   ?    1   :  ?  :   0 ;          // clear
       ?  ?   ?  (10)  :  ?  :   - ;          // no change clr falling edge 
       ?  ? (01)   0   :  ?  :   - ;          // no change clock rising edge 
       0  0 (10)   0   :  ?  :   - ;          // no change
       0  1 (10)   0   :  ?  :   0 ;          // reset condition 
       1  0 (10)   0   :  ?  :   1 ;          // set condition 
       1  1 (10)   0   :  0  :   1 ;          // toggle condition
       1  1 (10)   0   :  1  :   0 ;          // toggle condition 
endtable
endprimitive           