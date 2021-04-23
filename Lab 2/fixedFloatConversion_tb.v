//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Michelle Dozal
// Email: mdoza001@ucr.edu
// 
// Assignment name: Lab #2 Pre-lab
// Lab section: 021
// TA: Yujia Zhai
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module fixedFloatConversion_tb;
    // Inputs
    reg clk; 
    reg rst; 
    reg [31:0] targetnumber;
    reg [4:0] fixpointpos;
    reg  opcode; 
    
    wire [31:0] resultnumber;
    reg [31:0] R;
    
    // ---------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // --------------------------------------------------- 
    fixedFloatConversion uut (
        .clk( clk ) , 
        .rst(rst) ,         
        .targetnumber(targetnumber), 
        .fixpointpos(fixpointpos),
        .opcode(opcode) , 
        .result(resultnumber)
    );

    initial begin 
        clk = 0; rst = 1; #50; 
        clk = 1; rst = 1; #50; 
        clk = 0; rst = 0; #50; 
        clk = 1; rst = 0; #50; 
        forever begin 
            clk = ~clk; #50; 
        end 
    end
     
    integer failedTests = 0;
    integer totalTests = 0;
    initial begin
        // Reset
        @(negedge rst); // Wait for reset to be released (from another initial block)
        @(posedge clk); // Wait for first clock out of reset 
        #10; // Wait 

        fixpointpos = 4'b0000;
        targetnumber = { 32'h0 }; 
        R = { 32'h0 }; 
        // -------------------------------------------------------
        // Test group 1: Fixed Point to Floating Point
        // -------------------------------------------------------
        $display("Test Group 1: Testing Fixed point to floating point... ");
        opcode = 1'b0; 

        $write("\tTest Case 1.1: Convert 25.25 (011001.01,2=>0 10000011 1001010..)...");
        totalTests = totalTests + 1;
        // Set inputs
        fixpointpos = 4'b0010;
        targetnumber = { {24'h000000}, {8'b011001_01}  }; 
        R = 32'b0_10000011_10010100000000000000000;
        #100; // Wait
        if (R != resultnumber) begin
            $display("failed: Expected: %b, got %b", R, resultnumber); 
            failedTests = failedTests + 1;
        end else begin
            $display("passed"); 
        end

        // -------------------------------------------------------
        // Put your tests here
        // -------------------------------------------------------
        
        $write("\tTest Case 1.2: Convert 1.125 (00001.001,2=>0 011111111 0010000..)...");
        totalTests = totalTests + 1;

        fixpointpos = 4'b0011;
        targetnumber = { {24'h000000}, {8'b00001_001}  }; //fixed point target number
        R = 32'b0_01111111_00100000000000000000000; //floating point result
        #100;
        if (R != resultnumber) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

        $write("\tTest Case 1.3: Convert 10.3125 (1010.0101,2=>0 10000010 01001010..)...");
        totalTests = totalTests + 1;

        fixpointpos = 4'b0100;
        targetnumber = { {24'h000000}, {8'b1010_0101}  }; //fixed point target number
        R = 32'b0_10000010_01001010000000000000000; //floating point result
        #100;
        if (R != resultnumber) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

        $write("\tTest Case 1.4: Convert 5.75 (000101.11,2=>0 10000001 0111000..)...");
        totalTests = totalTests + 1;

        fixpointpos = 4'b0010;
        targetnumber = { {24'h000000}, {8'b000101_11}  }; //fixed point target number
        R = 32'b0_10000001_01110000000000000000000; //floating point result
        #100;
        if (R != resultnumber) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end


        $write("\tTest Case 1.5: Convert 3.625 (00011.101,2=>0 10000000 1101000..)...");
        totalTests = totalTests + 1;

        fixpointpos = 4'b0011;
        targetnumber = { {24'h000000}, {8'b00011_101}  }; //fixed point target number
        R = 32'b0_10000000_11010000000000000000000; //floating point result
        #100;
        if (R != resultnumber) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

        $write("\tTest Case 1.6: special 0.0...");
        totalTests = totalTests + 1;

        fixpointpos = 4'b0001;
        targetnumber = { {24'h000000}, {8'b00000_000}  }; //fixed point target number
        R = 32'b0_00000000_00000000000000000000000; //floating point result
        #100;
        if (R != resultnumber) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

		  
        // -------------------------------------------------------
        // Test group 2: Floating Point to Fixed Point
        // -------------------------------------------------------
        $display("Test Group 2: Testing Floating point to fixed point... ");
        opcode = 1'b1; 

        $write("\tTest Case 2.1: 25.25 (0 10000011 1001010,2=>011001.01)..."); 
        totalTests = totalTests + 1;
        opcode = 1'b1; 
        fixpointpos = 4'b0010;
        targetnumber = 32'b0_10000011_10010100000000000000000;
        R = { {24'h000000}, {8'b011001_01}  };  
        #100; 
        if ( R != resultnumber || resultnumber === 32'bz) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end
            
        // -------------------------------------------------------
        // Put your tests here
        // -------------------------------------------------------            
		  $write("\tTest Case 2.2: 1.125 (0 011111111 00100000,2=>00001.001)...");
        totalTests = totalTests + 1;
        opcode = 1'b1;
        fixpointpos = 4'b0011;
        targetnumber = 32'b0_01111111_00100000000000000000000;
        R = { {24'h000000}, {8'b00001_001}  };
        #100;
        if ( R != resultnumber || resultnumber === 32'bz) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

        $write("\tTest Case 2.3: 10.3125 (0 10000010 01001010,2=>1010.0101)...");
        totalTests = totalTests + 1;
        opcode = 1'b1;
        fixpointpos = 4'b0100;
        targetnumber = 32'b0_10000010_01001010000000000000000;
        R = { {24'h000000}, {8'b1010_0101}  };
        #100;
        if ( R != resultnumber || resultnumber === 32'bz) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

        $write("\tTest Case 2.4: 5.75 (0 10000001 01110000,2=>000101.11)...");
        totalTests = totalTests + 1;
        opcode = 1'b1;
        fixpointpos = 4'b0010;
        targetnumber = 32'b0_10000001_01110000000000000000000;
        R = { {24'h000000}, {8'b000101_11}  };
        #100;
        if ( R != resultnumber || resultnumber === 32'bz) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

        $write("\tTest Case 2.5: 3.625 (0 10000000 11010000,2=>00011.101)...");
        totalTests = totalTests + 1;
        opcode = 1'b1;
        fixpointpos = 4'b0011;
        targetnumber = 32'b0_10000000_11010000000000000000000;
        R = { {24'h000000}, {8'b00011_101}  };
        #100;
        if ( R != resultnumber || resultnumber === 32'bz) begin
            $display("failed: Expected: %b, got %b", R, resultnumber);
            failedTests = failedTests + 1;
        end else begin
            $display("passed");
        end

        // --------------------------------------------------------------
        // End testing
        // --------------------------------------------------------------
        $write("\n--------------------------------------------------------------");
        $write("\nTesting complete\nPassed %0d / %0d tests",totalTests-failedTests,totalTests);
        $write("\n--------------------------------------------------------------\n");
        $finish();
    end
endmodule

