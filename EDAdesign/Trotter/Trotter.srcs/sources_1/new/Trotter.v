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
    reg[1:0] sel;
    
    parameter 
              model_1=2'b00,
              model_2=2'b01,
              model_3=2'b10,
              model_4=2'b11;
              
    parameter Idle =8'b11111111,
              Special=8'b11110000;


    always @(posedge sys_clk or negedge rst_n) 
            if(!rst_n)
             begin
                repeat_2<=0;
                repeat_7<=0;
                count<=0;  
                Y<=Idle; 
                sel<=S;
             end
            else 
             case(sel)
                 model_1:
                    begin
                        // if(repeat_2==1)
                        //  begin
                        //     task_counter(count,repeat_2,32'd10);  
                        //     my_task_model1(count,Y,repeat_7,10);
                        //     repeat_2<=0;
                        //     sel<=model_2;
                        //     Y<=Idle;
                        //  end
                        // else
                        //  begin
                            task_counter(count,repeat_2,10);
                            my_task_model1(count,Y,repeat_7,10);
                        //  end
                    end
               //   model_2:
               //      begin
               //          if(repeat_2==1)
               //           begin
               //              task_counter(count,repeat_2);    
               //              my_task_model2(count,Y,repeat_7);
               //              repeat_2<=0;
               //              sel<=model_3;
               //              Y<=Special;
               //           end
               //          else
               //           begin
               //              task_counter(count,repeat_2);
               //              my_task_model2(count,Y,repeat_7);
               //           end
               //      end
               //   model_3:
               //      begin
               //          if(repeat_2==1)
               //           begin
               //              Y<=Special;
               //              task_counter(count,repeat_2);
               //              my_task_model3(count,Y,repeat_7); 
               //              repeat_2<=0;   
               //              sel<=model_4;
               //           end
               //          else
               //           begin
               //              task_counter(count,repeat_2);
               //              my_task_model3(count,Y,repeat_7);
               //           end
               //      end
               //   model_4:
               //      begin
               //          if(repeat_2==1)
               //           begin
               //              task_counter(count,repeat_2);    
               //              my_task_model4(count,Y,repeat_7);
               //              sel<=model_1;
               //           end
               //          else
               //           begin
               //              task_counter(count,repeat_2);
               //              my_task_model3(count,Y,repeat_7);

               //           end
               //      end
                  default :sel<=model_1;
             endcase

   assign L=Y;
endmodule
