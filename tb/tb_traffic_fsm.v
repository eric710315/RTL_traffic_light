`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/10 20:07:33
// Design Name: 
// Module Name: tb_traffic_fsm
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


module tb_traffic_fsm();

    reg clk;
    reg rst;
    reg start;
    wire [3:0] o_ct1;
    wire [1:0] o_wt1;
    wire [3:0] o_ct2;
    wire [1:0] o_wt2;
    
    traffic_fsm DUT0 (.clk(clk), .reset_n(rst), .i_start(start), .i_flag(1), .o_car_traffic(o_ct1), .o_walker_traffic(o_wt1));
    traffic_fsm DUT1 (.clk(clk), .reset_n(rst), .i_start(start), .i_flag(0), .o_car_traffic(o_ct2), .o_walker_traffic(o_wt2));
    
    parameter CLK_PERIOD = 4'd10;
    
    always begin
        clk = 1'b1;
        forever #(CLK_PERIOD/4'd2) clk = ~clk;
    end
    
    initial begin
        start = 1'b0;
        rst = 1'b0;
        #10
        rst = 1'b1;
        #10
        start = 1'b1;
        #700
        $finish;
    end
    
endmodule
