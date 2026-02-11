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
    
    parameter [3:0] C_GREEN     = 4'b0001;
    parameter [3:0] C_YELLOW    = 4'b0100;
    parameter [3:0] C_LEFT      = 4'b0010;
    parameter [3:0] C_RED       = 4'b1000;
//    parameter [3:0] C_NONE      = 4'b0000;
    parameter [1:0] W_RED       = 2'b10;
    parameter [1:0] W_GREEN     = 2'b01;
    parameter [1:0] W_NONE      = 2'b00;
    
    parameter [1:0] S0 = 2'b00;     //cG    wR 
    parameter [1:0] S1 = 2'b01;     //cY    wG
    parameter [1:0] S2 = 2'b10;     //cL    wN
    parameter [1:0] S3 = 2'b11;     //cR
    
    reg [1:0] c_state;
    reg [1:0] c_next;
    
    reg [1:0] w_state;
    reg [1:0] w_next;
    
    reg r_c_sel;
    reg r_w_sel;
    
    reg [6:0] r_cycle;
    
    always@(*) begin
        case (c_state) 
            S0      : c_next = S1;
            S1      : c_next = (r_c_sel ? S2 : S0);
            S2      : c_next = S1;
            S3      : c_next = S0;
        endcase
    end
    
    always@(*) begin
        case (w_state)
            S0      : w_next = S1;
            S1      : w_next = (r_w_sel ? S2 : S0);
            S2      : w_next = (r_w_sel ? S1 : S0);
            default : w_next = S2;
        endcase
    end
            
    always@(posedge clk) begin
        if (!reset_n) begin
            if (i_flag) begin
                r_cycle <= 7'd0;
                r_c_sel <= 1'b1;
                r_w_sel <= 1'b0;
            end
            else begin
                r_cycle <= 7'd34;
                r_c_sel <= 1'b0;
                r_w_sel <= 1'b1;
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
            if (r_cycle == 7'd0) begin
                c_state <= S0;
            end
            else if (r_cycle == 7'd34) begin
                c_state <= S3;
            end
            else if (r_cycle == 7'd20 || r_cycle == 7'd22 || r_cycle == 7'd32 || r_cycle == 7'd68) begin
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
        end
    end
    
    always@(posedge clk) begin
        if (i_start) begin
            if (r_cycle == 7'd0) begin
                w_state <= S0;
            end
            else if (r_cycle == 7'd34) begin
                w_state <= S1;
            end
            else if (r_cycle == 7'd48 || r_cycle == 7'd49 || r_cycle == 7'd50 || r_cycle == 7'd51 || r_cycle == 7'd52 || r_cycle == 7'd53 || r_cycle == 7'd54) begin
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
        end
    end
    
    always@(*) begin
        case (c_state)
            S0 : o_car_traffic = C_GREEN;
            S1 : o_car_traffic = C_YELLOW;
            S2 : o_car_traffic = C_LEFT;
            S3 : o_car_traffic = C_RED;
        endcase
    end
    always@(*) begin
        case (w_state)
            S0      : o_walker_traffic = W_RED;
            S1      : o_walker_traffic = W_GREEN;
            S2      : o_walker_traffic = W_NONE;
            default : o_walker_traffic = W_NONE;
        endcase
    end
    
endmodule
