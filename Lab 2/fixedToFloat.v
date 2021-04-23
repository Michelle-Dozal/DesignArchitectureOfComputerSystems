//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab #2
// Lab section: 021
// TA: Yujia Zhai
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module fixedToFloat(
  input wire clk, 
  input wire rst , 
  input wire[31:0] targetnumber, 
  input wire[4:0] fixpointpos , 
  output reg[31:0] result );

// Your  Implementation 

// -------------------------------------------	
// Register the results 
// -------------------------------------------

reg[22:0] mantissa;
reg[7:0] exponent;
reg[31:0] fixedNumber;
reg sign;
integer leading_index;



always @(*) begin 	
	// Replace the following code with your implmentation
    
    sign = targetnumber[31];
    //if it is pos -> fixedNum = target
    //if neg -> fixedNum = target(2's complement + 1) = ~targetNum + 1;
    // a = x ? y : z => if x true a = y...else a = z
    fixedNumber = sign == 1'b1 ? ~targetnumber + 32'h00000001 : targetnumber;
	
    leading_index = 32;
    while(leading_index >= 0 && fixedNumber[leading_index - 1] == 1'b0)
     leading_index = leading_index - 1; //ends when it reaches the leading one
     
    exponent = 127 + leading_index - (1 + fixpointpos);
    mantissa = (leading_index < 23) ? fixedNumber << (23 - (leading_index - 1)) : fixedNumber >> ((leading_index - 1) - 23);
    
    //For if input = 0.0
    if(targetnumber == 0) begin
        sign = 0;
        exponent = 0;
        mantissa = 0;
        end
    
    //The combination of all the bits.
    result = {sign, exponent, mantissa};
    
end 
endmodule
