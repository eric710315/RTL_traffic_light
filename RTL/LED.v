`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/12 14:25:35
// Design Name: 
// Module Name: LED
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


module LED(
    input wire clk,
    input wire reset_n,
    input wire i_start,
    output reg o_led
    );
    
    parameter LED_ON    = 1'b0;
    parameter LED_OFF   = 1'b1;
    
    reg [25:0]  r_cycle;
    reg         sel;
    
    always@(posedge clk) begin
        if (!reset_n) begin
            r_cycle <= 26'd0;
            sel <= 1'b0;
        end
        else begin
            if (i_start) begin
                if (r_cycle == 26'd50000000) begin
                    r_cycle <= 26'd1;
                    sel <= ~sel;
                end
                else begin
                    r_cycle <= r_cycle + 26'd1;
                end
            end
            else begin
            end
        end
    end
   
    always@(posedge clk) begin
        if (!reset_n) begin
            o_led <= LED_OFF;
        end
        else begin
            if (sel) begin
                o_led <= LED_ON;
            end
            else begin
                o_led <= LED_OFF;
            end
        end
    end
    
endmodule
