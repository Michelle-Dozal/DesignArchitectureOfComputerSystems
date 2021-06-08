//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab#7
// Lab section: 
// TA: Yujia Zhai
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module BCAM_Cell (
    input wire clk,
    input wire rst,
    input wire we,
    input wire cell_search_bit,
    input wire cell_dont_care_bit,
    input wire cell_match_bit_in,
    output wire cell_match_bit_out
);
	 
reg stored_bit;
	 
// Insert your solution below here.

always @(posedge clk or posedge rst) begin
    if(rst) stored_bit = 0;
    else begin
        if(we)
            stored_bit <= cell_search_bit;
    end
end

//Finished updating now matching

assign cell_match_bit_out = cell_match_bit_in && (cell_search_bit == stored_bit);

endmodule
