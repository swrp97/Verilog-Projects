// DATAPATH 
module MUL_datapath (eqz,LdA,LdB,LdP,clrp,decB,data_in,clk);
input LdA,LdB,LdP,clrp,clk,decB;
input [15:0] data_in;
output eqz;
wire [15:0] X,Y,Z,Bout,Bus;

assign Bus = data_in;

PIPO1 A (X,Bus,LdA,clk);
PIPO2 P (Y,Z,LdP,clrp,clk);
CNTR  B (Bout,Bus,LdB,decB,clk);
ADD   AD (Z,X,Y);
EQZ COMP(eqz,Bout);
endmodule

module PIPO1 (dout,din,ld,clk);  // parallel in parallel out register without clear
input [15:0] din;
input ld,clk;
output reg[15:0] dout;

always @ (posedge clk)
    if(ld) dout <= din;
endmodule

module PIPO2 (dout,din,ld,clr,clk);      // parallel in parallel out register with clear
input [15:0] din;
input ld,clr,clk;
output reg [15:0] dout;

always @(posedge clk)
if (clr) dout <= 16'b0;
else if(ld) dout <= din;
endmodule

module CNTR (dout,din,ld,dec,clk);      // down counter 
input [15:0] din;
input ld,dec,clk; 
output reg [15:0] dout;

always @ (posedge clk)
 if (ld) dout <= din;
 else if (dec) dout <= dout-1;
endmodule

module ADD (out,in1,in2);
input [15:0] in1,in2; output reg [15:0] out;        

always@(*)
    out = in1 + in2;
endmodule

module EQZ (eqz,data);
input [15:0] data;
output eqz;

assign eqz = (data == 0);
endmodule


// Control Path
module controller (LdA,LdB,LdP,clrp,decB,done,clk,eqz,start);
input clk,eqz,start;
output reg LdA,LdB,LdP,clrp,decB,done;

reg [2:0] state;
parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;

always @ (posedge clk)          // Assign state with +ve edge clock with non blocking assignments
begin 
    case (state)
    S0: if(start) state <= S1;
    S1: state <= S2;
    S2: state <= S3;
    S3: #2 if(eqz) state <= S4;
    S4: state <= S4;
    default: state <= S0;
    endcase
end

always @ (state)                // Whenever the state changes generate the control signals using blocking assignments based on current state.
    begin
        case(state)
        S0: begin #1 LdA = 0; LdB = 0; LdP = 0; clrp = 0; decB = 0; end    // set all signals to 0
        S1: begin #1 LdA = 1; end                                          // load A
        S2: begin #1 LdA = 0; LdB = 1; clrp = 1; end                       // make ldA to 0.make ldb and clrp 1
        S3: begin #1 LdB = 0; clrp = 0; LdP = 1; decB = 1; end             // make ldB and clrp to 0.make ldp and decb 1
        S4: begin #1 done = 1; LdP = 0; decB = 0; end                      // make ldp and decb to 0. make done to 1
   default: begin #1 LdA = 0; LdB = 0; LdP = 0; clrp = 0; decB = 0; end
        endcase
    end
endmodule


/* Alternate way is t0 assign next state in first always block and then calculate state in the 2nd always block 

module controller (LdA,LdB,LdP,clrp,decB,done,clk,eqz,start);
input clk,eqz,start;
output reg LdA,LdB,LdP,clrp,decB,done;

reg [2:0] state, next_state;
parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;

always @ (posedge clk)          // Assign state with +ve edge clock with non blocking assignments
begin 
    case (state)
    S0: if(start) state <= S1;
    S1: state <= S2;
    S2: state <= S3;
    S3: #2 if(eqz) state <= S4;
    S4: state <= S4;
    default: state <= S0;
    endcase
end

always @ (state)                // Whenever the state changes generate the control signals using blocking assignments based on current state.
    begin
        case(state)
        S0: begin next_state = S1; #1 LdA = 0; LdB = 0; LdP = 0; clrp = 0; decB = 0;  end    // set all signals to 0
        S1: begin if(start) next_state = S2;#1 LdA = 1; end                                          // load A
        S2: begin #1 LdA = 0; LdB = 1; clrp = 1; end                       // make ldA to 0.make ldb and clrp 1
        S3: begin #1 LdB = 0; clrp = 0; LdP = 1; decB = 1; end             // make ldB and clrp to 0.make ldp and decb 1
        S4: begin #1 done = 1; LdP = 0; decB = 0; end                      // make ldp and decb to 0. make done to 1
   default: begin #1 LdA = 0; LdB = 0; LdP = 0; clrp = 0; decB = 0; end
        endcase
    end
endmodule

*/
