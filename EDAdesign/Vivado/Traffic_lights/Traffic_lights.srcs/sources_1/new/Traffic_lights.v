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
    input  wire sys_rst,
    input  wire sys_clk,
    output reg [2:0] North_Lights,
    output reg [2:0] South_Lights,
    output reg [2:0] East_Lights,
    output reg [2:0] West_Lights,
    input  wire [2:0] light_states);

    reg  [2:0]  states;
    reg  [31:0] light_Counts;
    reg  [7:0]  light_exist;

    parameter        red=3'b001,
                  yellow=3'b010,
                   green=3'b100,
                    Idle=3'b000; 

    parameter   model1  =3'b000,
                model2  =3'b001,
                model3  =3'b010,
                model4  =3'b011;
                
    always @(posedge sys_clk or negedge sys_rst)
    begin
        if(!sys_rst)
         begin
            states<=light_states;
            light_Counts<=0;
            light_exist<=0;
            North_Lights<=0;
            South_Lights<=0;
            East_Lights<=0;
            West_Lights<=0;
         end
        else 
        case (states)
            model1:
                    begin
                      if(light_exist==30) 
                      begin
                         states<=model2;
                         light_exist<=0;
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
                      if(light_exist==30) 
                      begin
                         states<=model4;
                         light_exist<=0;
                      end
                      else 
                       begin
                         East_Lights<=yellow;
                         West_Lights<=yellow;
                         North_Lights<=red;
                         South_Lights<=red;
                       end
                    end
            model3:
                    begin
                      if(light_exist==30) 
                      begin
                         states<=model3;
                         light_exist<=0;
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
                      end
                      else 
                       begin
                         East_Lights<=red;
                         West_Lights<=red;
                         North_Lights<=yellow;
                         South_Lights<=yellow;
                       end
                    end  
            default: states<=model1;
        endcase
     end
    
    
    always @(*) 
    if(sys_rst) 
    begin
        if(light_Counts>=32'd100) 
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

endmodule //Traffic_lights