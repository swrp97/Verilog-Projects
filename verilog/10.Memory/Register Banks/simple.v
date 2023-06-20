// Simple 4 x 32 register bank 

// Method 1 - the output of read data 1 and read data 2 will be registers which will be assigned a value in an always block in LHS

module regbank_v1 (rdData1,rdData2,wrData,sr1,sr2,dr,write,clk);
input clk, write;
input [1:0] sr1, sr2, dr; // source and destination registers. Since there's 4 of them we need 2 bits
input [31:0] wrData;     // data to be written
output reg [31:0] rdData1,rdData2; // declared as type reg because it will be used in LHS always block 
reg [31:0] R0,R1,R2,R3;

always @(*)
begin
    case(sr1)
    0:  rdData1 = R0;
    1:  rdData1 = R1;
    2:  rdData1 = R2;
    3:  rdData1 = R3;
    default: rdData1 = 32'h0;
    endcase
end

always @(*)
begin
    case(sr2)
    0:  rdData2 = R0;
    1:  rdData2 = R1;
    2:  rdData2 = R2;
    3:  rdData2 = R3;
    default: rdData2 = 32'h0;
    endcase
end

always @ (posedge clk)          // write operation happens only in sync with the clock, so we have to use non blocking assignments. 
begin
    if(write)
    case (dr)
    0: R0 <= wrData;
    1: R1 <= wrData;
    2: R2 <= wrData;
    3: R3 <= wrData;
    endcase
end
endmodule

// Method 2 - we use assign statements for rdData1 and rdData2, kind of like  if elseif statements. Since we use assign statments they dont need to be defined as type reg
// read ports are implemented using assign statements. So we do not need them as type register

module regbank_v2(rdData1,rdData2,wrData,sr1,sr2,dr,write,clk);
input clk,write;
input [1:0] sr1,sr2,dr;
input [31:0] wrData;
output [31:0] rdData1,rdData2;              // read ports are implemented using assign statements. So we do not need them as type register
reg [31:0] R0,R1,R2,R3;                     

assign rdData1 = (sr1==0) ? R0 :            // if else type of assignment. first it checks if sr1 is 0 (if true then it assigns R0 to rdData1) if false it checks if sr1 is 1 ..... else default statement is 0. 
                 (sr1==1) ? R1 :
                 (sr1==2) ? R2 :
                 (sr1==3) ? R3 : 0 ; 

assign rdData2 = (sr2==0) ? R0 :            // if else type of assignment. first it checks if sr2 is 0 (if true then it assigns R0 to rdData2) if false it checks if sr2 is 1 ..... else default statement is 0.
                 (sr2==1) ? R1 :
                 (sr2==2) ? R2 :
                 (sr2==3) ? R3 : 0 ;

always @(posedge clk)
begin
    if(write)
    case(dr)
     0: R0 <= wrData;
     1: R1 <= wrData;
     2: R2 <= wrData;
     3: R3 <= wrData;
    endcase
end
endmodule