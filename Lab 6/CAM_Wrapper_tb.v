//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab #7
// Lab section: 
// TA: Yujia Zhai
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

`define CAM_DEPTH 8
`define CAM_WIDTH 8

module CAM_Wrapper_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [`CAM_DEPTH-1:0] we_decoded_row_address;
    reg [`CAM_WIDTH-1:0] search_word;
    reg [`CAM_WIDTH-1:0] dont_care_mask;

    // Outputs
    wire [`CAM_DEPTH-1:0] decoded_match_address_BCAM;
    wire [`CAM_DEPTH-1:0] decoded_match_address_TCAM;
    wire [`CAM_DEPTH-1:0] decoded_match_address_STCAM;

    // Instantiate the Unit Under Test (UUT)
    // Notice all three uut's (uut, uut2, uut3) share all inputs and only differ on their output
    // You can differ all inputs and outputs if desired, but "sufficient" testing can be done 
    // by just checking the outputs and keeping all stored data the same.
    CAM_Wrapper # (.CAM_DEPTH(`CAM_DEPTH), .CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("BCAM")) uut1 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_BCAM)
    );

    CAM_Wrapper # (.CAM_DEPTH(`CAM_DEPTH), .CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("TCAM")) uut2 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_TCAM)
    );
   
    CAM_Wrapper # (.CAM_DEPTH(`CAM_DEPTH), .CAM_WIDTH(`CAM_WIDTH), .CAM_TYPE("STCAM")) uut3 (
        .clk(clk), 
        .rst(rst), 
        .we_decoded_row_address(we_decoded_row_address), 
        .search_word(search_word), 
        .dont_care_mask(dont_care_mask), 
        .decoded_match_address(decoded_match_address_STCAM)
    );

    // Clock block 
    initial begin 
        clk = 0; rst = 1; #10;
        clk = 1; rst = 1; #10;
        clk = 0; rst = 0; #10;
        clk = 1; rst = 0; #10;

        forever begin 
            clk = ~clk; #10;
        end 
    end

    integer totalTests = 0;
    integer testGroup = 0;
    integer testNumber = 0;
    integer passedTests = 0;
   
    initial begin
        @(negedge rst); // Wait for rst to be released
        @(posedge clk); // Wait for first clk high out of rst
        // *****************************************************
        // First, write the values (address one example shown)
        // *****************************************************
        //     addr|  search   | don't care (stored)
        //      1  | 0000 0001 | 0000 0000
        //      2  | ???? ???? | ???? ????
        //      3  | ???? ???? | ???? ????
        //      4  | ???? ???? | ???? ????
        //         |           |
        //      5  | ???? ???? | ???? ????
        //      6  | ???? ???? | ???? ????
        //      7  | ???? ???? | ???? ????
        //      8  | ???? ???? | ???? ????
        // -------------------------------------------------------
        we_decoded_row_address = 8'h11;
        search_word = 8'h01; 
        dont_care_mask = 8'h00; 
        @(posedge clk); @(posedge clk); #1; // Wait for 2 clk ticks (and a little bit)
        
        // ... Change the dont_care_mask to store "don't care" bits for STCAM
        
        we_decoded_row_address  = 8'h00; // No longer writing to addresses
        dont_care_mask = 8'h00; 
        //*********************************************************
        // Test cases
        //*********************************************************
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 0;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (0000 0001 => 0000 0001)...", testGroup,testNumber);
        search_word  = 8'h01; 
        @(posedge clk); @(posedge clk); #1; 
        if (decoded_match_address_BCAM === 8'h11) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        
        //BCAM TEST
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 1;

        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic single-match search (BCAM)  (1000 0001 => 1000 0001)...", testGroup,testNumber);
        search_word  = 8'h81;
        @(posedge clk); @(posedge clk); #1;
        if (decoded_match_address_BCAM === 8'h81) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        
        //STCAM TEST
        testGroup = 1;
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 0;
        
        dont_care_mask = 8'h00;
        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic (STCAM)  (1000 0001 => 1000 0001)...", testGroup,testNumber);
        search_word  = 8'h81;
        @(posedge clk); @(posedge clk); #1;
        if (decoded_match_address_STCAM === 8'h81) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        
        //STCAM TEST
        testGroup = 1;
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 1;
        
        dont_care_mask = 8'h02;
        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic (STCAM)  (0100 0000 => 0000 0010)...", testGroup,testNumber);
        search_word  = 8'h40;
        @(posedge clk); @(posedge clk); #1;
        if (decoded_match_address_STCAM === 8'h02) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        
        //STCAM TEST
        testGroup = 1;
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 2;
        
        dont_care_mask = 8'h00;
        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic (STCAM)  (0100 0100 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'h44;
        @(posedge clk); @(posedge clk); #1;
        if (decoded_match_address_STCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        
        //TCAM TEST
        testGroup = 2;
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 0;
        
        dont_care_mask = 8'h00;
        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic (TCAM)  (0000 0000 => 0000 0000)...", testGroup,testNumber);
        search_word  = 8'h00;
        @(posedge clk); @(posedge clk); #1;
        if (decoded_match_address_TCAM === 8'h00) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        
        //TCAM TEST
        testGroup = 2;
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 1;
        
        dont_care_mask = 8'h81;
        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic (TCAM)  (0000 0000 => 1000 0001)...", testGroup,testNumber);
        search_word  = 8'h00;
        @(posedge clk); @(posedge clk); #1;
        if (decoded_match_address_TCAM === 8'h81) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end
        
        //TCAM TEST
        testGroup = 2;
        testGroup = testGroup + 1;
        $display("Test Group %0d: BCAM tests...",testGroup);
        testNumber = 2;
        
        dont_care_mask = 8'hFF;
        testNumber = testNumber + 1;
        totalTests = totalTests + 1;
        $write("\tTest Case %0d.%0d: Test basic (TCAM)  (0000 0000 => 1111 1111)...", testGroup,testNumber);
        search_word  = 8'h00;
        @(posedge clk); @(posedge clk); #1;
        if (decoded_match_address_TCAM === 8'hFF) begin
            $display("passed.");
            passedTests = passedTests + 1;
        end else begin
            $display("failed.");
        end

        // Change the dont_care_mask to test "don't care" input bits for TCAM

        // ****************************************************************
        // End testing 
        // ****************************************************************
        $display("-------------------------------------------------------------");
        $display("Testing complete\nPassed %0d / %0d tests.",passedTests,totalTests);
        $display("-------------------------------------------------------------");
        $finish();
    end
   
endmodule

