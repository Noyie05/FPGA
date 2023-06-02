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
            led2 =7`b0010000,
            led3 =7`b0001000,
            led4 =7`b0000100,
            stop =7`b0000010,
            clear=7`b0000001;

    parameter  
           led1_l=4`b1000,    
           led2_l=4`b0100,
           led3_l=4`b0010,
           led4_l=4`b0001,
           led_d =4`b0000;
    
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
                led_cout<=32`b0;
            end
            led1:
            begin
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
            
        endcase
        end
endmodule

task counter