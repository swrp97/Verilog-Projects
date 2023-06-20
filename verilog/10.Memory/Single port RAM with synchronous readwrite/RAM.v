// Single Port RAM with synchronous read/write (with clock)
module ram_1 (addr,data,clk,rd,wr,cs);
input [9:0] addr; 
input clk,rd,wr,cs;
reg [7:0] mem[1023:0];
inout [7:0] data;               // inout is by default type wire, hence a value cannot be assigned to it in the LHS of a always block (procedural statment).
reg [7:0] d_out;                // so we create a temporary register d_out to store the read value in the always block and assign it to data using assign statemnt. 

assign data = (cs && rd) ? d_out : 8'bz;        // if chip select and read is active data = d_out , else data = tristate

always @(posedge clk)
if (cs && wr && !rd) mem[addr] = data;         // if chip select and write is acitve and read is 0 then data will be written to memory address. Here data appears in the RHS which is allowed 

always @ (posedge clk)
if (cs && rd && !wr) d_out = mem [addr];       // if chip select and read is active and write is 0 then data will be read from memory to the output. Here we assign the value to a register. 
endmodule

// Single port RAM with asynchronous read/write (without clock)

module ram_2(addr,data,rd,wr,cs);
input [9:0] addr;
input rd,wr,cs; 
inout [7:0] data;
reg [7:0] mem [1023:0];
reg [7:0] d_out;

assign data = (cs && rd) ? d_out : 8'bz;

always @ (addr or data or rd or wr or cs)
 if (cs && wr && !rd) mem[addr] = data;

always @ (addr or data or rd or cs)
 if (cs && rd && !wr) d_out = mem[addr];

endmodule
