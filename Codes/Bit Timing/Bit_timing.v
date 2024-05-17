`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: KLE Technological University
// Engineer: Samuel S
// 
// Create Date: 14.05.2024 22:30:18
// Design Name: 
// Module Name: can_bit_timing
// Project Name: 
// Target Devices: AMD ARTRIX-7
// Tool Versions: AMD VIVALDO
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module can_bit_timing #(
  parameter integer F_CPU = 100000000,  //CLK frequency (Hz)
  parameter integer BIT_RATE = 500000     //CAN bus bit rate (bps)
) (
  input clk,
  input rst,
  output reg [15:0] btr,  //Baud Rate Prescaler (BTR[15:10]) and SJW (BTR[9:8])
  output reg [2:0] brp   //Baud Rate Prescaler (BRP[2:0]) for MCP2515
);

integer sjw = 1;  //SJW(Synchronization Jump Width) - adjust(1-4)
integer brp_val;

integer NOMINAL_TQ = F_CPU / BIT_RATE;  // Nominal Time Quantum (in clock cycles)

always @(posedge clk or posedge rst) begin
  if (rst) begin
    btr <= 16'd0;
    end
  else begin
    // Calculate BTR based on desired bit rate and system clock
    NOMINAL_TQ = F_CPU / BIT_RATE;  // Calculate NOMINAL_TQ
    brp_val = NOMINAL_TQ > 0 ? NOMINAL_TQ - 1 : 0;  // Ensure positive BRP_VAL

    // Ensure BRP doesn't exceed limits
    brp_val = (brp_val > (F_CPU / 10000) - 1) ? (F_CPU / 10000) - 1 : brp_val;  // MCP2515 BRP range (1-64)

    // Extract BRP for MCP2515 (3 bits) and configure BTR register
    brp = brp_val[2:0];  // Assign BRP to wire on first positive clock edge after reset
    btr[15:10] = brp_val[7:0];  // BRP value for registers (might not be used for MCP2515)
    btr[9:8] = sjw;             // SJW value for registers
  end
end
endmodule
