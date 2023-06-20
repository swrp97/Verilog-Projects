module add_test;

reg[15:0] x,y; reg cin;
wire [15:0] out; wire cout;

RCA G (.sum(out),.carry_out(cout),.a(x),.b(y),.carry_in(cin));

initial begin
    $monitor ("x: %h, y: %h,out:%h, cout: %h", x, y, out, cout);
    $dumpfile("add.vcd"); $dumpvars (0,add_test);
     cin =16'h0000; x=16'h0000; y=16'h1111;
 #10 x=16'h0f0f; y=16'h3333;
 #20 x=16'hffff; y=16'hffff;
 #30 $finish;
end
endmodule