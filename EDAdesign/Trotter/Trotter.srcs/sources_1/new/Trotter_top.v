`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/06 21:59:57
// Design Name: 
// Module Name: Trotter_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Trotter_top(

    );

    reg sys_clk;
    reg rst_n;
    reg [1:0] sys_sel;
    wire [7:0] Y_out;

    
    parameter Idle =8'b11111111,
              Special=8'b11110000;

    always #1 sys_clk=~sys_clk;


    initial
     begin
         sys_clk=0;
         rst_n=0;
         sys_sel<=2'b00;
         #10 rst_n=~rst_n;
     end

     Trotter Trotter(
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .S(sys_sel),
        .L(Y_out)
     );
    
    
task automatic task_counter;
    input  [31:0] task_count;
    inout  [31:0] task_rep;
    input  [31:0] max_repeat;
      begin
         #max_repeat task_rep=(task_rep+1);
              // if(task_count >= max_repeat)                //规定上限count
              //     begin
              //       task_rep = (task_rep+1);
              //     end
              // else
              //     begin
              //         task_count = (task_count + 32'd1);
              //         task_counter(task_count,task_rep,100); //上限�?1
              //     end
      end
endtask

task automatic my_task_model1;
    input [31:0] task_count;
    inout [8:0] task_Y;
    inout [31:0]repeat_count;
    inout repeat_2;
    input [31:0] Max_repeat;
    inout  [2:0]out_state;
    input  [2:0]in_state; 
     
    begin

        case(repeat_count)
        8'd0,8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7:
          begin
            task_counter(task_count,repeat_count,Max_repeat);
            task_Y[8-repeat_count]=task_Y[8-repeat_count]^1;
          end
        8'd8,8'd9,8'd10,8'd11,8'd12,8'd13,8'd14:
          begin
            task_Y[15-repeat_count]=task_Y[15-repeat_count]^1;
            task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd15:
          begin
              task_counter(task_count,repeat_count,Max_repeat);
              task_Y=8'h00;
              // out_state=in_state;
              // task_counter(task_count,repeat_2,Max_repeat);
          end
        default :
            begin
              out_state=in_state;
              @(posedge sys_clk);
              repeat_2=~repeat_2;
              repeat_count=0;
            end
        endcase
    end
endtask

task automatic my_task_model2;//前面四个灯为7~4 后面四个灯为3~0
     input [31:0] task_count;
    inout [8:0] task_Y;
    inout [31:0]repeat_count;
    inout repeat_2;
    input [31:0] Max_repeat;
    inout [2:0]out_state;
    input [2:0] in_state; 
    
    begin
      case(repeat_count)
        8'd0,8'd1,8'd2,8'd3:
          begin
            task_Y[7-repeat_count]=task_Y[7-repeat_count]^1;
            task_Y[repeat_count]=task_Y[repeat_count]^1;
            task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd4,8'd5,8'd6:
          begin
            task_Y[11-repeat_count]=task_Y[11-repeat_count]^1;
            task_Y[repeat_count-4]=task_Y[repeat_count-4]^1;
            task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd7:
          begin
              task_counter(task_count,repeat_count,2*Max_repeat);
              task_Y=8'h00;
              task_Y[3]=task_Y[3];
              task_Y[4]=task_Y[4];
          end
        default:
          begin

              out_state=in_state;
              @(posedge sys_clk);
              repeat_2=~repeat_2;
              repeat_count=0;
          end
        endcase
    end 
endtask

task automatic my_task_model3;//前面四个灯为7~4 后面四个灯为3~0
    inout [31:0]task_count;
    inout [8:0] task_Y;//默认输入�??11110000
    inout [31:0] repeat_count;//默认输入�??0
    inout repeat_2;
    input [31:0] Max_repeat;
    inout   [2:0]out_state;
    input  [2:0]in_state; 

    begin
        case(repeat_count)
        8'd0:
          begin
              task_counter(task_count,repeat_count,Max_repeat);
              repeat_count=repeat_count-1;
              task_Y=8'h0F;
              task_Y[7]=~task_Y[7];
              task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7:
          begin
            task_Y[7-repeat_count]=~task_Y[7-repeat_count];
            task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd8,8'd9,8'd10,8'd11,8'd12,8'd13,8'd14:
          begin
             task_Y[15-repeat_count]=~task_Y[15-repeat_count];
            task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd15:
          begin
              task_counter(task_count,repeat_count,Max_repeat);
              task_Y=0;
          end
        default :
          begin
              task_Y=0;
              out_state=in_state;
              @(posedge sys_clk);
              repeat_2=~repeat_2;
              repeat_count=0;
            end
        endcase
    end
endtask

task  automatic my_task_model4;//流水�??
    inout [31:0]task_count;
    inout [8:0] task_Y;//默认输入�??11111111
    inout [31:0] repeat_count;//默认输入�??0
    inout repeat_2;
    input [31:0] Max_repeat;
    inout   [2:0]out_state;
    input  [2:0]in_state; 
    
    begin
        case(repeat_count)
          8'd0:
          begin
              task_counter(task_count,repeat_count,Max_repeat);
              repeat_count=repeat_count-1;
              task_Y=8'h00;
              task_Y[7]=~task_Y[7];
              task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd1,8'd2,8'd3,8'd4,8'd5,8'd6,8'd7:
          begin
            task_Y[7-repeat_count]=task_Y[7-repeat_count]^1;
            task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd8,8'd9,8'd10,8'd11,8'd12,8'd13,8'd14:
          begin
             task_Y[15-repeat_count]=task_Y[15-repeat_count]^1;
            task_counter(task_count,repeat_count,Max_repeat);
          end
        8'd15:
          begin
              task_counter(task_count,repeat_count,Max_repeat);
              task_Y=0;
          end
        default :
          begin
              out_state=in_state;
              @(posedge sys_clk);
              repeat_2=~repeat_2;
              repeat_count=0;
            end
        endcase
    end
endtask
//     begin
//       task_Y=Idle;
//       if(repeat_count==15) 
//        begin
//          task_counter(task_count,repeat_count);
//          task_Y=Idle;
//         end
//       else if(repeat_count>7) 
//          begin
//           task_counter(task_count,repeat_count);
//           task_Y[15-repeat_count]=task_Y[15-repeat_count]^1;
//          end
//       else  
//          begin
//           task_counter(task_count,repeat_count);
//           task_Y[7-repeat_count]=task_Y[7-repeat_count]^1;
//          end
//     end 
// endtask
endmodule
