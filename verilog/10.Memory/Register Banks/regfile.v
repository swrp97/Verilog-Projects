// 32 x 32 register bank with reset facility. Reset sets all register banks values to 0 

module regbank(rdData1,rdData2,wrData,sr1,sr2,dr,write,reset,clk); 
input clk,write,reset;
input [4:0] sr1,sr2,dr;         // 5 bits for 32 registers (source and destionation)
input [31:0] wrData;            // 32 bit write data input 
output [31:0] rdData1,rdData2;  // 32 bit read data output 
integer k;                      // used for loop 

reg [31:0] regfile [0:31];      // 32 32bit registers

assign rdData1 = regfile[sr1];  
assign rdData2 = regfile[sr2];

always @(posedge clk)
begin
    if(reset)
    begin
        for(k=0;k<32;k=k+1)
        begin
            regfile[k] <=0;
        end
    end 
    else
    begin
        if(write)
         regfile[dr] <= wrData;
    end
end
endmodule

