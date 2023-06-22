`timescale 10ms / 10ms
module Traffic_lights_top();
    reg sys_rst;
    reg sys_clk;
    wire [2:0] North_Lights;
    wire [2:0] South_Lights;
    wire [2:0] East_Lights;
    wire [2:0] West_Lights;
    reg  [2:0] light_states;

    initial   
        begin
            sys_rst=0;
            sys_clk=0;
            light_states=0;
            #10 sys_rst=~sys_rst;
        end

        always #1 sys_clk=~sys_clk;

        Traffic_lights Traffic_lights
        (
            .sys_rst(sys_rst),
            .sys_clk(sys_clk),
            .North_Lights(North_Lights),
            .South_Lights(South_Lights),
            .East_Lights(East_Lights),
            .West_Lights(West_Lights),
            .light_states(light_states)
        );

endmodule