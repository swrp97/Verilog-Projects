// structural description of 16 bit adder // 
module ALU (X,Y,Z,Sign,Zero,Carry,Parity,Overflow);
input [15:0]X,Y;
input[15:0]Z;
output Sign,Zero,Carry,Parity,Overflow;
wire [3:1] c;

assign Sign = Z[15];
assign Zero = ~|Z;
assign Parity = ~^Z;
assign Overflow = (X[15]&Y[15]& ~Z[15])|(~X[15]& ~Y[15] & Z[15]);

adder4 A0 (Z[3:0],c[1],X[3:0],Y[3:0],1'b0);
adder4 A1 (Z[7:4],c[2],X[7:4],Y[7:4],c[1]);
adder4 A2 (Z[11:8],c[3],X[11:8],Y[11:8],c[2]);
adder4 A3 (Z[15:12],Carry,X[15:12],Y[15:12],c[3]);
endmodule
// structural description of 4 bit carry look ahead adder 
module adder4 (S,cout,A,B,cin);
input [3:0]A,B; input cin;
output [3:0]S; output cout;
wire p0,p1,p2,p3,g0,g1,g2,g3;
wire c1,c2,c3;
// carry propogate and carry generate signals 
assign p0 = A[0]^B[0], p1 = A[1]^B[1], p2 = A[2]^B[2], p3 = A[3]^B[3];
assign g0 = A[0]&B[0], g1 = A[1]&B[1], g2 = A[2]&B[2], g3 = A[3]&B[3];
// generate carry signals 
assign c1 = g0|(p0&cin), c2 = g1|(p1&g0)|(p1&p0&cin), c3 = g2|(p2&g1)|(p2&p1&g0)|(p2&p1&p0&cin), cout = g3|(p3&g2)|(p3&p2&g1)|(p3&p2&p1&g0)|(p3&p2&p1&p0&cin);
// generate sums with xors 
assign S[0] = p0^cin, S[1] = p1^c1, S[2] = p2^c2, S[3] = p3^c3;
endmodule 
