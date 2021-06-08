//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab #5
// Lab section: 
// TA: Yujia Zhai
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module processor #(parameter WORD_SIZE=32,MEM_FILE="init.coe") (
    input clk,
    input rst,   
	 // Debug signals 
    output [WORD_SIZE-1:0] prog_count, 
    output [5:0] instr_opcode,
    output [4:0] reg1_addr,
    output [WORD_SIZE-1:0] reg1_data,// 
    output [4:0] reg2_addr,
    output [WORD_SIZE-1:0] reg2_data,
    output [4:0] write_reg_addr,
    output [WORD_SIZE-1:0] write_reg_data 
);

// ----------------------------------------------
// Insert solution below here
// ----------------------------------------------
// program counter is the address of the current instruction
wire [WORD_SIZE-1:0] curr_PC; // incr_PC = curr_PC + 4; -- this is computed in the ALU
wire [WORD_SIZE-1:0] incr_PC;
wire [WORD_SIZE-1:0] next_PC;
wire [WORD_SIZE-1:0] branch_addr;
wire [WORD_SIZE-1:0] instruction;
wire [WORD_SIZE-1:0] alu_result;
wire [WORD_SIZE-1:0] alu_operand2;
wire [WORD_SIZE-1:0] read_data;
wire [4:0] write_register;
wire [1:0] alu_op;
wire [3:0] alu_control;
wire alu_src;
wire write_reg_select;
wire branch;
wire mem_to_reg;
wire mem_write;
wire reg_write;


gen_register PC(
    .clk(clk),
    .rst(rst),
    .write_en(1'b1),
    .data_in(next_PC),
    .data_out(curr_PC) //curr_PC = next_PC
);

// loading the instr binary string from the memory
// loading the data from memory for the LW instr
cpumemory #(.FILENAME(MEM_FILE)) instruction_memory (
    .clk(clk),
    .rst(rst),
    .instr_read_address(curr_PC[9:2]),
    .instr_instruction(instruction),
    .data_mem_write(mem_write),//currently we dont support SW instruction
    .data_address(alu_result[7:0]), // input address to load data is computed in the ALU
    .data_write_data(reg2_data), // load instr, rt (not rd)
    .data_read_data(read_data)// output read data is loaded 
);

alu pc_alu (
    .alu_control_in(`ALU_ADD),// PC = PC + 4
    .channel_a_in(curr_PC),
    .channel_b_in(4),
    .alu_result_out(incr_PC)
);

alu alu(
    .alu_control_in(alu_control),
    .channel_a_in(reg1_data),
    .channel_b_in(alu_operand2),
    .alu_result_out(alu_result)
);

control_unit control (
    .instr_op(instr_opcode),
    .reg_dst(write_reg_select),
    .branch(branch),
    .mem_read(),
    .mem_to_reg(mem_to_reg),
    .alu_op(alu_op),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write)
);

alu_control alu_control_unit (
    .alu_op(alu_op),
    .instruction_5_0(instruction[5:0]),//load the instruction from the main memory
    .alu_out(alu_control)
);

cpu_registers register_file (
    .clk(clk),
    .rst(rst),
    .reg_write(reg_write),
    .read_register_1(reg1_addr),
    .read_register_2(reg2_addr),
    .write_register(write_register),
    .write_data(write_reg_data),
    .read_data_1(reg1_data),
    .read_data_2(reg2_data)
);

// mux for alu_operand2
mux_2_1 alu_src_mux(
    .select_in(alu_src),
    .datain1(reg2_data),
    .datain2({{16{instruction[15]}}, instruction[15:0]}),//sign-ext for the imm
    .data_out(alu_operand2)
);

// mux for write register
mux_2_1 #(.WORD_SIZE(5)) write_reg_mux (
    .select_in(write_reg_select),
    .datain1(reg2_addr),
    .datain2(instruction[15:11]),
    .data_out(write_register)
);


// write data selection
mux_2_1 register_write_data (
    .select_in(mem_to_reg),
    .datain1(alu_result),
    .datain2(read_data),
    .data_out(write_reg_data)
);


mux_2_1 pc_mux(
    .select_in(1'b0),// we currently dont implement branch
    .datain1(incr_PC),
    .datain2(branch_addr),
    .data_out(next_PC)
);

alu branch_adder(
    .alu_control_in(`ALU_ADD),
    .channel_a_in(incr_PC),
    .channel_b_in({{16{instruction[15]}}, instruction[15:0]}),
    .alu_result_out(branch_addr)
);



assign prog_count = {curr_PC[31:2], 2'b00};// left shift by 2
assign instr_opcode = instruction[31:26];
assign reg1_addr = instruction[25:21];
assign reg2_addr = instruction[20:16];
assign write_reg_addr = write_register; 

endmodule
