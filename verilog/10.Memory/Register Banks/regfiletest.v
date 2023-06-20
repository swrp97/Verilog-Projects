module regfile_test;

reg[4:0] sr1,sr2,dr;
reg[31:0] wrData;
reg write,reset,clk;
wire [31:0] rdData1,rdData2;
integer k,j;

regbank REG(rdData1,rdData2,wrData,sr1,sr2,dr,write,reset,clk);

initial clk = 0;

always #5 clk = ~clk;

initial 
begin
    $dumpfile("regfile.vcd"); $dumpvars(0,regfile_test);
    #1 reset = 1; write = 0 ;                                   // when reset goes high all registers are set to 0 
    #5 reset = 0 ;                                              // reset goes low at #6
end

initial
begin
    #7 
    for (j=0;j<32;j=j+1)                //  used to write data into all the registers 
    begin
        dr=j; wrData = 10*j; write =1;
    #10 write = 0;
    end
    #20 
    for (k=0;k<32;k=k+2)        // when k is 0 sr1=0, sr2=1. when k is 2 sr1=2, sr2=3.... selects all the registers, used to print all the values
    begin
        sr1=k; sr2=k+1;
        #5;
        $display("reg[%2d]= %d, reg[%2d]= %d",sr1,rdData1,sr2,rdData2);     
    end
    #2000 $finish;
end
endmodule