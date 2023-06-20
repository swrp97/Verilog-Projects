module compare (A,B,lt,gt,eq);
parameter word_size = 16 ;
input [word_size-1:0] A,B;
output reg lt,gt,eq;
always @(*)
 begin
    gt=0; lt=0; eq=0;
      if (A>B) gt=1;
 else if (A<B) lt=1;
 else  eq=1;
 end
endmodule

// 2bit comparator 

module compare (A1,A0,B1,B0,lt,gt,eq);
input A1,A0,B0,B1;
output reg lt,gt,eq;
always @(A1,A0,B1,B0)
begin 
    lt= ({A1,A0} < {B1,B0});
    gt= ({A1,A0} > {B1,B0});
    eq= ({A1,A0} == {B1,B0});
end
endmodule
