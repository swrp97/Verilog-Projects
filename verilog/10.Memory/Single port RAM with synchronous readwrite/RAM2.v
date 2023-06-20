// RAM without read enable where output is a wire that is being driven continuously using assign statement.
module ram_2 (data_out, data_in, addr, wr,cs);
parameter addr_size = 10, word_size = 8, memory_size = 1024;
input [addr_size-1:0] addr;
input [word_size-1:0] data_in;
input wr,cs;
output [word_size-1:0] data_out;
reg [word_size-1:0] mem[memory_size-1:0];

assign data_out = mem[addr];                        // the output is being continuously driven without a read enable

always @ (wr or cs)
 if (wr) mem[addr]= data_in;                        // the write operation happens only when wr is high. then data gets written into memory address  

endmodule

/* For bidirectional data bus , tristate buffers can be included explicitly 

tri [7:0] Bus;              Bus is defined as a tristate element. it can be activated with write or read but never at the same time.
wire [7:0] data_out,data_in;
assign Bus = read ? data_out:8'bz;
assign data_in = write ? Bus : 8'bz;

*/
