module xor_bitwise(f,a,b);
parameter N = 16;
input [N-1:0] a,b;
output [N-1:0] f;
genvar p;

generate 
    for (p=0;p<N;p=p+1)
begin:xorlp
    xor XG (f[p],a[p],b[p]);   
end
endgenerate
endmodule
