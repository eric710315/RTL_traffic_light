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
    reg reset = 1'b0;
    reg start = 1'b0;
    reg [1:0] flag = 2'b10;
    wire [3:0] ct1;
    wire [3:0] ct2;
    wire [1:0] wt1;
    wire [1:0] wt2;

    parameter CLK_PERIOD = 4'd10;

    traffic DUT0 (.clk(clock), .reset_n(reset), .i_start(start), .i_flag(flag[0]), .o_car_traffic(ct1), .o_walker_traffic(wt1));
    traffic DUT1 (.clk(clock), .reset_n(reset), .i_start(start), .i_flag(flag[1]), .o_car_traffic(ct2), .o_walker_traffic(wt2));
    
    always begin
        clock = 1'b1;
        forever #(CLK_PERIOD/4'd2) clock = ~clock;
    end

    initial begin
        
        #10
        reset = 1'b1;
        start = 1'b1;
        #700
        reset = 1'b0;
        #10
        reset = 1'b1;
        #720
        $finish;
    end

endmodule
