// 4-1 mux 
primitive upd_mux41(f,s0,s1,i0,i1,i2,i3);
input s0,s1,i0,i1,i2,i3;
output f;
table 
    // s0 s1  i0 i1 i2 i3 : f 
       0  0    0  ?  ?  ? : 0
       0  0    1  ?  ?  ? : 1
       0  1    ?  0  ?  ? : 0
       0  1    ?  1  ?  ? : 1
       1  0    ?  ?  0  ? : 0
       1  0    ?  ?  1  ? : 1
       1  1    ?  ?  ?  0 : 0
       1  1    ?  ?  ?  1 : 1
endtable
endprimitive