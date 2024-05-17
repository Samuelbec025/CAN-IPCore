`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: KLE Technological University
// Engineer: Samuel S
// 
// Create Date: 28.04.2024 19:59:56
// Design Name: Bitstuffing
// Module Name: can_bit_stuffing
// Project Name: CAN DATA BIT-STUFFING
// Target Devices: AMD ARTRIX-7
// Tool Versions: AMD VIVALDO 
// Description: 
//
// Dependencies: 
// 
// Revision: 1.2
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module can_bit_stuffing (
  input [63:0] data_in,     
  input clk,
  output reg [63:0] data_out 
);

  // Internal variables
  reg [63:0] stuffed_data;   // Stuffed output data 
  integer count_ones = 0;    // Counter for consecutive 1s
  integer count_zeros = 0;   // Counter for consecutive 0s
  integer i;                 // Loop index

  always @(posedge clk) begin
    // Initialize stuffed data with input data
    stuffed_data <= data_in;

    // Bit stuffing from MSB to LSB
    for (i = 63; i >= 0; i = i - 1) begin
      if (stuffed_data[i] == 1'b1) begin
        count_ones = count_ones + 1;
        count_zeros = 0;
      end else begin
        count_zeros = count_zeros + 1;
        count_ones = 0;
      end

      // Check for 6 consecutive 1s or 0s   
      if (count_ones >= 6) begin
        // Insert opposite bit after 5th consecutive 1
        stuffed_data[i] = ~stuffed_data[i];
        count_ones = 0;
        // Shift subsequent bits
        if (i + 1 < 64) begin
          stuffed_data[i + 1] = stuffed_data[i];
        end
      end else if (count_zeros >= 6) begin
        // Insert opposite bit after 5th consecutive 0
        stuffed_data[i] = ~stuffed_data[i];
        count_zeros = 0;
        // Shift subsequent bits
        if (i + 1 < 64) begin
          stuffed_data[i + 1] = stuffed_data[i];
        end
      end
    end

    // Assign stuffed data to output
    data_out <= stuffed_data;
  end

endmodule
