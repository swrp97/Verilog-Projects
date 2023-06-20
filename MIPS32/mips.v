// Data Hazards, structural hazards and control hazards are not handled. So dummy instructions need to be placed if there is any hazards. 
// Two latches HALTED and TAKEN BRANCH used in the IF stage to check for conditions.
// 5 stage pipeline with Instruction fetch, Instruction decode, Execution, Memory Access and Write Back stages.
// We use PC and NPC to store the address of the next instruction to be fetched. We increment them by 1 every clk cycle. Since it is a pipelined architecture both the npc and pc needs to updated and forwarded throughout the stages.
// IF_ID latch b/w Instruction fetch and Instruction decode stage
// ID_EX latch b/w Instruction decode and Execution stage
// EX_MEM  latch b/w Execution stage and Memory Access stage 
// MEM_WB  latch b/w Memory Access and Write Back stage 

module pipe_MIPS32 (clk1,clk2);

input clk1, clk2;               // Two- phase clock

reg [31:0] PC, IF_ID_IR, IF_ID_NPC;     // 32 bit Program counter, Instruction register and Next program counter of IF_ID stage
reg [31:0] ID_EX_IR, ID_EX_NPC,ID_EX_A,ID_EX_B,ID_EX_Imm;   // 32 bit Instruction register and Next program counter, register A and B and Imm of ID_EX stage
reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;         // 3 bit opcode type set after Instruction decode stage, this is forwarded to the next stages. 
reg [31:0] EX_MEM_IR, EX_MEM_ALUOut,EX_MEM_B;           // 32 bit Instruction register, ALUout and register B of EX_MEM stage
reg        EX_MEM_cond;                                 // 1 bit register to check if BEQZ and BNEQZ condition is true or not
reg [31:0] MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD;       // 32 bit Instruction register, ALUout and load data 

reg [31:0] Reg [0:31];                              // Register bank (32 x 32)
reg [31:0] Mem [0:1023];                            // Memory ( 32 bit, 1024 memory locations)

parameter ADD = 6'b000000,   SUB = 6'b000001,   AND = 6'b000010,    OR = 6'b000011,   SLT = 6'b000100,   MUL = 6'b000101,   LW = 6'b001000,   SW = 6'b001001,  // INSTRUCTION OPCODES
         ADDI = 6'b001010,  SUBI = 6'b001011,  SLTI = 6'b001100, BNEQZ = 6'b001101,  BEQZ = 6'b001110,   HLT = 6'b111111 ;                  

parameter RR_ALU = 3'b000, RM_ALU = 3'b001, LOAD = 3'b010, STORE = 3'b011, BRANCH = 3'b100, HALT = 3'b101;          // Type of instruction encoded in 3 bits. (opcode type). Set in Instruction Decode stage

reg HALTED; // Set after HLT instrction is completed in WB stage (so as to ensure the instructions before HLT are executed completely.)

reg TAKEN_BRANCH; // Required to disable instructions after branch has been taken. Made to ensure the following instructions dont make any changes. 

always @ (posedge clk1)         // IF: INSTRUCTION FETCH STAGE
    if(HALTED == 0)             // If halted is 0 begin. HALTED IS SET IN THE WB STAGE so if a halt instruction has set this flag to one then the following instructions will not execute
    begin
        if (((EX_MEM_IR[31:26] == BEQZ) && (EX_MEM_cond == 1)) ||       // Check if EX_MEM_IR opcode is a BEQZ instruction and the condition is 1 
        ((EX_MEM_IR[31:26] == BNEQZ) && (EX_MEM_cond == 0)))            // OR Check if EX_MEM_IR opcode is a BNEQZ instruction and the condition is 0 
        begin                                                           // if any one of the above condition is true 
            IF_ID_IR <= #2 MEM[EX_MEM_ALUOut];                          // Copy the memory location pointed to by EX_MEM_ALUOut to the IF_ID_IR register. ALUOut of EX_MEM stage will contain the address of the next instruction to be fetched if branch has been taken.
            TAKEN_BRANCH <= #2 1'b1;                                    // Set TAKEN BRANCH FLAG to 1
            IF_ID_NPC <= #2 EX_MEM_ALUOut + 1;                          // Update the NPC by one 
            PC        <= #2 EX_MEM_ALUOut + 1;                          // Update the PC by one
        end
        else                                                            // If it is not a branch instruction, Then normal execution flow
        begin
            IF_ID_IR <=  #2 Mem[PC];                                     // Fetch instruction pointed to by PC
            IF_ID_NPC <= #2 PC + 1;
            PC        <= #2 PC + 1;
        end
    end


always @(posedge clk2)                                                  // ID: INSTRUCTION DECODE STAGE
if (HALTED == 0)                                                        // If halted is 0 begin. HALTED IS SET IN THE WB STAGE so if a halt instruction has set this flag to one then the following instructions will not execute
 begin
    if (IF_ID_IR[25:21] == 5'b00000) ID_EX_A <= 0 ;                     // Check if rs is equal to R0 (R0 which is always set to 00000), if it is equal then just assign A with 0 instead of moving the values.
    else ID_EX_A     <= #2 Reg [IF_ID_IR[25:21]];                       // Else move Rs to ID_EX_A

    if (IF_ID_IR[20:16] == 5'b00000) ID_EX_B <= 0;                      // Check if rt is equal to R0 (R0 which is always set to 00000), if it is equal then just assign A with 0 instead of moving the values.
    else ID_EX_B     <= #2 Reg[IF_ID_IR[20:16]];                        // Else move rt to ID_EX_B

    ID_EX_NPC <= #2 IF_ID_NPC;                                          // Forward NPC 
    ID_EX_IR <= #2 IF_ID_IR;                                            // Forward IR 
    ID_EX_Imm <= #2 {{16{IF_ID_IR[15]}},{IF_ID_IR[15:0]}};              // Sign extend the 16 bit imm operand to 32 bits and store it in ID_EX_Imm 

    case (IF_ID_IR[31:26])                                              // Check the opcode. Depending on opcode set the opcode type register in this stage
       ADD,SUB,AND,OR,SLT,MUL :     ID_EX_type <= #2 RR_ALU;            // register register type   
       ADDI,SUBI,SLTI:              ID_EX_type <= #2 RM_ALU;            // register memory type (immediate type)
       LW:                          ID_EX_type <= #2 LOAD;              // Load 
       SW:                          ID_EX_type <= #2 STORE;             // Store
       BNEQZ,BEQZ:                  ID_EX_type <= #2 BRANCH;            // branch
       HLT:                         ID_EX_type <= #2 HALT;              // halt
       default:                     ID_EX_type <= #2 HALT; 
    endcase
end

always @ (posedge clk1)                                              // EX: EXECUTION STAGE 
    if(HALTED == 0)
    begin
        EX_MEM_type <= #2 ID_EX_type;                                   // Forward opcode type
        EX_MEM_IR <= #2 ID_EX_IR;                                            // Forward IR  
        TAKEN_BRANCH <= #2 0;                                              // Set taken_branch to 0. Because in the next stage store instruction will depend on taken branch being 0  

        case(ID_EX_type)                                                 // based on opcode type 
        
        RR_ALU: begin                                                    // Register Register type instruction
            case(ID_EX_IR[31:26])                                        // based on opcode.  
            ADD:    EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_B;
            SUB:    EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_B;
            AND:    EX_MEM_ALUOut <= #2 ID_EX_A & ID_EX_B;
             OR:    EX_MEM_ALUOut <= #2 ID_EX_A | ID_EX_B;
            SLT:    EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_B;
            MUL:    EX_MEM_ALUOut <= #2 ID_EX_A * ID_EX_B;
        default:    EX_MEM_ALUOut <= #2 32'hx;
        endcase
        end

        RM_ALU: begin                                                   // register memory or immediate type instructions
            case (ID_EX_IR[31:26])                                      // based on opcode, 
            ADDI:    EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;
            SUBI:    EX_MEM_ALUOut <= #2 ID_EX_A - ID_EX_Imm;
            SLTI:    EX_MEM_ALUOut <= #2 ID_EX_A < ID_EX_Imm;
         default:    EX_MEM_ALUOut <= #2 32'hx; 
        endcase
        end

        LOAD, STORE: begin                                              // for both load or store type do this ..  
            EX_MEM_ALUOut <= #2 ID_EX_A + ID_EX_Imm;                    // Calculate the address of the memory
            EX_MEM_B      <= #2 ID_EX_B;                                // forwarded because its required for store instructions
        end

        BRANCH: begin
            EX_MEM_ALUOut <= #2 ID_EX_NPC + ID_EX_Imm;                  // Add npc and offset to get the target address if we need to take a branch. This is sent back to IF stage because if the branch condition is true ALUout contains the address of the next instruction to be fetched in memory
            EX_MEM_cond   <= #2 (ID_EX_A == 0)                          // Set condition to 1 if  true. This is sent back to the IF stage to check for branch condition
        end

        endcase
    end

always @(posedge clk2)                                                  // MEM: Memory Access stage, only load and store use this every other instruction is forwarded
if(HALTED == 0)
begin
    MEM_WB_type <= #2 EX_MEM_type;                                         // forward opcode type
    MEM_WB_IR   <= #2 EX_MEM_IR;                                           // forward IR

    case (EX_MEM_type)
    RR_ALY, RM_ALU:
                MEM_WB_ALUOut <= #2 EX_MEM_ALUOut;                         // forward aluout for rr and rm type instructions

    LOAD:       MEM_WB_LMD    <= #2 Mem[EX_MEM_ALUOut];                    // load data from memory pointed to by aluout and store in lmd

    STORE:      if(TAKEN_BRANCH == 0 )                                     // execute only if branch is not taken. if taken branch is 1 then write will be disabled
                Mem[EX_MEM_ALUOut] <= #2 EX_MEM_B;                         // store b in the memory location pointed to by aluout 
    endcase
end

always @(posedge clk1)                                                     // WB: Write Back stage
 begin
    if (TAKEN_BRANCH == 0)                                                 // execute only when taken branch is 0. Disable write back if taken branch is 1
    case (MEM_WB_type)
    RR_ALU:     Reg[MEM_WB_IR[15:11]]   <= #2 MEM_WB_ALUOut;              // R type instruction so store result in 'rd'
    RM_ALU:     Reg[MEM_WB_IR[20:16]]   <= #2 MEM_WB_ALUOut;              // I type instruction so store result in 'rt' 
    LOAD:       Reg[MEM_WB_IR[20:16]]   <= #2 MEM_WB_LMD;                 // Load data into 'rt'
    HALT:       HALTED <= #2 1'b1;                                        // HALTED is set only in the write back stage so as to ensure the instructions before a halt instruction are not interupped before they reach their wb stage.
    endcase
end

endmodule
