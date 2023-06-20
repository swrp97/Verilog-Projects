// Sequence detector for "0110", Moore machine uses both present state and input to determine output logic. 
// It has two flip flops one for present state and one for next state. We use NS ff to update PS at every +ve clk edge.
// In Moore machine the output logic and next state logic both depend on the present state and present inputs.

module seq_detector (x,clk,reset,z);
input x,clk,reset; output reg z;
parameter S0=0, S1=1, S2=2, S3=3;
reg [0:1] PS,NS;

always@(posedge clk or posedge reset)   // Update ps with ns at the +ve edge of clk. If reset is 1 PS is in state 0. Assign present state in clk triggered always block w non blocking statements
 if(reset) PS <= S0;
 else      PS <= NS;

always @ (PS,x)                        // Anytime PS or input x changes update NS and output z. Compute Next state w blocking assignments.
case(PS)
    S0: begin
        NS = x ? S0 : S1;        // if input is 1 stay in state 0, if 1 go to state 1
        z  = 0;
    end
    S1: begin
        NS = x ? S2 : S1;       // if input is 0 stay in state 1, if 1 go to state 2
        z  = 0;
    end
    S2: begin
        NS = x ? S3 : S1;       // if input is 0 go to state 1, if 1 go to state 3
        z  = 0;
    end
    S3: begin
        NS = x ? S0 : S1;       // if input is 0 go to state 1 and give output z as 1 (hence output depends not only on present state but also given input), if 1 go to state 0 with output z as 0
        z  = x ? 0  : 1;
    end
    endcase
endmodule

