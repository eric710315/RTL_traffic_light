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
module top_fsm(
    input wire clk,
    input wire reset_n,
    input wire i_start,
    output wire [3:0] o_e_ct,
    output wire [3:0] o_w_ct,
    output wire [3:0] o_s_ct,
    output wire [3:0] o_n_ct,
    output wire [1:0] o_e_wt,
    output wire [1:0] o_w_wt,
    output wire [1:0] o_s_wt,
    output wire [1:0] o_n_wt
    );
    traffic_fsm U0 (.clk(clk),
                .reset_n(reset_n),
                .i_start(i_start),
                .i_flag(1'b0),
                .o_car_traffic(o_e_ct),
                .o_walker_traffic(o_e_wt));
        
    traffic_fsm U1 (.clk(clk),
                .reset_n(reset_n), 
                .i_start(i_start), 
                .i_flag(1'b1), 
                .o_car_traffic(o_w_ct), 
                .o_walker_traffic(o_w_wt));
        
    traffic_fsm U2 (.clk(clk), 
                .reset_n(reset_n), 
                .i_start(i_start), 
                .i_flag(1'b0), 
                .o_car_traffic(o_s_ct), 
                .o_walker_traffic(o_s_wt));
        
    traffic_fsm U3 (.clk(clk), 
                .reset_n(reset_n), 
                .i_start(i_start), 
                .i_flag(1'b1), 
                .o_car_traffic(o_n_ct), 
                .o_walker_traffic(o_n_wt));
    
endmodule

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
    parameter [3:0] C_NONE      = 4'b0000;
    parameter [1:0] W_RED       = 2'b10;
    parameter [1:0] W_GREEN     = 2'b01;
    parameter [1:0] W_NONE      = 2'b00;
    
    parameter [2:0] SCG = 3'b000;     //cG   
    parameter [2:0] SCY = 3'b001;     //cY    
    parameter [2:0] SCL = 3'b010;     //cL    
    parameter [2:0] SCR = 3'b011;     //cR
    parameter [2:0] SCN = 3'b100;
    parameter [2:0] SWR = 3'b101;
    parameter [2:0] SWG = 3'b110;
    parameter [2:0] SWN = 3'b111;
    
    reg [2:0] c_state;
    reg [2:0] c_next;
    
    reg [2:0] w_state;
    reg [2:0] w_next;
    
    reg r_c_sel;
    reg r_w_sel;
    
    reg [6:0] r_cycle;
    
    always@(*) begin
        case (c_state) 
            SCG     : c_next = SCY;
            SCY     : c_next = (r_c_sel ? SCL : SCR);
            SCL     : c_next = SCY;
            SCR     : c_next = SCG;
            SCN     : c_next = (r_c_sel ? SCG : SCR);
            default : c_next = SCR;
        endcase
        case (w_state)
            SWR     : w_next = SWG;
            SWG     : w_next = (r_w_sel ? SWN : SWR);
            SWN     : w_next = (r_w_sel ? SWG : SWR);
            default : w_next = SWR;
        endcase
    end
            
    always@(posedge clk) begin
        if (!reset_n) begin
            c_state <= SCN;
            w_state <= SWN;
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
                    c_state <= c_next;
                end
                else begin
                    r_cycle <= r_cycle + 7'd1;
                    if (r_cycle == 7'd0 || r_cycle == 7'd34) begin
                        c_state <= c_next;
                        w_state <= w_next;
                        r_w_sel <= 1'b1;
                    end
                    else if (r_cycle == 7'd20 || r_cycle == 7'd22 || r_cycle == 7'd32) begin
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
            end
            else begin
            end
        end
    end
 
    always@(*) begin
        case (c_state)
            SCG : o_car_traffic = C_GREEN;
            SCY : o_car_traffic = C_YELLOW;
            SCL : o_car_traffic = C_LEFT;
            SCR : o_car_traffic = C_RED;
            SCN : o_car_traffic = C_NONE;
            default : o_car_traffic = C_NONE;
        endcase
        case (w_state)
            SWR     : o_walker_traffic = W_RED;
            SWG     : o_walker_traffic = W_GREEN;
            SWN     : o_walker_traffic = W_NONE;
            default : o_walker_traffic = W_NONE;
        endcase
    end
    
endmodule
