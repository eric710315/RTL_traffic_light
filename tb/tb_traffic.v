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
    wire [3:0] e_ct;
    wire [3:0] w_ct;
    wire [3:0] s_ct;
    wire [3:0] n_ct;
    wire [1:0] e_wt;
    wire [1:0] w_wt;
    wire [1:0] s_wt;
    wire [1:0] n_wt;
    

    parameter CLK_PERIOD = 4'd10;

    top DUT (.clk(clock), 
             .reset_n(reset), 
             .i_start(start), 
             .o_e_ct(e_ct), 
             .o_w_ct(w_ct),
             .o_s_ct(s_ct),
             .o_n_ct(n_ct),
             .o_e_wt(e_wt),
             .o_w_wt(w_wt),
             .o_s_wt(s_wt),
             .o_n_wt(n_wt));
    
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
