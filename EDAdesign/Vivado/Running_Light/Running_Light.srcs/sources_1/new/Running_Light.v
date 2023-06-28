/*课程设计一：基于Verilog的跑马灯设计
设计一个能够有多种工作模式控制的8个灯亮灭的电路。 

工作模式1：按照从左到右的方向，依次点亮每一盏灯，然后依次熄灭每一盏灯； 

工作模式2：分成两组灯，前四个灯为1组，后四个为2组，1组灯按从左到右依次点亮，同时2组灯按从右到左依次点亮，然后两组灯按各自点亮的顺序依次熄灭；

工作模式3：用11110000作为一组灯的序列，按照该顺序完成8盏灯亮灭：即首先灯1亮，然后灯2亮，然后灯3亮，然后灯4亮，然后灯5不亮，然后灯6不亮，然后灯7不亮，然后灯8不亮，然后八个灯同时变成亮，亮，亮，亮，不亮，不亮，不亮，不亮，并保持下去。 

工作模式4：自行设计一个模式控制8个灯亮灭。要求和前三个工作模式不同。  

要求每种工作模式重复两次，并在2分钟内完成所有工作模式。  

输入信号： 选择信号[1:0]S, 时钟信号clk, 复位信号reset 输出信号： 跑马灯亮灭信号[7:0]Y

*/
module Running_Light (
    input   [1:0]S,
    input   clk,        //时钟信号
    input   rst,        //复位信号
    output [7:0] Y
);
    //定义寄存器
    reg [2:0] sel;          //比S高一位
    reg [7:0] Y_out;        //输出
    reg [31:0] state_count; 
    reg [7:0]  state_exist; //每个工作模式的状态
    reg count_rst;          //计数器异步复位信号
    reg model_repeat;       //单个模式重复次数计数
  
    //定义parameter
    parameter 
               model_1=2'b00,           //工作模式1~4标识符
               model_2=2'b01,
               model_3=2'b10,
               model_4=2'b11,
               model_temp1=3'b100,      //工作暂态1~4标识符
               model_temp2=3'b101,
               model_temp3=3'b110,
               model_temp4=3'b111;

    parameter Idle =8'b0,               //LED灯不工作状态
              Special=8'b11110000;      //工作模式三特殊状态

    parameter Count_time=500;           //计数器每为state_exist进一位所要计数上限

//工作模式主体程序
    always @(posedge clk or negedge rst)    //上升沿有效和下降沿有效     
        begin
        if(!rst)                //rst=0时清0
          begin      
            sel<=S;             //将初始状态赋给sel
            Y_out<=Idle;        //LED处于不工作状态
            state_count<=0;     
            state_exist<=0;
            count_rst<=0;       
            model_repeat<=0;    
          end
        else 
            case (sel)
                model_1:
                    begin
                      case(state_exist)//状态机下的另外一个状态机 但状态变化由计数器改变
                        8'd0,8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7:
                        begin
                            Y_out[7-state_exist]<=1;            //从左到右，7-0点灯操作
                        end
                        8'd8,8'd9,8'd10,8'd11,8'd12,8'd13,8'd14:
                        begin
                            Y_out[15-state_exist]<=0;           //从左到右，7-1熄灯操作
                        end
                        8'd15:
                        begin
                            Y_out<=8'h00;                       //最右侧灭灯
                        end
                        8'd16://复位参数 以及为工作状态之间提供一个计数器周期间距
                            begin
                                state_exist<=0;                 //状态置0
                                count_rst<=1;                   //让计数器复位
                                if(!model_repeat)               //判断是否再在此工作状态下工作一次
                                    begin
                                        sel<=model_temp1;
                                    end
                                    else 
                                        sel<=model_2;
                                //等效于model_repeat;(sel<=model2):(sel<=model_temp1);
                            end                      
                        default :state_exist<=0;
                      endcase
                    end 
                model_2:
                    begin
                      case(state_exist)//工作模式下只有8个状态  每个工作状态同时处理两次
                        8'd0,8'd1,8'd2,8'd3:
                        begin
                            Y_out[7-state_exist]<=1;    //高四位和低四位灯点灯
                            Y_out[state_exist]=1;
                        end
                        8'd4,8'd5,8'd6:
                        begin
                            Y_out[11-state_exist]<=0;   //高三位灯和低三位灯熄灯
                            Y_out[state_exist-4]<=0;
                        end
                        8'd7:
                        begin
                                Y_out[3]=0;             //第四位和第五位灯熄灯
                                Y_out[4]=0;
                        end
                        8'd8:
                            begin
                                count_rst<=1;           //计数器复位
                                state_exist<=0;         //状态置0
                                if(!model_repeat)       //判断是否再工作一次
                                    begin
                                        sel<=model_temp2;
                                    end
                                    else 
                                        begin
                                            sel<=model_3;
                                            Y_out=Special;  //赋special 即11110000
                                        end
                            end
                        default :state_exist<=0;
                      endcase
                    end
                model_3:
                    begin
                        case(state_exist)        //也只有8个状态
                            8'd0，8'd1,8'd2,8'd3://低四位点灯
                            begin
                                Y_out[state_exist]<=1;
                            end
                            8'd4,8'd5,8'd6,8'd7://高四位熄灯
                            begin
                                Y_out[state_exist]<=0;
                            end
                            8'd8:               //出现赋值
                            begin
                                Y_out<=Special;
                            end
                            8'd9:
                            begin
                                count_rst<=1;   //计数器复位
                                state_exist<=0; //状态置0
                                if(!model_repeat) 
                                    begin
                                        sel<=model_temp3;
                                    end
                                    else 
                                        begin
                                            sel<=model_4;
                                            Y_out<=~Idle;   //状态4led初始状态为11111111
                                        end
                            end
                            default :state_exist<=0;
                        endcase
                    end
                model_4:                                    
                    begin
                        case(state_exist)
                        8'd0,8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7:
                        begin
                            Y_out[7-state_exist]=0;         //从左到右熄灯
                        end
                        8'd8,8'd9,8'd10,8'd11,8'd12,8'd13,8'd14:
                        begin  
                            Y_out[state_exist-8]=1;         //从右到左点灯
                        end
                        8'd15:
                        begin
                            count_rst<=1;                   //计数器复位
                            state_exist<=0;                 //状态赋0
                            if(!model_repeat)               
                                begin
                                    sel<=model_temp4;
                                    Y_out<=~Idle;           //输出再复位
                                end
                                else 
                                    begin
                                        sel<=model_1;
                                        Y_out<=Idle;        //输出赋0
                                    end
                        end
                        default :state_exist<=0;
                        endcase
                    end
                model_temp1:sel<=model_1;//工作暂态变化
                model_temp2:sel<=model_2;
                model_temp3:
                    begin
                        sel<=model_3;
                        Y_out<=Special;
                    end
                model_temp4:sel<=model_4;
                default:sel<=model_1; 
            endcase
        end

    //计数器模块
    always @(posedge clk or negedge rst)
        begin
            if(rst) //复位信号
                if (!count_rst) //计数器复位信号
                    begin
                    if(state_count>=Count_time) //计数到上限为state_exist加1
                        begin
                            state_exist<=(state_exist+1);
                            state_count<=0;
                        end
                    else 
                        begin
                            state_exist<=state_exist;
                            state_count<=(state_count+1);   //计数+1
                        end
                    end
                else
                    begin
                        model_repeat<=(model_repeat+1);
                        state_exist<=0;
                        count_rst<=0;                       //count_rst复位回0
                    end
        end



    assign Y=Y_out;
    
endmodule //Running_Light