// 4-input AND function
    primitive udp_and4(f,a,b,c,d);
    input a,b,c,d;
    output f;
    table
        // a b c d : f
           0 ? ? ? : 0;
           ? 0 ? ? : 0;
           ? ? 0 ? : 0;
           ? ? ? 0 : 0;
           1 1 1 1 : 1;
    endtable
endprimitive

// 4-input OR function 
    primitive udp_or4(f,a,b,c,d);
    input a,b,c,d;
    output f;
    table
        // a b c d : f 
           0 0 0 0 : 0;
           1 ? ? ? : 1;
           ? 1 ? ? : 1;
           ? ? 1 ? : 1;
           ? ? ? 1 : 1;
    endtable
    endprimitive
    