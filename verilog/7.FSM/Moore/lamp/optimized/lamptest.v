module testlamp;
reg clk; wire [0:3] light;

cyclic_lamp LAMP (clk,light);

always # 5 clk = ~clk;

initial begin
    clk=1'b0;
    #100 $finish;
end

initial begin
    $dumpfile ("lamp.vcd"); $dumpvars (0,testlamp); $monitor($time, " RGYB: %b", light);
end
endmodule