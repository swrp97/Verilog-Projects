/*  Here only 2 latches will be generated for the state. 
The synthesis tool will generate only 2 flipflops for the first clock triggered always block. 
The second always block will be generating a combinational circuit that takes state as input and light as output

state(s1s0)  light(R G Y B)
S0:00              1 0 0 0 
S1:01              0 1 0 0
S2:10              0 0 1 0
S3:11              0 0 0 1

Logic expression after minimization - R-'s1's0, G-s0, Y- s1, B- s1s0

*/

module cyclic_lamp(clock,light);
input clock;
output reg [0:3] light;          
parameter S0=0, S1=1, S2=2,S3=3;         
parameter RED=4'b1000, GREEN=4'b0100, YELLOW=4'b0010, BLUE=4'b0001;
reg [0:1] state; 

always@(posedge clock)
case (state)
    S0:  state <= S1;
    S1:  state <= S2;
    S2:  state <= S3;
    S3:  state <= S0;
default: state <= S0; 
endcase

always@(state)
case (state)
 S0:light = RED;
 S1:light = GREEN;
 S2:light = YELLOW;
 S3:light = BLUE;
endcase
endmodule