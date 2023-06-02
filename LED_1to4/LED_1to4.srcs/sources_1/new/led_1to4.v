module led_1to4(
    input  clk,
    input  rst,


    output reg [3:0] led
    );
    
    reg [31:0] led_cout;
    reg [6:0]  state;

    parameter   
            Idle =7'b1000000,
            led1 =7'b0100000,
            led2 =7'b0010000,
            led3 =7'b0001000,
            led4 =7'b0000100,
            stop =7'b0000010,
            clear=7'b0000001;

    parameter  
           led1_l=4'b1000,    
           led2_l=4'b0100,
           led3_l=4'b0010,
           led4_l=4'b0001,
           led_stop=4'b1111,
           led_d =4'b0000;
    
    always @(posedge clk or negedge rst) 
       begin
        if (!rst) 
            begin
                state <=Idle;
                led   <=led_d;
            end
        case (state)
            Idle: 
            begin  
                state<=led1;
                led<=led_d;
                led_cout<=32'b0;
            end
            led1:  
            begin   
                counter(led,led1_l,led_cout);
                state<=led2;
            end
            led2:
            begin    
                counter(led,led2_l,led_cout);
                state<=led3;
            end   
            led3:
                begin
                    counter(led,led3_l,led_cout);
                    state<=led4;
                end
            led4:
                begin
                    counter(led,led4_l,led_cout);
                    state<=stop;
                end
            stop:
                begin
                    counter(led,led_stop,led_cout);
                    state<=clear;
                end
            clear:
                begin
                    counter(led,clear,led_cout);
                    state<=Idle;
                end
            default: state<=Idle;
                
            /*begin
                if(led_cout >= 32'd49_999_999)
                begin
                 led <= led1_l;
                 led_cout <= 32'd0;
                end
            else
                begin
                 led <= led;
                 led_cout <= led_cout + 32'd1;
                 end
            end
            */
        endcase
        end
task counter;
    inout led_task;
    input led_state;
    inout led_task_cout;
    begin
                if(led_task_cout >= 32'd49_999_999)
                begin
                 led_task <= led_state;
                 led_task_cout <= 32'd0;
                end
            else
                begin
                 led_task <= led_task;
                 led_task_cout <= led_task_cout + 32'd1;
                 end
     end
endtask
//task end
endmodule
       