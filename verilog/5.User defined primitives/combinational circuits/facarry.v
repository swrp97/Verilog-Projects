//Full adder carry generation 
primitive udp_cy(cout,a,b,c);
input a,b,c;
output cout;
table
    // a b c : cout
       0 0 0 :  0;
       0 0 1 :  0;
       0 1 0 :  0;
       0 1 1 :  1;
       1 0 0 :  0;
       1 0 1 :  1;
       1 1 0 :  1;
       1 1 1 :  1;
endtable
endprimitive

// Full adder carry generation using dont cares("?")

primitive udp_cy(cout,a,b,c);
input a,b,c;
output cout;
table
    // a b c : cout
       ? 0 0 :  0;
       0 ? 0 :  0;
       0 0 ? :  0;
       ? 1 1 :  1;
       1 ? 1 :  1;
       1 1 ? :  1;
endtable
endprimitive

/* To instantiate udp in a module we use the same method as other modules 
module full_adder(sum,cout,a,b,c);
input a,b,c;
output sum,cout;

udp_sum SUM (sum,a,b,c);
udp_cy CARRY (cout,a,b,c);
endmodule
*/ 
