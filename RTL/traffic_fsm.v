`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/02/10 19:09:09
// Design Name: 
// Module Name: traffic_fsm
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


module traffic_fsm(

    input wire       clk,
    input wire       reset_n,
    input wire       i_start,
    input wire       i_flag,
    output reg [3:0] o_car_traffic,
    output reg [1:0] o_walker_traffic

    );
    
    parameter [3:0] C_RED       = 4'b1000;
    parameter [3:0] C_YELLOW    = 4'b0100;
    parameter [3:0] C_LEFT      = 4'b0010;
    parameter [3:0] C_GREEN     = 4'b0001;
    parameter [3:0] C_NONE      = 4'b0000;
    parameter [1:0] W_RED       = 2'b10;
    parameter [1:0] W_GREEN     = 2'b01;
    parameter [1:0] W_NONE      = 2'b00;
    
    reg [3:0] c_state;
    reg [3:0] c_next;
    
    reg [1:0] w_state;
    reg [1:0] w_next;
    
    reg r_c_sel;
    reg r_w_sel;
    
    reg [6:0] r_cycle;
    
    always@(*) begin
        case (c_state) 
            C_GREEN     : c_next = C_YELLOW;
            C_YELLOW    : c_next = (r_c_sel ? C_LEFT : C_RED);
            C_LEFT      : c_next = C_YELLOW;
            C_YELLOW    : c_next = C_RED;
            C_RED       : c_next = C_GREEN;
            default     : c_next = C_NONE;
        endcase
    end
    
    always@(*) begin
        case (w_state)
            W_GREEN     : w_next = (r_w_sel ? W_NONE : W_RED);
            W_NONE      : w_next = (r_w_sel ? W_GREEN : W_RED);
            W_RED       : w_next = W_GREEN;
            default     : w_next = W_NONE;
        endcase
    end
            
    always@(posedge clk) begin
        if (!reset_n) begin
            if (i_flag) begin
                r_cycle <= 7'd0;
                c_state <= C_RED;
                r_w_sel <= 1'b0;
                w_state <= W_NONE;
            end
            else begin
                r_cycle <= 7'd34;
                r_c_sel <= 1'b0;
                c_state <= C_YELLOW;
                w_state <= W_RED;
            end
        end
        else begin
            if (i_start) begin
                if (r_cycle == 7'd68) begin
                    r_cycle <= 7'd1;
                end
                else begin
                    r_cycle <= r_cycle + 7'd1;
                end
            end
            else begin
            end
        end
    end
            
    always@(posedge clk) begin
        if (i_start) begin
            if (r_cycle == 7'd0 || r_cycle == 7'd20 || r_cycle == 7'd22 || r_cycle == 7'd32 || r_cycle == 7'd34 || r_cycle == 7'd68) begin
                c_state <= c_next;
                if (r_cycle == 7'd20) begin
                    r_c_sel <= 1'b1;
                end
                else if (r_cycle == 7'd32) begin
                    r_c_sel <= 1'b0;
                end
                else begin
                end
            end
            else begin
            end
        end
        else begin
            o_car_traffic <= C_NONE;
        end
    end
    
    always@(posedge clk) begin
        if (i_start) begin
            if (r_cycle == 7'd0 || r_cycle == 7'd34 || r_cycle == 7'd48 || r_cycle == 7'd49 || r_cycle == 7'd50 || r_cycle == 7'd51 || r_cycle == 7'd52 || r_cycle == 7'd53 || r_cycle == 7'd54) begin
                w_state <= w_next;
                if (r_cycle == 7'd53) begin
                    r_w_sel <= 1'b0;
                end
                else begin
                    r_w_sel <= 1'b1;
                end
            end
            
            else begin
            end
        end
        else begin
            o_walker_traffic <= W_NONE;
        end
    end
    
    always@(*) begin
        o_car_traffic = c_state;
        o_walker_traffic = w_state;
    end
    
endmodule
