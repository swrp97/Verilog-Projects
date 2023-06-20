// When a "case" statement is incompletely decoded, synthesis tool will infer the need for a latch to hold the 
// residual output when the select bits take the unspecified values. Hence it is upto the designer to code the design in such a way that latches can be avoided where possible.

// Sequential logic example due to incomplete case statement. The variable "flag" is not assigned a value in all the branches of case statement so a 2bit latch will be generated for flag. 

module incomp_state_spec (curr_state,flag);
 input [0:1] curr_state;
 output reg[0:1] flag;

 always @(curr_state)
  case (curr_state)
    0,1 : flag = 2;
    3   : flag = 0;
  endcase
endmodule

// Combinational logic example. All the variables for flag is defined for all possible values of curr_state hence only combinational circuit is generated and latch is avoided
 module comp_state_spec (curr_state,flag);
 input [0:1] curr_state;
 output reg[0:1] flag;

 always @(curr_state)
 begin
    flag = 0;
  case (curr_state)
    0,1 : flag = 2;
    3   : flag = 0;
  endcase
 end
endmodule

// we can also just give the value in the case statement for or put in a default case