module parity_gen (x,clk,z);
input x,clk;
output reg z;
reg even_odd;       // The machine state. We will update this with nonblocking statements with the +ve edge of clock in always block and then use it to update the output register in a seperate always block with blocking statements.
parameter EVEN =0, ODD=1 ;

always @(posedge clk) 
    case(even_odd)
     EVEN: begin
        z <= x ? 1 : 0 ;
        even_odd <= x ? ODD : EVEN;
     end
     ODD: begin
        z <= x ? 0 : 1 ;
        even_odd <= x ? EVEN : ODD;
     end
     default: begin 
        z <= 0;
        even_odd <= EVEN;
     end
    endcase
endmodule
