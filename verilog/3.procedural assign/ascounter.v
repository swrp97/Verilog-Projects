// 4-bit counter with asynchronous reset, (for synchronous reset drop posedge rst so everything syncs with clock)

module counter (clk,rst,count);
 input clk,rst;
 output reg [3:0] count;

 always @ (posedge clk or posedge rst)
 begin
    if (rst)
    count <= 0;
    else
    count <= count+1;
 end    
endmodule