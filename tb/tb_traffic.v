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
    reg reset;
    reg start;
//    reg [1:0] flag = 2'b10;
    wire [15:0] ct;
    wire [7:0] wt;
    

    parameter CLK_PERIOD = 4'd10;

    top DUT (.clk(clock), 
             .reset_n(reset), 
             .i_start(start), 
             .o_ct(ct), 
             .o_wt(wt));
    
    always begin
        clock = 1'b1;
        forever #(CLK_PERIOD/4'd2) clock = ~clock;
    end

    initial begin
        #10
        reset = 1'b0;
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
