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
    input clk, reset_n,
    output reg [2:0] o_h_car_traffic, o_h_walker_traffic, o_v_car_traffic, o_v_walker_traffic
    );
    
    parameter [2:0] RED = 3'b000;
    parameter [2:0] GREEN = 3'b001;
    parameter [2:0] YELLOW = 3'b010;
    parameter [2:0] LEFT = 3'b011;
    parameter [2:0] GREEN_TWINKLE = 3'b100;
    
    reg [6:0] r_cycle = 7'd0;
    
    always@(posedge clk) begin
        if (r_cycle == 68 || reset_n == 0) r_cycle <= 1;
        else r_cycle <= r_cycle + 1;
    end
    //첫 번째 주기에서 cycle은 초기 값을 가지고 이미 계산을 함. 첫 번째 주기의 cycle은 1이 됨.
    //68 번째 주기 다음 주기에서 cycle은 1이 됨. 그러나 reg에는 68번째 주기의 값들이 들어감.
    //reset도 마찬가지로 reset=0인 주기에서  cycle은 1이 되지만, reg는 이전의 cycle 값으로 판단한다. 
    
    always@(*) begin
        if (r_cycle <= 20) begin 
            o_h_car_traffic = GREEN;
        end
        else if (r_cycle <= 22) begin 
            o_h_car_traffic = YELLOW;
        end
        else if (r_cycle <= 32) begin 
            o_h_car_traffic = LEFT;
        end
        else if (r_cycle <= 34) begin 
            o_h_car_traffic = YELLOW;
        end
        else begin 
            o_h_car_traffic = RED;
        end
     end
    
    always@(*) begin
        if (r_cycle <= 34) begin
            o_v_car_traffic = RED;
        end
        else if (r_cycle <= 54) begin
            o_v_car_traffic = GREEN;
        end
        else if (r_cycle <= 56) begin
            o_v_car_traffic = YELLOW;
        end
        else if (r_cycle <= 66) begin
            o_v_car_traffic = LEFT;
        end
        else if (r_cycle <= 68) begin
            o_v_car_traffic = YELLOW;
        end
        else begin
            o_v_car_traffic = RED;
        end
    end
    
    always@(*) begin
        if (r_cycle <= 34) begin
            o_h_walker_traffic = RED;
        end
        else if (r_cycle <= 48) begin
            o_h_walker_traffic = GREEN;
        end
        else if (r_cycle <= 54) begin
            o_h_walker_traffic = GREEN_TWINKLE;
        end
        else begin
            o_h_walker_traffic = RED;
        end
    end
    
    always@(*) begin
        if (r_cycle <= 14) begin
            o_v_walker_traffic = GREEN;
        end
        else if (r_cycle <= 20) begin
            o_v_walker_traffic = GREEN_TWINKLE;
        end
        else begin
            o_v_walker_traffic = RED;
        end
    end
    
endmodule
