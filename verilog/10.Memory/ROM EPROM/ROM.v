// ROM - Read only Memory , EPROM - Erasable read only memory using case statments
module rom (addr,data,rd_en,cs);
input [2:0] addr;
input rd_en; cs;
output reg [7:0] data;

always @(addr or rd_en or cs)
begin
if (rd_en && cs) 
 case(addr)
 0: data = 22;
 1: data = 15;
 2: data = 13;
 3: data = 17;
 4: data = 18;
 5: data = 19;
 7: data = 21;
 endcase
end
endmodule

// ROM loading from file 
//-----------------------------------------------------
// Function    : ROM using readmemb
//-----------------------------------------------------
module rom_using_file (
address , // Address input
data    , // Data output
read_en , // Read Enable 
cs        // Chip select
);
input [2:0] address;
output [7:0] data; 
input read_en; 
input cs; 
           
reg [7:0] mem [0:7] ;  
       
assign data = (cs && read_en) ? mem[address] : 8'bz;
 
initial 
    begin
    $readmemb("memory.list", mem); // memory_list is memory file
    end 
endmodule

