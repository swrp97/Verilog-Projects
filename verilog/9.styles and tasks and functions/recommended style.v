// Copyright (c) 2023 SWRP's
// -------------------------------------------------------------
// FILENAME: counter.v
// TYPE: module
// DEPARTMENT: Chip Design
// AUTHOR: Prof. Shiva Swaroop K
// AUTHOR'S EMAIL: swaroop9112@gmail.com
//---------------------------------------------------------------
// Release History
// VERSION      DATE        AUTHOR        DESCRIPTION 
// 1.0       10/04/2023     Swaroop      Inital version
// 2.0       12/04/2023     Swaroop      Updated version with clear
// 2.1       10/05/2023     Swaroop      Asynchronous clear
//--------------------------------------------------------------------------------
// KEYWORDS : binary counter, asynchronous clear
//--------------------------------------------------------------------------------
//PURPOSE: 16-bit binary counter

module counter(
    data,
    clear,
    clock
);

output reg[15:0] data;          // The 16-bit count value

input clear;                    // Asunchronous clear
input clock;                    // Counter clock

// 16-bit binary counter with asynchronous clear

always@(posedge clock or negedge clear)
if(!clear)
 data <= 16'b0000000000000000 ;   // Clear counter
else 
 data <= data + 1 ;

endmodule

