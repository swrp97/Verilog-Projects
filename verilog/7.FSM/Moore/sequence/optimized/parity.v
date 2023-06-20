// Here we will generate the output from the internal state. This design will not cause tool to generate a latch for output z 
// Here the register even_odd will contain the parity detected so far so we can just draw a wire from this register and this will be the output. 

module parity_gen(x,clk,z);
input x,clk;
output reg z;
reg even_odd; // The machine state 
parameter EVEN = 0, ODD = 1;

always @(posedge clk)                       // update machine state at +ve edge of clock
 case(even_odd)                             // case (machine state)
 EVEN: even_odd <= x ? ODD : EVEN;          // update machine state using non blocking assignments 
 ODD:  even_odd <= x ? EVEN : ODD;          // update machine state using non blocking assignments
 default: even_odd <= EVEN;
 endcase

always @(even_odd)                          // update output z whenever machine state changes
 case(even_odd)                             // case (machine state)
 EVEN: z = 0;                              //  update output using blocking assignments.
 ODD: z = 1;                               //  update output using blocking assignments.
 endcase
endmodule

