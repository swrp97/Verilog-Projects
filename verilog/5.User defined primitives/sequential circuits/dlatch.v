// Level sensitive d type latch
primitive Dlatch(q,d,clk,clr);
input d,clk,clr;
output reg q;             // reg type because its a sequential circuit 

initial 
 q = 0;                    // this is optional 

table 
    //  d clk clr : q : q_new
        ?  ?  1   : ? :  0   // latch is cleared
        0  1  0   : ? :  0   // latch is reset
        1  1  0   : ? :  1   // latch is set
        ?  0  0   : ? :  -   // retain previous state
endtable
endprimitive
 


