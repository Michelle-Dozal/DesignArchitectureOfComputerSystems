//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab #2
// Lab section: 
// TA: 
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module floatToFixed(
  input wire clk, 
  input wire rst , 
  input wire[31:0] float, 
  input wire[4:0] fixpointpos , 
  output reg[31:0] result );

// Your  Implementation 

// -------------------------------------------	
// Register the results 
// -------------------------------------------
        integer exponent;
        integer shift; //using to store shift
        reg[31:0] r; //using to store result
        reg sign;

always @(*) begin
	// Replace the following code with your implmentation
	//result[23] = 1'b1;
 //compute exponent = float[30:23] - 127;
 //right shift float[22:0] by 23 - (exponent + fixpointpos);
 //if input float is neg -- last step
 //change result into it's 2-complement
        sign = float[31];
        //result[23] = 1'b1;
        exponent  = float[30:23] - 127;
        shift =  23 - (exponent + fixpointpos);
        r = {1'b1, float[22:0]};

        if(shift > 0) begin
        r = r >>  shift;
        end

        else if (shift <= 0) begin
        r = r << ~shift;
        end

        if(sign == 1'b1) begin //if neg
        r = ~r + 1'b1;
        end


        result =  r;
 
    
end 
endmodule
