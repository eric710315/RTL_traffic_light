`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/06 13:25:01
// Design Name: 
// Module Name: traffic
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


module traffic(
    input wire clk, 
    input wire reset_n,
    input wire i_start,
    input wire i_flag,
    output reg [3:0] o_car_traffic, 
    output reg [1:0] o_walker_traffic,
    output reg o_flag
    );
    
    parameter [3:0] C_RED = 4'b1000;
    parameter [3:0] C_YELLOW = 4'b0100;
    parameter [3:0] C_LEFT = 4'b0010;
    parameter [3:0] C_GREEN = 4'b0001;
    parameter [3:0] C_NONE = 4'b0000;
    parameter [1:0] W_RED = 2'b10;
    parameter [1:0] W_GREEN = 2'b01;
    parameter [1:0] W_NONE = 2'b00;
    
    
    reg [6:0] r_cycle;
    
    always@(*) begin
        o_flag = ~i_flag;
    end
    
    always@(posedge clk) begin
        if (!reset_n) begin
            r_cycle <= 7'd0;
            o_flag <= 1'b0;
        end
        else begin
            if (i_start) begin
                if (r_cycle == 7'd34) begin
                    r_cycle <= 7'd1;
                    o_flag <= ~o_flag;
                end
                else begin 
                    r_cycle <= r_cycle + 7'd1;
                end
            end
            else begin
                r_cycle <= 7'd0;
            end
        end
    end
    
    always@(*) begin
        if (i_start) begin
            if (i_flag) begin
                if (r_cycle <= 7'd20) begin 
                    o_car_traffic = C_GREEN;
                end
                else if (r_cycle <= 7'd22) begin 
                    o_car_traffic = C_YELLOW;
                end
                else if (r_cycle <= 7'd32) begin 
                    o_car_traffic = C_LEFT;
                end
                else if (r_cycle <= 7'd34) begin 
                    o_car_traffic = C_YELLOW;
                end
                else begin 
                    o_car_traffic = C_NONE;
                end
             end
             else begin
                o_car_traffic = C_RED;
             end
         end
         
         else begin
            o_car_traffic = C_NONE;
         end
         
     end
    
    always@(*) begin
        if (i_start) begin
            if (i_flag) begin            
                o_walker_traffic = W_RED;
            end
            else begin
                if (r_cycle <= 7'd14) begin
                    o_walker_traffic = W_GREEN;
                end
                else if (r_cycle <= 7'd20) begin
                    if (r_cycle[0] == 1'b0) begin
                        o_walker_traffic = W_GREEN;
                    end
                    else begin
                        o_walker_traffic = W_NONE;
                    end
                end
                else begin
                    o_walker_traffic = W_RED;
                end
            end
        end
        else begin
            o_walker_traffic = W_NONE;
        end
    end
    
endmodule
