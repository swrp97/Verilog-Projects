module ALU(X,Y,Z,Sign,Zero,Carry,Parity,Overflow);
input [15:0] X,Y;
output[15:0]Z;
output Sign,Zero,Carry,Parity,Overflow;

assign {Carry,Z} = X+Y; // concatenation operation 
assign Sign = Z[15]; // MSB of result is sign in 2's complement number system
assign Zero = ~|Z; // NOR reduction operator gives zero flag as 1 if result in z is all 0's
assign Parity = ~^Z; // if even parity then flag is 1, if odd then flag is 0, using XNOR reduction opertion
assign Overflow= (X[15]& Y[15]& ~Z[15])|(~X[15]& ~Y[15]& Z[15]); // if condition X.Y.~Z + ~X.~Y.Z is true then overflow has taken place
endmodule 