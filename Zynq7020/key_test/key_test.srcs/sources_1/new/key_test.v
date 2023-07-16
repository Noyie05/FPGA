`timescale 1ns/1ns
module key_test (
    input  sys_clk,
    input  [3:0] key,

    output [3:0] led 
);


reg [3:0] led_r;
reg [3:0] led_r1;

always @(posedge sys_clk) 
    begin
        led_r<=key;
    end

always @(posedge sys_clk ) 
    begin
        led_r1<=led_r;
    end

assign led=led_r1;

endmodule //key_test