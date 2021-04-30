//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab #3
// Lab section: 
// TA: Yujia Zhai
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

module aluControlUnit (
    input  wire [1:0] alu_op, 
    input  wire [5:0] instruction_5_0, 
    output wire [3:0] alu_out
    );

// ------------------------------
// Insert your solution below
// ------------------------------
reg[3:0] alu_result;

always @(alu_op, instruction_5_0) begin
    case({alu_op,instruction_5_0})
        //use second table
        8'b00xxxxxx: alu_result = 4'b0010; //lw (opcode) + load word & store (they are the same)
        8'b01xxxxxx: alu_result = 4'b0110; //beq
        8'b10100000: alu_result = 4'b0010; //R-type + add
        8'b10100010: alu_result = 4'b0110; //R-type + sub
        8'b10100100: alu_result = 4'b0000;//R-type + AND
        8'b10100101: alu_result = 4'b0001;//R-type + OR
        8'b10100111: alu_result = 4'b1100;//R-Type + NOR
        8'b10101010: alu_result = 4'b0111;//R-Type + slt
        
    endcase

end

assign alu_out = alu_result;

endmodule
