`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/06 21:59:57
// Design Name: 
// Module Name: Trotter_top
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


module Trotter_top(

    );

    reg sys_clk;
    reg rst_n;
    reg [1:0] sel;

    wire [7:0] Y_out;

    always #1 sys_clk=~sys_clk;
    always #10000000000 rst_n=~rst_n;

    initial
     begin
         sys_clk=0;
         rst_n=1;
         #10 rst_n=rst_n;
     end

     Trotter Trotter(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .S(sel),
        .Y_out(L)
     );
endmodule
