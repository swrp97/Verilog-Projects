// DATAPATH
module GCD_datapath (gt,lt,eq,ldA,ldB,sel1,sel2,sel_in,data_in,clk);
input ldA,ldB,sel1,sel2,sel_in,clk;
input [15:0] data_in;
output gt,lt,eq;
wire [15:0] Aout,Bout,X,Y,Bus,Subout;



PIPO A (Aout,Bus,ldA,clk);
PIPO B (Bout,Bus,ldB,clk);
MUX MUX_in1 (X,Aout,Bout,sel1);
MUX MUX_in2 (Y,Aout,Bout,sel2);
MUX MUX_load (Bus,Subout,data_in,sel_in);
CMP COMP (lt,gt,eq,Aout,Bout);
SUB SB(Subout,X,Y);
endmodule

module PIPO (data_out,data_in,load,clk);
input [15:0] data_in;
input load,clk;
output reg[15:0] data_out;

always @(posedge clk)
 if(load) data_out <= data_in;                  // sequential circuit so Use non blocking assignments since its a register that stores a value  
endmodule

module SUB (out,in1,in2);
input [15:0] in1,in2;
output reg [15:0] out;

always @(*)
 out = in1 - in2;                               // combinational circuit so blocking assignments 
endmodule

module CMP (lt,gt,eq,data1,data2);
input [15:0] data1,data2;
output lt,gt,eq;

assign lt = data1 < data2;
assign gt = data1 > data2;
assign eq = data1 == data2;
endmodule

module MUX (out,in0,in1,sel);
input [15:0] in0, in1;
input sel;
output [15:0] out;

assign out = sel ? in1 : in0; 
endmodule


// CONTROL PATH

module controller (ldA,ldB,sel1,sel2,sel_in,done,clk,lt,gt,eq,start);
input clk,lt,gt,eq,start;
output reg ldA,ldB,sel1,sel2,sel_in,done;

reg [2:0] state, next_state;
parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

always@(posedge clk)                // just assign state <= next_state for clk
begin
    state <= next_state;        
end

always @(state)
begin
    case(state)
    S0: begin  sel_in = 1; ldA = 1; ldB = 0; done = 0;  end            // load data_in on bus and onto A register
    S1: begin  sel_in = 1; ldA = 0; ldB = 1;  end                      // load data_in on bus and onto B register                 
    S2:        if  (eq) begin done = 1; next_state = S5; end                                     
               else if (lt) begin 
                            sel1 = 1; sel2 = 0; sel_in = 0; next_state = S3;           // mux1 gives B and mux2 gives A, and result stored in B
                        #1 ldA = 0; ldB = 1;
                            end
               else if (gt) begin 
                            sel1 = 0; sel2 = 1; sel_in = 0; next_state = S4;         // // mux1 gives A and mux2 gives B, and result stored in A
                        #1  ldA = 1; ldB = 0;
                            end
    S3:        if  (eq) begin done = 1;  next_state = S5; end                                     
               else if (lt) begin 
                            sel1 = 1; sel2 = 0; sel_in = 0; next_state = S3;          // mux1 gives B and mux2 gives A, and result stored in B
                        #1 ldA = 0; ldB = 1;
                            end
               else if (gt) begin 
                            sel1 = 0; sel2 = 1; sel_in = 0; next_state = S4;        // // mux1 gives A and mux2 gives B, and result stored in A
                        #1  ldA = 1; ldB = 0;
                            end
    S4:        if  (eq) begin done = 1;  next_state = S5; end          
               else if (lt) begin 
                            sel1 = 1; sel2 = 0; sel_in = 0; next_state = S3;          // mux1 gives B and mux2 gives A, and result stored in B
                        #1  ldA = 0; ldB = 1;
                            end
               else if (gt) begin 
                            sel1 = 0; sel2 = 1; sel_in = 0; next_state = S4;        // // mux1 gives A and mux2 gives B, and result stored in A
                        #1  ldA = 1; ldB = 0;
                            end
    S5:begin done=1; sel1=0; sel2=0; ldA=0;ldB=0;next_state = S5; end
    default: begin ldA= 0; ldB = 0; next_state = S0; end
    endcase
end                                
endmodule