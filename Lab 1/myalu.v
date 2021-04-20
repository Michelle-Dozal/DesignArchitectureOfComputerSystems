//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab #1
// Lab section: 022
// TA: Yujia Zhai
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

//  Constant definitions 

module myalu # ( parameter NUMBITS = 16 ) (
    input wire clk, 
    input wire reset ,  
    input  wire[NUMBITS-1:0] A, 
    input  wire[NUMBITS-1:0] B, 
    input wire [2:0]opcode, 
    output reg [NUMBITS-1:0] result,  
    output reg carryout ,
    output reg overflow , 
    output reg zero  );

// ------------------------------
// Insert your solution below
// ------------------------------ 

 wire A_sign, B_sign;
        assign A_sign = A[NUMBITS-1];
        assign B_sign = B[NUMBITS-1];

  always @(posedge clk) begin
        carryout = 0;
        overflow = 0;
        zero = 0;
        if(reset) begin
           result = 0;
        end else begin
        //function blocks
        case(opcode)

        3'b000: begin
        //unsigned add function
        {carryout, result} = A + B;
        end

        3'b001: begin
        //signed add function
        result = A + B;
         //A > 0, B > 0 , result < 0 || A < 0, B < 0, result > 0
        overflow = (~A_sign & ~B_sign & result[NUMBITS-1]) | (A_sign & B_sign & ~result[NUMBITS-1]);
        end

        3'b010: begin
        //unsigned sub function
        {carryout, result} = A - B;
        end

        3'b011: begin
        //signed sub function
        result = A - B;
        // A > 0, B < 0, result < 0 || A < 0, B > 0 , result > 0
        overflow = (~A_sign & B_sign & result[NUMBITS-1]) | (A_sign & ~B_sign & ~result[NUMBITS-1]);
        end

        3'b100: begin
        //bit-wise AND funtion
        result = A & B;
        end
        
        3'b101: begin
        //bit-wise OR function
        result = A | B;
        end

        3'b110: begin
        //bit-wise XOR function
        result = A ^ B;
        end

        3'b111: begin
        //divide A by 2 function
        result = A >> 1;
        end
        endcase

        if(result == 0) begin
          zero = 1;
        end else begin
          zero = 0;
        end


        end
 end


endmodule
