//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
//
// Assignment name: Pre-Lab #1
// Lab section: 021
// TA: Yujia Zhai
//
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module myalu_tb;
    parameter NUMBITS = 8;

    // Inputs
    reg clk;
    reg reset;
    reg [NUMBITS-1:0] A;
    reg [NUMBITS-1:0] B;
    reg [2:0] opcode;

    // Outputs
    wire [NUMBITS-1:0] result;
    reg [NUMBITS-1:0] R;
    wire carryout;
    wire overflow;
    wire zero;

    // -------------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // -------------------------------------------------------
    myalu #(.NUMBITS(NUMBITS)) uut (
        .clk(clk),
        .reset(reset) ,
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .carryout(carryout),
        .overflow(overflow),
        .zero(zero)
    );

      initial begin

     clk = 0; reset = 1; #50;
     clk = 1; reset = 1; #50;
     clk = 0; reset = 0; #50;
     clk = 1; reset = 0; #50;

     forever begin
        clk = ~clk; #50;
     end

    end

    integer totalTests = 0;
    integer failedTests = 0;
    initial begin // Test suite
        // Reset
        @(negedge reset); // Wait for reset to be released (from another initial block)
        @(posedge clk); // Wait for first clock out of reset
        #10; // Wait

        // Additional test cases
        // ---------------------------------------------
        // Testing unsigned additions
        // ---------------------------------------------
        $write("Test Group 1: Testing unsigned additions ... \n");
        opcode = 3'b000;
        totalTests = totalTests + 1;
        $write("\tTest Case 1.1: Unsigned Add ... ");
        A = 8'hFF; // 255 + 1 = 256 + 1 carry
        B = 8'h01;
        R = 8'h00;
        #100; // Wait
        if (R !== result || zero !== 1'b1 || carryout !== 1'b1) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
            end
        #10; // Wait

        totalTests = totalTests + 1;
        $write("\tTest Case 1.2: Unsigned Add ... ");
        A = 8'h0F;
        B = 8'hF0;
        R = 8'hFF; //240 + 15 = 255
        #100; // Wait
        if (R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // ---------------------------------------------
        // Testing unsigned subs
        // ---------------------------------------------
        $write("Test Group 2: Testing unsigned subs ...\n");
        opcode = 3'b010;
        totalTests = totalTests + 1;
        $write("\tTest Case 2.1: Unsigned Sub ... ");
                  A = 8'h00;
                  B = 8'h00;
                  R = 8'h00;
                  #100;
                  if (R !== result || zero !== 1'b1 || carryout !== 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10

        totalTests = totalTests + 1;
        $write("\tTest Case 2.2: Unsigned Sub ... ");
        A = 8'hFF;
        B = 8'hFF;
        R = 8'h00;
        #100;
        if (R !== result || zero !== 1'b1 || carryout !== 1'b0) begin
            $write("failed\n");
            failedTests = failedTests + 1;
        end else begin
            $write("passed\n");
        end
        #10; // Wait

        // ---------------------------------------------
        // Testing signed adds
        // ---------------------------------------------
        $write("Test Group 3: Testing signed adds ...\n");
        opcode = 3'b001;
        totalTests = totalTests + 1;
        $write("\tTest Case 3.1: Signed Add ... ");
        A = 8'h0A;
        B = 8'h01;
        R = 8'h0B;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

         totalTests = totalTests + 1;
        $write("\tTest Case 3.2: Signed Add ... ");
        A = 8'hAE; //-82 + 1 = -81 = AF
        B = 8'h01;
        R = 8'hAF;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
        $write("passed\n");
        end
        #10

        // ---------------------------------------------
        // Testing signed subs
        // ---------------------------------------------
        $write("Test Group 4: Testing signed subs ...\n");
        opcode = 3'b011;
        totalTests = totalTests + 1;
        $write("\tTest Case 4.1: Signed Sub ... ");
        A = 8'h08; // x - y = x + -y
        B = 8'h08;
        R = 8'h00;
        #100;
        if( R !== result || zero !== 1'b1 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        totalTests = totalTests + 1;
        $write("\tTest Case 4.2: Signed Sub ... ");
        A = 8'h08;
        B = 8'h01; // 8 + -1 = 7
        R = 8'h07;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        // ---------------------------------------------
        // Testing ANDS
        // ---------------------------------------------
        $write("Test Group 5: Testing ANDs ...\n");
        opcode = 3'b100;
        totalTests = totalTests + 1;
        $write("\tTest Case 5.1: ANDs ... ");
        A = 8'hFF;
        B = 8'h00;
        R = 8'h00;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        totalTests = totalTests + 1;
        $write("\tTest Case 5.2: ANDs ... ");
        A = 8'hFF;
        B = 8'h0F;
        R = 8'h0F;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        // ----------------------------------------
        // ORs
        // ----------------------------------------
        $write("Test Group 6: Testing ORs ...\n");
        opcode = 3'b101;
        totalTests = totalTests + 1;
        $write("\tTest Case 6.1: ORs ... ");
        A = 8'hFF;
        B = 8'h00;
        R = 8'hFF;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10


        totalTests = totalTests + 1;
        $write("\tTest Case 6.2: ORs ... ");
        A = 8'h1F;
        B = 8'h0F;
        R = 8'h1F;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        // ----------------------------------------
        // XORs
        // ----------------------------------------
        $write("Test Group 7: Testing XORs ...\n");
        opcode = 3'b110;
        totalTests = totalTests + 1;
        $write("\tTest Case 7.1: XORs ... ");
        A = 8'hFF;
        B = 8'hFF;
        R = 8'h00;
        #100;
        if( R !== result || zero !== 1'b1 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        totalTests = totalTests + 1;
        $write("\tTest Case 7.2: XORs ... ");
        A = 8'h0F;
        B = 8'hF0;
        R = 8'hFF;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        // ----------------------------------------
        // Div 2
        // ----------------------------------------
        $write("Test Group 8: Testing DIV 2 ...\n");
        opcode = 3'b111;
        totalTests = totalTests + 1;
        $write("\tTest Case 8.1: DIV by 2 ... ");
        A = 8'h12; // = 18 divide by 2 is 9
        R = 8'h09;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
        #10

        totalTests = totalTests + 1;
        $write("\tTest Case 8.2: DIV by 2 ... ");
        A = 8'h10; // = 16 / 2 = 8
        R = 8'h08;
        #100;
        if( R !== result || zero !== 1'b0 || carryout !== 1'b0) begin
                $write("failed\n");
                failedTests = failedTests + 1;
        end else begin
                $write("passed\n");
        end
#10

        // -------------------------------------------------------
        // End testing
        // -------------------------------------------------------
        $write("\n-------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests", totalTests-failedTests,totalTests);
        $write("\n-------------------------------------------------------\n");
        $finish();
end
endmodule


