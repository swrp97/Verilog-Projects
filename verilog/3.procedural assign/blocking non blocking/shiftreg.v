// Correct way to model a 4 bit shift register using blocking assignments 
module shiftreg_4bit (clock,clear,A,E); 
input clock, clear, A;
output reg E;
reg B,C,D;

always @(posedge clock or negedge clear)
begin 
    if(!clear) begin B=0; C=0; D=0; E=0; end
    else begin
         E = D;
         D = C;
         C = B;
         B = A;
    end
end
endmodule

// Wrong way to model a 4 bit shift register using blocking assignments, this will model a single flip flop whose output E will be the value of A, 
// i.e A will overwrite all the register values and this will not function as a shift register. The four statements are equal to a single statement that assigns A to E.

module shiftreg_4bit (clock,clear,A,E); 
input clock, clear, A;
output reg E;
reg B,C,D;

always @(posedge clock or negedge clear)
begin 
    if(!clear) begin B=0; C=0; D=0; E=0; end
    else begin
         B = A;
         C = B;
         D = C;
         E = D;
    end
end
endmodule

// If we use non blocking assignments we can put the expressions in any order and still get the desired shift register circuit. All of the RHS is evaluated in parallel.
// Hence chances of mistakes are less. Recommended for modelling sequential circuits. Statements can appear in any order.


module shiftreg_4bit (clock,clear,A,E); 
input clock, clear, A;
output reg E;
reg B,C,D;

always @(posedge clock or negedge clear)
begin 
    if(!clear) begin B<=0; C<=0; D<=0; E<=0; end
    else begin
         B <= A;
         C <= B;
         D <= C;
         E <= D;
    end
end
endmodule