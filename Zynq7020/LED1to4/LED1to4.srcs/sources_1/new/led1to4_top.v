`timescale 1ns/1ns

module led1to4_top ();
    reg sys_clk;
    reg sys_rst;
    wire [3:0] led;

    initial 
        begin
            sys_clk=0;
            sys_rst=0;
            #10 sys_rst=~sys_rst;
        end

    always #1 sys_clk=~sys_clk;

    led1to4 led1to4(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .led(led)
    );

endmodule //led1to4_top