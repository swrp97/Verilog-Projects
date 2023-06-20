// FUNCITONS, A function does not consume simulation time, returns a single value 
module fulladder(s,cout,a,b,cin);
input a,b,cin;
output s;
output cout;

assign s= sum(a,b,cin);         // Functions can only be used in assign statemtents. Whereas tasks can be used in always blocks.
assign cout= carry(a,b,cin);    //The arguments must be specified in the same order as they appear in the function declaration. The output of any function block is always a single output.
endmodule

function  sum;                   // we dont need to specify output as the function name is the output.
input  x,y,z;
begin 
    sum = x ^ y ^ z;            //  assign a value to the function name. Use only blocking assignments.
end
endfunction

function carry;
input  x,y,z;
begin 
    carry = (x&y) | (y&z) | (z&x); // assign a value to the function name. use only blocking assignments.
end
endfunction

/* A function cannot contain any time-controlled statements like #, @, wait, posedge, negedge
   A function cannot call a task because it may consume simulation time, but can call other functions
   A function should have atleast one input
   A function cannot have non-blocking assignments 
   A function cannot have any triggers
   A function cannot have an output or inout
*/ 

// TASKS- May consume Simulation time . The arguments must be specified in the same order as they appear in the task declaration. More than one output value can be returned by a task.

module taskfulladder (s,cout,a,b,cin);
input a,b,cin;
output reg s,cout;

always @(a,b,cin)
FA(s,cout,a,b,cin);     // we specify the signals in the same order as they appear in the task declaration 

task FA;
output sum,carry;       // we specify the signals in the same order as they appear in the task instantiation 
input A,B,C;
begin 
    #2 sum = A^B^C;     // in a task we can specify delays
    carry = (A&B)|(B&C)|(C&A);
end
endtask
endmodule
 
 /* Tasks are defined in the module in which they are used. It is possible to define a task in a separate file and use the compiled directive, including the task in the file, which instantiates the task.
    Tasks can include timing delays, such as posedge, negedge, # delay.
    Tasks can have any number of inputs and outputs.
    The variables declared within the task are local to that task. The order of declaration within the task defines how the variables passed to the task by the caller are used.
    Tasks can take, drive, and source global variables when no local variables are used. When local variables are used, the output is assigned only at the end of task execution.
    Tasks can call another task or function.
    Tasks can be used for modeling both combinational and sequential logic. 
     

                                 Functions	                                                                                                       Tasks
1)It cannot have time-controlling statements/delay and hence executes in 0 simulation time.	                1)It can contain time-controlling statements/delay and may only complete at nonzero simulation time.
2)It can call another function but not a task	                                                            2)It can call other tasks and functions.
3)The function should have atleast one input argument and cannot have output or inout arguments.	        3)Tasks can have zero or more arguments of any type.
4)A function can return only a single value.	                                                            4)A task can pass multiple values through output and inout type.

*/

