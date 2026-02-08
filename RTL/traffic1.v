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
    input clk,
    output reg [2:0] h_car_traffic, h_walker_traffic, v_car_traffic, v_walker_traffic
    );
    
    parameter [2:0] RED = 3'b000;
    parameter [2:0] GREEN = 3'b001;
    parameter [2:0] YELLOW = 3'b010;
    parameter [2:0] LEFT = 3'b011;
    parameter [2:0] GREEN_TWINKLE = 3'b100;
    
    reg [6:0] cycle = 7'd0;
    
    always@(posedge clk) begin
        cycle <= cycle + 1;
        if (cycle == 68) cycle <= 1;
    end
    //첫 번째 주기에서 cycle은 초기 값을 가지고 이미 계산을 함. 첫 번째 주기의 cycle은 1이 됨.
    
    
    always@(posedge clk) begin
        if (cycle < 20) h_car_traffic = GREEN;
        else if (cycle < 22) h_car_traffic = YELLOW;
        else if (cycle < 32) h_car_traffic = LEFT;
        else if (cycle < 34) h_car_traffic = YELLOW;
        else h_car_traffic = RED;
    end    
    
    always@(posedge clk) begin
        if (cycle < 34) v_car_traffic = RED;
        else if (cycle < 54) v_car_traffic = GREEN;
        else if (cycle < 56) v_car_traffic = YELLOW;
        else if (cycle < 66) v_car_traffic = LEFT;
        else if (cycle < 68) v_car_traffic = YELLOW;
        else v_car_traffic = RED;
    end
    
    always@(posedge clk) begin
        if (cycle < 34) h_walker_traffic = RED;
        else if (cycle < 48) h_walker_traffic = GREEN;
        else if (cycle < 54) h_walker_traffic = GREEN_TWINKLE;
        else h_walker_traffic = RED;
    end
    
    always@(posedge clk) begin
        if (cycle < 14) v_walker_traffic =  GREEN;
        else if (cycle < 20) v_walker_traffic = GREEN_TWINKLE;
        else v_walker_traffic = RED;
    end
    
endmodule
