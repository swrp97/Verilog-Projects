// 4 stage pipeline with inputs - 3 register addresses (rs1,rs2,rd), ALU function (func), memory address (addr)
// Stage 1: read two 16 bit numbers from registers specified by rs1 and rs2 and store them in A and B
// Stage 2: Perform an ALU op on A and B specified by func and store in Z.
// Stage 3: write value of Z in reg specified by rd
// Stage 4: also write value of z in mem location 'addr'

module pipeline_ex2(Zout,rs1,rs2,rd,func,addr,clk1,clk2);
input [3:0] rs1,rs2,rd,func; // 4 bit select for 16 16bit registers and 4 bit function for ALU 
input [7:0] addr;            // 8 bit address for 256 memory locations 
input clk1,clk2;             // two phase clock. Used on consecutive stages so as to avoid race condition and ensure stable output at each stage. 
output [15:0] Zout;         //  Output from stage 3 latch L34_Z is assigned to Zout. 

reg [15:0] L12_A, L12_B, L23_Z, L34_Z;  // 16 bit registers to store the intermediate values . Z is forwaded so it can be used in stage 4
reg [3:0] L12_rd, L12_func, L23_rd;     // 4 bit select for register destination which is forwarded till stage 3, ALU function. 
reg [7:0] L12_addr, L23_addr, L34_addr; // 8 bit memory address is forwarded till stage 4.

reg [15:0] regbank [0:15]; // 16 16bit register bank
reg [15:0] mem [0:255];    // 256 16 bit memory locations.

assign Zout = L34_Z;       // Output wire is assigned the output for the 3rd stage latch. 

always @ (posedge clk1)     // ** STAGE 1** 
    begin
        L12_A <= #2 regbank[rs1];          // read A from register bank
        L12_B <= #2 regbank[rs2];          // read B from register bank
       L12_rd <=    rd;                    // forward rd (register write destination)
     L12_addr <=    addr;                  // forward addr (memory write destination)
    end

always @(negedge clk2)      // ** STAGE 2**
    begin
     case (func)
        0: L23_Z <= #2 L12_A + L12_B;   // add
        1: L23_Z <= #2 L12_A - L12_B;   // sub
        2: L23_Z <= #2 L12_A * L12_B;   // mul  
        3: L23_Z <= #2 L12_A;           // select a
        4: L23_Z <= #2 L12_B;           // select b
        5: L23_Z <= #2 L12_A & L12_B;   // and
        6: L23_Z <= #2 L12_A | L12_B;   // or
        7: L23_Z <= #2 L12_A ^ L12_B;   // xor
        8: L23_Z <= #2 ~ L12_A;         // not a
        9: L23_Z <= #2 ~ L12_B;         // not b
       10: L23_Z <= #2 L12_A >> 1;      // right shift
       11: L23_Z <= #2 L12_A << 1;      // left shift
       default: L23_Z <= #2 16'hx;      
     endcase
        L23_rd <= #2 L12_rd;            // forward to stage 3
        L23_addr <= #2 L12_addr;        // forward to stage 3
    end

always @ (posedge clk1)        // ** STAGE 3**
begin
    regbank[L23_rd] <= #2 L23_Z;        // write to register bank from forwaded value 
    L34_addr <= #2 L23_addr;            // forward memory address
    L34_Z <= L23_Z;                     // forward alu output to be written to memory and to be written to output wire Zout
end

always @ (negedge clk2)     // ** STAGE 4 ** 
begin
    mem[L34_addr] <= #2 L34_Z;    // write alu output to location pointed to by the memory address that is forwaded 
end

endmodule
