`timescale 1ns/1ns

module led_1to4_tb();
    reg sys_clk;
    reg sys_rst;

    wire [3:0] sys_led;

    initial
        begin
            sys_clk=0;
            sys_rst=1;
        end
    
    always #1 sys_clk=~sys_clk;
    always #1000 sys_rst=~sys_rst;

    led_1to4 led_1to4 (
        .clk(sys_clk),
        .rst(sys_rst),
        .led(sys_led)
    );
endmodule
