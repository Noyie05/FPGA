`timescale 10ms/10ms
module Running_Light_top ();
    
    reg [1:0] sel;
    reg sys_clk;
    reg sys_rst;
    wire [7:0] Y_out;

    initial 
     begin
        sys_clk=0;
        sel=0;
        sys_rst=0;                    //赋初值
        #10 sys_rst=~sys_rst;         //开始工作
     end

     always #1 sys_clk=~sys_clk;     //每10ms为时钟信号取反一次 时钟周期为20ms

     Running_Light Running_Light(   //模块实例化
         .S(sel),
         .clk(sys_clk),
         .rst(sys_rst),
         .Y(Y_out)
     );

endmodule //Running_Light_top