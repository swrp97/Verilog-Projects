// Transarent latch with enable 
module latch (q,qbar,din,enable);
input din,enable;
output reg q; output qbar;
assign qbar = ~q;

always @(din or enable)
begin 
    if(enable) q=din;
end 
endmodule
