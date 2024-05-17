module testbench();

    // Parameters
    localparam WIDTH = 64; // Width of the input data
    localparam DLC_WIDTH = 4; // Width of the DLC output
    
    // Signals
    reg [WIDTH-1:0] data; // Input data signal
    wire [DLC_WIDTH-1:0] expected_dlc; // Expected DLC output signal
    wire [DLC_WIDTH-1:0] actual_dlc; // DLC output signal from the module

    // Instantiate the module under test
    calculate_dlc uut (
        .data(data),
        .dlc(actual_dlc)
    );

    // Test cases
    initial begin
        // Test case 1: 64-bit data with 0 non-zero bytes (expected DLC = 0)
        data = 64'h0000000000000000;
        expected_dlc = 4'b0000;

        // Apply input data and monitor the DLC output
        #10; // Delay for a few simulation cycles
        $display("Test Case 1:");
        $display("Input Data: %h, Expected DLC: %b, Actual DLC: %b",
                 data, expected_dlc, actual_dlc);
        if (actual_dlc !== expected_dlc) begin
            $display("Test Case 1 Failed! DLC mismatch.");
            $finish;
        end

        // Test case 2: 64-bit data with 1 non-zero byte (expected DLC = 1)
        data = 64'h00000000000000FF;
        expected_dlc = 4'b0001;

        // Apply input data and monitor the DLC output
        #10; // Delay for a few simulation cycles
        $display("\nTest Case 2:");
        $display("Input Data: %h, Expected DLC: %b, Actual DLC: %b",
                 data, expected_dlc, actual_dlc);
        if (actual_dlc !== expected_dlc) begin
            $display("Test Case 2 Failed! DLC mismatch.");
            $finish;
        end

        // Add more test cases as needed...

        $display("\nAll test cases passed!");
        $finish;
    end

endmodule
