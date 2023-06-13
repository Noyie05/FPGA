`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/06 16:03:18
// Design Name: Noyie05
// Module Name: Trotter
// Project Name: Trotter
// Description: 本人EDA设计课程大作业之一————跑马灯Verilog程序设计
// 
// Dependencies: 
// 
// Revision:0.01
// Revision 0.01 - File Created
// Additional Comments:仅供参考
// 
//////////////////////////////////////////////////////////////////////////////////


module Trotter(
    input [1:0] S,          //等同于课程设计中文档要求的S,clk,rst
    input sys_clk,
    input rst_n,

    output [7:0] L 
    );

    reg repeat_2;
    reg [7:0] repeat_7;
    reg [31:0] count;
    reg [7:0] Y;
    reg [2:0] sel;
    reg [31:0]i;
    
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

    parameter Count_time=100;


    always @(posedge sys_clk or negedge rst_n) 
            if(!rst_n)
             begin
                repeat_2<=0;
                repeat_7<=0;
                count<=0;  
                Y<=Idle; 
                sel<=S;
                i<=0;
             end
            else 
             case(sel)
                 model_1:
                    begin
                        case(repeat_2)
                           0:
                             begin
                                 my_task_model1(count,Y,repeat_7,repeat_2,Count_time,sel,model_temp1);
                             end
                           1:    
                             begin
                                 my_task_model1(count,Y,repeat_7,repeat_2,Count_time,sel,model_2);
                                 repeat_2<=0;
                             end
                        endcase
                    end
                 model_2:
                    begin
                        case(repeat_2)
                           0:
                             begin
                                 my_task_model2(count,Y,repeat_7,repeat_2,Count_time,sel,model_temp2);
                             end
                           1:    
                             begin
                                 my_task_model2(count,Y,repeat_7,repeat_2,Count_time,sel,model_3);
                                 repeat_2<=0;
                             end
                        endcase

                    end
                 model_3:
                    begin
                        case(repeat_2)
                           0:
                             begin
                                 my_task_model3(count,~Special,Y,repeat_7,repeat_2,Count_time,sel,model_temp3);
                             end
                           1:    
                             begin
                                 my_task_model3(count,~Special,Y,repeat_7,repeat_2,Count_time,sel,model_4);
                                 repeat_2<=0;
                             end
                        endcase
                    end
                 model_4:
                    begin
                        case(repeat_2)
                           0:
                             begin
                                 my_task_model4(count,Y,repeat_7,repeat_2,Count_time,sel,model_temp4);
                             end
                           1:    
                             begin
                                 my_task_model4(count,Y,repeat_7,repeat_2,Count_time,sel,model_1);
                                 repeat_2<=0;
                             end
                        endcase

                    end
                     model_temp1:sel<=model_1;
                     model_temp2:sel<=model_2;
                     model_temp3:sel<=model_3;
                     model_temp4:sel<=model_4;
                  default :sel<=model_1;
             endcase

   assign L=Y;
endmodule
