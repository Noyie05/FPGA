`timescale 1ns / 1ps
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
    reg [1:0] sel;
    reg repeat_2;
    reg [7:0] repeat_7;
    reg [31:0] count;
    reg [7:0] Y;

    parameter model_1=2'b00,
              model_2=2'b01,
              model_3=2'b10,
              model_4=2'b11;

    parameter Idle =8'b11111111,
              Special=8'b11110000;

    always @(posedge sys_clk) 
        begin
            if(!rst_n)
             begin
                sel<=S;
                repeat_2<=0;
                repeat_7<=0;  
                Y<=Idle; 
             end
            else 
             case(sel)
                 model_1:
                    begin
                        if(repeat_2==1)
                         begin
                            task_counter(count,repeat_2);  
                            my_task_model1(count,Y,repeat_7);
                            repeat_2<=0;
                            sel<=model_2;
                            Y<=Idle;
                         end
                        else
                         begin
                            task_counter(count,repeat_2);
                            my_task_model1(count,Y,repeat_7);
                         end
                    end
                 model_2:
                    begin
                        if(repeat_2==1)
                         begin
                            task_counter(count,repeat_2);    
                            my_task_model2(count,Y,repeat_7);
                            repeat_2<=0;
                            sel<=model_3;
                            Y<=Special;
                         end
                        else
                         begin
                            task_counter(count,repeat_2);
                            my_task_model2(count,Y,repeat_7);
                         end
                    end
                 model_3:
                    begin
                        if(repeat_2==1)
                         begin
                            Y<=Special;
                            task_counter(count,repeat_2);
                            my_task_model3(count,Y,repeat_7); 
                            repeat_2<=0;   
                            sel<=model_4;
                         end
                        else
                         begin
                            task_counter(count,repeat_2);
                            my_task_model3(count,Y,repeat_7);
                         end
                    end
                 model_4:
                    begin
                        if(repeat_2==1)
                         begin
                            task_counter(count,repeat_2);    
                            my_task_model4(count,Y,repeat_7);
                            sel<=model_1;
                         end
                        else
                         begin
                            task_counter(count,repeat_2);
                            my_task_model3(count,Y,repeat_7);

                         end
                    end
             endcase
        end

assign L=Y;

task task_counter;
    inout  task_count;
    inout  task_rep;
     begin
            if(task_count >= 32'd1_000_000_000)
                begin
                 task_rep <= task_rep+1;
                 task_count <= 32'd0;
                end
            else
                begin
                 task_rep <= task_rep;
                 task_count <= task_count + 32'd1;
                 end
     end
endtask

task my_task_model1;
    inout  task_count;
    inout [7:0] task_Y;
    inout [3:0] repeat_count;
    
    begin
      if(repeat_count==15)
        begin
            task_counter(task_count,repeat_count);
            task_Y[15-repeat_count]<=task_Y[15-repeat_count]^1;   
            repeat_count<=0;
            task_Y<=Idle;

        end
      else if(repeat_count>=8) //当repeat_count==8时 task_Y=8’b00000000
        begin
        task_counter(task_count,repeat_count);
        task_Y[15-repeat_count]<=task_Y[15-repeat_count]^1;
        end
      else
        begin
        task_counter(task_count,repeat_count);
        task_Y[7-repeat_count]<=task_Y[7-repeat_count]^1;
        end
    end 
endtask

task my_task_model2;//前面四个灯为7~4 后面四个灯为3~0
    inout  task_count;
    inout [7:0] task_Y;
    input [3:0] repeat_count;
    
    begin
      if(repeat_count==8)
         begin
            task_counter(task_count,repeat_count);
            task_Y[11-repeat_count]<=task_Y[11-repeat_count]^1;
            task_Y[repeat_count-4]<=task_Y[repeat_count-4]^1;
            repeat_count<=0;
         end
      else if(repeat_count>=4) //当repeat_count==4时 task_Y=8’b00000000
        begin
        task_counter(task_count,repeat_count);
        task_Y[11-repeat_count]<=task_Y[11-repeat_count]^1;
        task_Y[repeat_count-4]<=task_Y[repeat_count-4]^1;
        end
      else
        begin
        task_counter(task_count,repeat_count);
        task_Y[7-repeat_count]<=task_Y[7-repeat_count]^1;
        task_Y[repeat_count]<=task_Y[repeat_count]^1;
        end
    end 
endtask

task my_task_model3;//前面四个灯为7~4 后面四个灯为3~0
    inout  task_count;
    inout [7:0] task_Y;//默认输入是11110000
    input [3:0] repeat_count;//默认输入是0
    
    begin
      if(repeat_count==15) 
       begin
         task_counter(task_count,repeat_count);
         task_Y<=8'b11110000;
        end
      else if(repeat_count>7) 
         begin
          task_counter(task_count,repeat_count);
          task_Y[15-repeat_count]<=task_Y[15-repeat_count]^1;
         end
      else  
         begin
          task_counter(task_count,repeat_count);
          task_Y[7-repeat_count]<=task_Y[7-repeat_count]^1;
         end
    end 
endtask

task my_task_model4;//流水灯
    inout  task_count;
    inout [7:0] task_Y;//默认输入是11111111
    input [3:0] repeat_count;//默认输入是0
    
    begin
      task_Y<=Idle;
      if(repeat_count==15) 
       begin
         task_counter(task_count,repeat_count);
         task_Y<=Idle;
        end
      else if(repeat_count>7) 
         begin
          task_counter(task_count,repeat_count);
          task_Y[15-repeat_count]<=task_Y[15-repeat_count]^1;
         end
      else  
         begin
          task_counter(task_count,repeat_count);
          task_Y[7-repeat_count]<=task_Y[7-repeat_count]^1;
         end
    end 
endtask

endmodule
