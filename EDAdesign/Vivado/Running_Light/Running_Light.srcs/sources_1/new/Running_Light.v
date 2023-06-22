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
    input   clk,
    input   rst,
    output [7:0] Y
);

    reg [2:0] sel;
    reg [7:0] Y_out;
    reg [31:0] state_count;
    reg [7:0]  state_exist;
    reg count_rst;
    reg model_repeat;
  
    
    parameter 
               model_1=2'b00,
               model_2=2'b01,
               model_3=2'b10,
               model_4=2'b11,
               model_temp1=3'b100,
               model_temp2=3'b101,
               model_temp3=3'b110,
               model_temp4=3'b111;

    parameter Idle =8'b0,
              Special=8'b11110000;

    parameter Count_time=500;

    always @(posedge clk or negedge rst) 
        begin
        if(!rst) begin
            sel<=S;
            Y_out<=Idle;
            state_count<=0;
            state_exist<=0;
            count_rst<=0;
            model_repeat<=0;
        end
        else 
            case (sel)
                model_1:
                    begin
                      case(state_exist)
                        8'd0,8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7:
                        begin
                            Y_out[7-state_exist]<=1;
                        end
                        8'd8,8'd9,8'd10,8'd11,8'd12,8'd13,8'd14:
                        begin
                            Y_out[15-state_exist]<=0;
                        end
                        8'd15:
                        begin
                            Y_out<=8'h00;
                        end
                        8'd16:
                            begin
                                state_exist<=0;
                                count_rst<=1;
                                if(!model_repeat) 
                                    begin
                                        sel<=model_temp1;
                                    end
                                    else 
                                        sel<=model_2;
                            end                      
                        default :state_exist<=0;
                      endcase
                    end 
                model_2:
                    begin
                      case(state_exist)
                        8'd0,8'd1,8'd2,8'd3:
                        begin
                            Y_out[7-state_exist]<=1;
                            Y_out[state_exist]=1;
                        end
                        8'd4,8'd5,8'd6:
                        begin
                            Y_out[11-state_exist]<=0;
                            Y_out[state_exist-4]<=0;
                        end
                        8'd7:
                        begin
                                Y_out[3]=0;
                                Y_out[4]=0;
                        end
                        8'd8:
                            begin
                                count_rst<=1;
                                state_exist<=0;
                                if(!model_repeat) 
                                    begin
                                        sel<=model_temp2;
                                    end
                                    else 
                                        begin
                                            sel<=model_3;
                                            Y_out=Special;
                                        end
                            end
                        default :state_exist<=0;
                      endcase
                    end
                model_3:
                    begin
                        case(state_exist)
                            8'd0:
                            begin
                                Y_out[0]=1;
                            end
                            8'd1,8'd2,8'd3:
                            begin
                                Y_out[state_exist]<=1;
                            end
                            8'd4,8'd5,8'd6,8'd7:
                            begin
                                Y_out[state_exist]<=0;
                            end
                            8'd8:
                            begin
                                Y_out<=Special;
                            end
                            8'd9:
                            begin
                                count_rst<=1;
                                state_exist<=0;
                                if(!model_repeat) 
                                    begin
                                        sel<=model_temp3;
                                    end
                                    else 
                                        begin
                                            sel<=model_4;
                                            Y_out<=~Idle;
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
                            Y_out[7-state_exist]=0;
                        end
                        8'd8,8'd9,8'd10,8'd11,8'd12,8'd13,8'd14:
                        begin
                            Y_out[state_exist-8]=1;
                        end
                        8'd15:
                        begin
                            count_rst<=1;
                            state_exist<=0;
                            if(!model_repeat) 
                                begin
                                    sel<=model_temp4;
                                    Y_out<=~Idle;
                                end
                                else 
                                    begin
                                        sel<=model_1;
                                        Y_out<=Idle;
                                    end
                        end
                        default :state_exist<=0;
                        endcase
                    end
                model_temp1:sel<=model_1;
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

    always @(posedge clk or negedge rst)
        begin
            if(rst) 
                if (!count_rst) 
                    begin
                    if(state_count>=Count_time) 
                        begin
                            state_exist<=(state_exist+1);
                            state_count<=0;
                        end
                    else 
                        begin
                            state_exist<=state_exist;
                            state_count<=(state_count+1);
                        end
                    end
                else
                    begin
                        model_repeat<=(model_repeat+1);
                        state_exist<=0;
                        count_rst<=0;
                    end
        end



    assign Y=Y_out;
    
endmodule //Running_Light