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
    reg [4:0] i;
    wire [7:0] Y_out;

    
    parameter Idle =8'b11111111,
              Special=8'b11110000;

    always #1 sys_clk=~sys_clk;


    initial
     begin
         sys_clk=0;
         rst_n=0;
         sys_sel<=2'bxx;
         #10 rst_n=~rst_n;
         #20 sys_sel=~sys_sel;
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
            if(task_count >= max_repeat)                //规定上限count
                begin
                  task_rep = (task_rep+1);
                end
            else
                begin
                    task_count = (task_count + 32'd1);
                    task_rep = task_rep;
                    task_counter(task_count,task_rep,1); //上限为1
                 end
     end
endtask

task automatic my_task_model1;
    input [31:0] task_count;
    inout [8:0] task_Y;
    inout repeat_count;
    input [31:0] Max_repeat;
    input  i;
     
    begin
        for ( repeat_count=0; repeat_count==16;repeat_count=(repeat_count+1) ) 
            begin
                // if (repeat_count>=8) 
                // begin
                //     $display("For the Emperor!!!!!!!!!!!!!!!!!");
                //     task_counter(task_count,i,Max_repeat);
                //     task_Y[15-repeat_count]=task_Y[15-repeat_count]^1;
                // end
                // else        
                    // begin
                    task_counter(task_count,i,Max_repeat);
                    task_Y[7-repeat_count]=task_Y[7-repeat_count]^1;
                    // end
            end    
    end
endtask

// task my_task_model2;//前面四个灯为7~4 后面四个灯为3~0
//     inout  task_count;
//     inout [7:0] task_Y;
//     input [3:0] repeat_count;
    
//     begin
//       if(repeat_count==8)
//          begin
//             task_counter(task_count,repeat_count);
//             task_Y[11-repeat_count]=task_Y[11-repeat_count]^1;
//             task_Y[repeat_count-4]=task_Y[repeat_count-4]^1;
//             repeat_count=0;
//          end
//       else if(repeat_count>=4) //当repeat_count==4�? task_Y=8’b00000000
//         begin
//         task_counter(task_count,repeat_count);
//         task_Y[11-repeat_count]=task_Y[11-repeat_count]^1;
//         task_Y[repeat_count-4]=task_Y[repeat_count-4]^1;
//         end
//       else
//         begin
//         task_counter(task_count,repeat_count);
//         task_Y[7-repeat_count]=task_Y[7-repeat_count]^1;
//         task_Y[repeat_count]=task_Y[repeat_count]^1;
//         end
//     end 
// endtask

// task my_task_model3;//前面四个灯为7~4 后面四个灯为3~0
//     inout  task_count;
//     inout [7:0] task_Y;//默认输入�?11110000
//     input [3:0] repeat_count;//默认输入�?0
    
//     begin
//       if(repeat_count==15) 
//        begin
//          task_counter(task_count,repeat_count);
//          task_Y=8'b11110000;
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

// task my_task_model4;//流水�?
//     inout  task_count;
//     inout [7:0] task_Y;//默认输入�?11111111
//     input [3:0] repeat_count;//默认输入�?0
    
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
