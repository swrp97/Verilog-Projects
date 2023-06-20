// Moore machine - output depends only on the present state of the machine. 

module cyclic_lamp(clock,light);
input clock;
output reg [0:3] light;          
parameter S0=0, S1=1, S2=2,S3=3;         // easier to refer in case statement
parameter RED=4'b1000, GREEN=4'b0100, YELLOW=4'b0010, BLUE=4'b0001;
reg [0:1] state; // The machine state. if bits are 00 its binary is 0 which is parameter S0, 01 binary 1 which is S1...

always@(posedge clock)
case (state)
    S0: begin
        light <= RED; state <= S1;
    end 
    S1: begin
        light <= GREEN; state <= S2;
    end
    S2: begin
        light <= YELLOW; state <= S3;
    end
    S3: begin
        light <= BLUE; state <= S0;
    end
    default: begin
        light <= RED; state <= S0;
    end
endcase
endmodule

/*  Above design will create 6 Flip flops - 2 for state and 4 for light. The output lines are also being stored in flipflops since we have used nonblocking assignments triggered by clock edge.
Actually we do not need seperate flip flops for the output since the outputs can be directly generated from the state. 
We can do this by making all assignments to light in a seperate 'always' block and using blocking assignment triggered by state change and not by clock. Not by clock because synthesizer will assume we are trying to do something with registers in sync with clock.
This design is in the lamp2 folder

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

The synthesis tool will generate only 2 flipflops for the first clock triggered always block. 
The second always block will be generating a combinational circuit that takes state as input and light as output

state(s1s0)  light(R G Y B)
S0:00              1 0 0 0 
S1:01              0 1 0 0
S2:10              0 0 1 0
S3:11              0 0 0 1

Logic expression after minimization - R-'s1's0, G-s0, Y- s1, b- s1s0
*/ 
