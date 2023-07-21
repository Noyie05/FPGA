`timescale 1ns/1ns
`define halfperiod 20

module detector_top();
    reg sys_clk;
    reg sys_rst;
    reg [23:0] data;
    wire z;
    wire x;

    assign x=data[23];

    initial 
    begin
        sys_clk=0;
        sys_rst=1;
        #2 sys_rst=0;
        #30 sys_rst=1;
        data=20'b1100_1001_0000_1001_0100;
        #(`halfperiod*1000)$stop;    
    end

    always #(`halfperiod)  sys_clk=~sys_clk;
    always@(posedge sys_clk)
        #2 data={data[22:0],data[23]};

        detector detector(
            .sys_clk(sys_clk),
            .sys_rst(sys_rst),
            .x(x),
            .z(z)
        );
endmodule