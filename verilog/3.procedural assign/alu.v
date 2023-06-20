// 4-function ALU

module ALU_4bit (f,a,b,op);
input [1:0] op; input [7:0] a,b;
output reg[7:0]f;

parameter ADD=2'b00,SUB=2'b01,MUL=2'b10,DIV=2'b11;

always @(*)
 case(op)
 ADD : f = a+b;
 SUB : f = a-b;
 MUL : f = a*b;
 DIV : f = a/b;
 endcase    
endmodule

// ALU with enable 

module alu_example (alu_out,A,B,operation,en);
input [2:0] operation; input[7:0] A,B;
input en;
output [7:0] alu_out; reg [7:0] alu_reg;

assign alu_out = (en == 1) ? alu_reg : 4'bzzzz;

always @(*)
 case(operation)
 3'b000 : alu_reg = A + B;
 3'b001 : alu_reg = A - B;
 3'b011 : alu_reg = ~A;
 default : alu_reg = 4'b0000;
 endcase
 endmodule
