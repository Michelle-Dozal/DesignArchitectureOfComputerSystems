//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozaal
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

//it takes in a
module controlUnit  (
    input  wire [5:0] instr_op, 
    output wire       reg_dst,   
    output wire       branch,     
    output wire       mem_read,  
    output wire       mem_to_reg,
    output wire [1:0] alu_op,        
    output wire       mem_write, 
    output wire       alu_src,    
    output wire       reg_write
    );

// ------------------------------
// Insert your solution below
// ------------------------------

reg[8:0] control_sig;

always @(instr_op)begin
    case(instr_op) //a swtich statement
        6'b000000: control_sig = 9'b100100010; //R-format
        6'b100011: control_sig = 9'b011110000; //lw
        6'b101011: control_sig = 9'bx1x001000; //sw
        6'b000100: control_sig = 9'bx0x000101; //beq
        6'b001000: control_sig = 9'b110100010; //imm

    endcase
    
    
end


assign {
reg_dst,
alu_src,
mem_to_reg,
reg_write,
mem_read,
mem_write,
branch,
alu_op
    } = control_sig; //9'b000000000;




endmodule
