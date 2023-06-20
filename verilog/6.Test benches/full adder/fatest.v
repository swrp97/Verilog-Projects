// Using for loop to generate all input combinations 

module testbench;
reg a,b,c; wire s,cout;
integer i; 
full_adder FA(sum,cout,a,b,c);

initial 
begin
    $dumpfile("fa.vcd");
    $dumpvars (0,testbench);
    for(i=0;i<8;i=i+1)
    begin
        {a,b,c} = i;  // the simulator converts integer to 3 bit binary and assigns it to the concatenated inputs 
    #5; $display ("T=%2d,a=%b,b=%b,c=%b,sum=%b,cout=%b",$time,a,b,c,sum,cout); 
    end
#5 $finish;
end
endmodule