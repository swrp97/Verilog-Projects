// Wrong way to model ring counter using blocking assignment. count[7] will get overwritten in first statement with 0 so rotation of bits will not happen
module ring_counter (clk,init,count);
input clk,init;
output reg[7:0] count;
always @(posedge clk)
begin 
    if(init) count = 8'b10000000;
    else begin 
        count = count << 1 ;
        count [0] = count [7];
    end
end
endmodule

// Correct way to model ring counter using blocking assignment.
module ring_counter (clk,init,count);
input clk,init;
output reg[7:0] count;
always @(posedge clk)
begin 
    if(init) count = 8'b10000000;
    else 
        count = {count[6:0],count[7]};   
end
endmodule

// Correct way to model ring counter using non blocking assignment. Since non blocking assignment is used the rotation will take place correctly
module ring_counter (clk,init,count);
input clk,init;
output reg[7:0] count;
always @(posedge clk)
begin 
    if(init) count = 8'b10000000;
    else begin 
        count <= count << 1 ;
        count [0] <= count [7];
    end
end
endmodule

