`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 15:13:02
// Design Name: 
// Module Name: tb_traffic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_traffic();
    reg clock;
    wire [2:0] hct, hwt, vct, vwt;

    parameter CLK_PERIOD = 4'd10;

    traffic DUT (.clk(clock), .h_car_traffic(hct), .h_walker_traffic(hwt), .v_car_traffic(vct), .v_walker_traffic(vwt));

    always begin
        clock = 1;
        forever #(CLK_PERIOD/2) clock = ~clock;
    end

    initial begin
        #1600
        $finish;
    end

endmodule
