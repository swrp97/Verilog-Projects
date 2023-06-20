/* structural gate level description of a full adder 

module full_adder (a,b,c,sum,cout);
input a,b,c;
output sum,cout;

wire t1,t2,t3;

xor G1(t1,a,b), G2(sum,t1,c);
and G3(t2,a,b), G4(t3,t1,c);
or G5(cout,t2,t3);

endmodule

*/


// N bit ripple carry adder using generate statement 

module RCA(carry_out,sum,a,b,carry_in);
parameter N = 16;
input[N-1:0]a,b; input carry_in;
output[N-1:0]sum; output carry_out;
wire [N:0] carry; // carry[N] is carry_out

assign carry[0] = carry_in;
assign carry_out = carry[N];

genvar i;
generate for(i=0;i<N;i=i+1)
 begin:fa_loop
  wire t1,t2,t3;
  xor G1(t1,a[i],b[i]), G2 (sum[i],t1,carry[i]);
  and G3(t2,a[i],b[i]), G4 (t3,t1,carry[i]);
  or G5(carry[i+1],t2,t3);
 end
endgenerate
endmodule