/*
课程设计要求：基于Verilog的十字路口交通灯控制电路设计
设计并实现一个简单的十字路口交通灯控制电路。

以4个红色指示灯、4个绿色指示灯和4个黄色指示灯模拟路口东西南北4个方向的红绿黄交通灯。控制这些灯，使它们安下列规律亮灭。

1、东西方向绿灯亮，南北方向红灯亮。东西方向通车，时间30秒； 
2、东西方向黄灯闪烁，南北方向红灯亮，时间2秒。 
3、东西方向红灯亮，南北方向绿灯亮。南北方向通车，时间30秒； 
4、东西方向红灯亮，南北方向黄灯闪烁，时间2秒。 
5、返回1，继续运行。
*/

module Traffic_lights (
    input  wire sys_rst,               //时钟信号
    input  wire sys_clk,               //复位信号
    output reg [2:0] North_Lights,     //面北面灯
    output reg [2:0] South_Lights,     //面南面灯
    output reg [2:0] East_Lights,      //面东面灯
    output reg [2:0] West_Lights,      //面西面灯
    input  wire [2:0] light_states);   //红绿灯初始状态输入

    reg  [2:0]  states;                //红绿灯状态
    reg  [31:0] light_Counts;          //计数器计数单位
    reg  [7:0]  light_exist;           //交通灯持续时间
    reg  count_rst;

    parameter        red=3'b001,       //红灯
                  yellow=3'b010,       //黄灯
                   green=3'b100,       //绿灯
                    Idle=3'b000;       //不工作状态

    parameter   model1  =3'b000,       //工作模式1~4
                model2  =3'b001,
                model3  =3'b010,
                model4  =3'b011;
                
    always @(posedge sys_clk or negedge sys_rst)
    begin
        if(!sys_rst) //复位信号为0时赋初值
         begin
            states<=light_states;
            light_Counts<=0;
            light_exist<=0;
            count_rst<=0;
            North_Lights<=0;
            South_Lights<=0;
            East_Lights<=0;
            West_Lights<=0;
         end
        else 
        case (states)
            model1:
                    begin
                      if(light_exist==30) //计数上限为30s
                      begin
                         states<=model2;
                         East_Lights<=Idle;
                         West_Lights<=Idle;
                         light_exist<=0;
                         count_rst<=1;
                      end
                      else 
                       begin
                         East_Lights<=green;
                         West_Lights<=green;
                         North_Lights<=red;
                         South_Lights<=red;
                       end
                    end
            model2:
                    begin
                      if(light_exist==2) 
                      begin
                         states<=model3;
                         light_exist<=0;
                         count_rst<=1;
                      end
                      else 
                       begin
                         East_Lights[1]<=East_Lights[1]^1;//闪烁
                         West_Lights[1]<=West_Lights[1]^1;
                         North_Lights<=red;
                         South_Lights<=red;
                       end
                    end
            model3:
                    begin
                      if(light_exist==30) 
                      begin
                         states<=model4;
                         light_exist<=0;
                         North_Lights<=Idle;
                         South_Lights<=Idle;
                         count_rst<=1;
                      end
                      else 
                       begin
                         East_Lights<=red;
                         West_Lights<=red;
                         North_Lights<=green;
                         South_Lights<=green;
                       end
                    end
            model4: 
                    begin
                      if(light_exist==2) 
                      begin
                         states<=model1;
                         light_exist<=0;
                         count_rst<=1;
                      end
                      else 
                       begin
                         East_Lights<=red;
                         West_Lights<=red;
                         North_Lights[1]<=North_Lights[1]^1;
                         South_Lights[1]<=South_Lights[1]^1;
                       end
                    end  
            default: states<=model1;
        endcase
     end
    
    
    always @(posedge sys_clk or negedge sys_rst) 
    begin
      if(sys_rst) 
         if (!count_rst) 
            begin
               if(light_Counts>=32'd355) //每355 计数一次
                  begin
                  light_exist<=(light_exist+1);
                  light_Counts<=0;
                  end
               else 
                  begin
                  light_exist<=light_exist;
                  light_Counts<=(light_Counts+1);
                  end
            end
         else
            begin
               light_exist<=0;
               count_rst<=0;
            end
            
     end

endmodule //Traffic_lights