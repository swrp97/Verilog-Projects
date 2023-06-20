// example 1- how to create and initialize 8bit 1024 memory locations
module memory_model(.....)
reg [7:0] mem [0:1023]
initial 
begin 
    mem[0] = 8'b00001111;
    mem[4] = 8'b00110011;
end
endmodule

// Example 2 - Alternate way is to read memory data pattern from disk file - used in simulation and test bench
// Two functions can be used - $readmemb(filename,memname,startaddr,stopaddr) (Data is read in binary format) if startaddr and stopaddr are omitted the entire memory is read
// $readmemh(filename,memname,startaddr,stopaddr) (Data is read in hexadecimal format) if startaddr and stopaddr are omitted the entire memory is read

module memory_model(....);
reg [7:0] mem[0:1023];
initial 
begin
    $readmemh("mem.dat",mem);           // hexadecimal format, entire values are copied
end
endmodule

module memory_model(....);
reg [7:0] mem [0:1023];
initial
begin
    $readmemb("mem.dat",mem,200,50);    // decimal format, values are copied in the reverse order 200,199,198.... etc
end
endmodule 