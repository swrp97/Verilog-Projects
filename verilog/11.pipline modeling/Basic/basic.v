// Basic 3 stage pipeline where 
// stage 1 does x1=a+b ,x2 = c-d. with a delay of #4
// stage 2 does x3=x1+x2. with a delay of #4
// stage 3 does f=x3*d. with a delay of #6
// This is a bad way to model a pipline . Because we use only 1 clock at the inter stage registers in pipline which can lead to race condition. To solve this we must use either master slave flip flops or use two phase clock in alternate stages.
module pipe_ex (F,A,B,C,D,clk);
parameter N = 10;

input [N-1:0] A,B,C,D;
input clk;
output [N-1:0] F;
reg [N-1:0] L12_x1, L12_x2, L12_D, L23_x3, L23_D,L34_F;             // we need 6 latches to store the intermediate values. Value D needs to be forwarded to stage 3 because of dependency.

assign F = L34_F;               // assign the wire F with latch output  

always @(posedge clk)           // ** STAGE 1 ** . 
    begin
        L12_x1 <= #4 A+B;       // latch gets value of A+B after #4 delay
        L12_x2 <= #4 C-D;       // latch gets value of C-D after #4 delay
        L12_D <= D;             // latch gets value of D with no delay
    end

always @ (posedge clk)          // ** STAGE 2 **       
    begin
        L23_x3 <= #4 L12_x1 + L12_x2;           // take value from l12_x1 and l12_x2 to compute and store value in l23_x3 with #4 delay
        L23_D  <= L12_D;                        // latch gets value of D with no delay
    end

always @ (posedge clk)                          // ** STAGE 3** 
begin                                           
    L34_F <= #6 L23_x3 * L23_D;                 // take value from l23_x3 and l23_D to compute and store value in l34_F with #6 delay
end

endmodule
