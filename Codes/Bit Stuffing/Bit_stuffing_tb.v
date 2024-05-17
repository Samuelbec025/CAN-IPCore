module testbench_can_bit_stuffing();

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in time units

  // Signals
  reg [63:0] data_in;        // Input data (up to 64 bits)
  reg clk = 0;               // Clock signal
  wire [63:0] data_out;      // Output data with bit stuffing

  // Instantiate the CAN bit stuffing module
  can_bit_stuffing dut (
    .data_in(data_in),
    .clk(clk),
    .data_out(data_out)
  );

  // Clock generation
  always #((CLK_PERIOD / 2)) clk = ~clk; // Toggle clock every half period

  // Test procedure
  initial begin
    $display("=== Test Bench for CAN Bit Stuffing ===");

    // Test case 1: 8-bit input data (no consecutive 5 same polarity bits)
    //data_in = 8'b10101010;
    //run_test();

    // Test case 2: 32-bit input data with 6 consecutive '1's (expecting bit stuffing)
    data_in = 32'b11111111000000001111111100000000;
    run_test();

    // Test case 3: 16-bit input data with 6 consecutive '0's (expecting bit stuffing)
    data_in = 16'b1000000011111111;
    run_test();

    // Additional test cases can be added here...

    // End simulation
    $finish;
  end

  // Test procedure
  task run_test();
    begin
      // Display input data
      $display("Input Data: %b", data_in);

      // Apply input data to DUT for multiple clock cycles
      repeat (64) begin
        #CLK_PERIOD;
      end

      // Display bit-stuffed output data
      $display("Bit-Stuffed Output Data: %b", data_out);
      $display(""); // Blank line for readability
    end
  endtask
