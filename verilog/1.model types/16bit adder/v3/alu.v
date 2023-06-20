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
// structural description of single 4 bit adder // 
module adder4 (S,cout,A,B,cin);
input [3:0]A,B; input cin;
output[3:0]S; output cout;
wire c1,c2,c3;

fulladder FA0 (S[0],c1,A[0],B[0],cin);
fulladder FA1 (S[1],c2,A[1],B[1],c1);
fulladder FA2 (S[2],c3,A[2],B[2],c2);
fulladder FA3 (S[3],cout,A[3],B[3],c3);
endmodule
// gate level description of single full adder // 
module fulladder(s,cout,a,b,c);
input a,b,c;
output s,cout;
wire s1,c1,c2;

xor G1(s1,a,b), G2 (s,s1,c), G3(cout,c2,c1);
and G4(c1,a,b), G5(c2,s1,c);
endmodule
