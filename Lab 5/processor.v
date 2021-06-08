//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
//
// Assignment name: Lab #6
// Lab section:
// TA: Yujia Zhai
//
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================
`timescale 1ns / 1ps

module processor #(parameter WORD_SIZE=32,MEM_FILE="init.coe")(
    input clk,
    input rst,   
	 // Debug signals 
    output [WORD_SIZE-1:0] prog_count, 
    output [5:0] instr_opcode,
    output [4:0] reg1_addr,
    output [WORD_SIZE-1:0] reg1_data,
    output [4:0] reg2_addr,
    output [WORD_SIZE-1:0] reg2_data,
    output [4:0] write_reg_addr,
    output [WORD_SIZE-1:0] write_reg_data  
);

// ----------------------------------------------
// Insert solution below here
// ----------------------------------------------
wire [WORD_SIZE-1:0] curr_PC;
wire [WORD_SIZE-1:0] incr_PC;
wire [WORD_SIZE-1:0] next_PC;
wire [WORD_SIZE-1:0] instruction;
wire [WORD_SIZE-1:0] alu_result;
wire [WORD_SIZE-1:0] alu_operand2;
wire [WORD_SIZE-1:0] read_data;
wire [WORD_SIZE-1:0] branch_addr;
wire [4:0] write_register;
wire [3:0] alu_control;
wire [1:0] alu_op;
wire write_reg_select;
wire mem_to_reg;
wire reg_write;
wire mem_write;
wire alu_src;
wire zero;
wire branch;

//For stage 1
wire branch_stage4;
wire zero_stage_4;
wire [WORD_SIZE-1:0] branch_addr_stage4;

mux_2_1 pc_mux (
    .select_in(branch_stage4 & zero_stage_4),
    .datain1(incr_PC),
    .datain2(branch_addr),
    .data_out(next_PC)

);

gen_register PC(
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in(next_PC),
    .data_out(curr_PC)
);

alu pc_alu (
    .alu_control_in(`ALU_ADD),
    .channel_a_in(curr_PC),
    .channel_b_in(4),
    .alu_result_out(incr_PC)
);

wire mem_write_stage4;
wire [WORD_SIZE-1:0] alu_result_stage4;
wire [WORD_SIZE-1:0] reg2_data_stage4;

cpumemory #(.FILENAME(MEM_FILE)) instruction_memory (
    .clk(clk),
    .rst(rst),
    .instr_read_address(curr_PC[9:2]),
    .instr_instruction(instruction),
    .data_mem_write(mem_write_stage4),
    .data_address(alu_result_stage4[7:0]),
    .data_write_data(reg2_data_stage4),
    .data_read_data(read_data)
);

wire [WORD_SIZE-1:0]  incr_PC_stage2;
wire [WORD_SIZE-1:0] instruction_stage2;

gen_register #(.WORD_SIZE(64)) stage1_to_stage2 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({incr_PC,instruction}),
    .data_out({incr_PC_stage2, instruction_stage2})
);

//for stage 2
wire reg_write_stage3;
wire [4:0] write_register_stage5;

cpu_registers register_file (
    .clk(clk),
    .rst(rst),
    .reg_write(reg_write_stage3),
    .read_register_1(reg1_addr),
    .read_register_2(reg2_addr),
    .write_register(write_register_stage5),
    .write_data(write_reg_data),
    .read_data_1(reg1_data),
    .read_data_2(reg2_data)
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

wire mem_to_reg_stage3;
wire branch_stage3;
wire mem_read_stage3;
wire mem_write_stage3;
wire reg_dst_stage3;
wire alu_src_stage3;
wire [1:0] alu_op_stage3;
wire [WORD_SIZE-1:0] incr_PC_stage3;
wire [WORD_SIZE-1:0] reg1_data_stage3;
wire [WORD_SIZE-1:0] reg2_data_stage3;
wire [WORD_SIZE-1:0] instruction_stage3;

gen_register # (.WORD_SIZE(137)) stage2_to_stage3 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({reg_write, mem_to_reg, branch, mem_read, mem_write,
    write_reg_select, alu_op, alu_src, incr_PC_stage2, reg1_data, reg2_data,
    instruction_stage2}),
    .data_out({reg_write_stage3,mem_to_reg_stage3,branch_stage3, mem_read_stage3,mem_write_stage3,reg_dst_stage3
    ,alu_op_stage3,alu_src_stage3,incr_PC_stage3,reg1_data_stage3,reg2_data_stage3,
    instruction_stage3})
);

//for stage 3
mux_2_1 alu_src_mux(
    .select_in(alu_src_stage3),
    .datain1(reg2_data_stage3),
    .datain2({{16{instruction_stage3[15]}}, instruction_stage3[15:0]}),
    .data_out(alu_operand2)
);

alu alu(
    .alu_control_in(alu_control),
    .channel_a_in(reg1_data_stage3),
    .channel_b_in(alu_operand2),
    .alu_result_out(alu_result)
);

alu branch_adder(
    .alu_control_in(`ALU_ADD),
    .channel_a_in(incr_PC_stage3),
    .channel_b_in({{16{instruction_stage3[15]}}, instruction_stage3[15:0]}),
    .alu_result_out(branch_addr)
);

alu_control alu_control_unit (
    .alu_op(alu_op_stage3),
    .instruction_5_0(instruction_stage3[5:0]),
    .alu_out(alu_control)
);

mux_2_1 #(.WORD_SIZE(5)) write_reg_mux (
    .select_in(reg_dst_stage3),
    .datain1(instruction_stage3[20:16]),
    .datain2(instruction_stage3[15:11]),
    .data_out(write_register)
);

wire reg_write_stage4;
wire mem_to_reg_stage4;
wire mem_read_stage4;
wire[4:0] write_register_stage4;

gen_register #(.WORD_SIZE(107)) stage3_to_stage4 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({reg_write_stage3, mem_to_reg_stage3, branch_stage3, mem_read_stage3
    ,mem_write_stage3, branch_addr,zero,alu_result,reg2_data_stage3,
    write_register}),
    .data_out({reg_write_stage4,mem_to_reg_stage4,branch_stage4,mem_read_stage4,
    mem_write_stage4,branch_addr_stage4,zero_stage4,alu_result_stage4,
    reg2_data_stage4,write_register_stage4})
);

//for stage4

wire reg_write_stage5;
wire mem_to_reg_stage5;
wire [WORD_SIZE-1:0] read_data_stage5;
wire [WORD_SIZE-1:0] alu_result_stage5;

gen_register #(.WORD_SIZE(71)) stage4_to_stage5 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({reg_write_stage4, mem_to_reg_stage4, read_data,alu_result_stage4,
    write_register_stage4}),
    .data_out({reg_write_stage5,mem_to_reg_stage5,read_data_stage5, alu_result_stage5,write_register_stage5})
);

//for stage 5

mux_2_1 register_write_data (
    .select_in(mem_to_reg_stage5),
    .datain1(alu_result_stage5),
    .datain2(read_data_stage5),
    .data_out(write_reg_data)
);

assign prog_count = {incr_PC[31:2], 2'b00};
assign instr_opcode = instruction_stage2[31:26];
assign reg1_addr = instruction_stage2[25:21];
assign reg2_addr = instruction_stage2[20:16];
assign write_reg_addr = write_register_stage5;

endmodule
