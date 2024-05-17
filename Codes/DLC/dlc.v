`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: KLE Technological University
// Engineer: Samuel S
// 
// Create Date: 29.04.2024 10:15:43
// Design Name: Data Length Code
// Module Name: dlc
// Project Name: CAN_datalength
// Target Devices: AMD Artirx-7
// Tool Versions: AMD Vivaldo ML Edition
// Description: 
// 
// Dependencies: 
// 
// Revision: 1.02
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dlc (
    input [63:0] data,   
    output reg [3:0] dlc 
);

reg [7:0] non_zero_count; 
integer i;

always @* begin
    // Initialize non_zero_count
    non_zero_count = 0;
    
    
    // Loop through each byte of the 64-bit data from MSB to LSB
    for (i = 7; i >= 0; i = i - 1) begin
        if (data[(i*8) +: 8] !== 8'h00) begin
            non_zero_count = i + 1; 
        end
    end
    
    case (non_zero_count)
        0: dlc = 4'b0000; 
        1: dlc = 4'b0001; 
        2: dlc = 4'b0010; 
        3: dlc = 4'b0011; 
        4: dlc = 4'b0100; 
        5: dlc = 4'b0101; 
        6: dlc = 4'b0110; 
        7: dlc = 4'b0111; 
        8: dlc = 4'b1000; 
        default: dlc = 4'b1000; 
    endcase
end

endmodule
