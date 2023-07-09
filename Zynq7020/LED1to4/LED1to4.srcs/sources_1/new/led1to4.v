module led1to4(
    input sys_clk,
    input rst_n,
    output reg [3:0] led
    );

//reg and wire region
    reg [3:0] model;        //模式
    reg [31:0]led_count;    //led计数
    reg led_exist;          //led判定状态转向寄存器
    reg led_rst;            //控制分频块复位信号
//end

    parameter Idle =4'b0000,
              led1 =4'b0001,
              led2 =4'b0010,
              led3 =4'b0100,
              led4 =4'b1000,
              over =4'b1111;

    parameter Max_count_time=49_999_999,//可选计数时间
              Test_count_time=100;

    always @(posedge sys_clk or negedge rst_n) 
        begin
            if(!rst_n)
                begin
                    model<=Idle;
                    led<=Idle;
                    led_rst<=0;
                end
            else
                case(model)
                    Idle:
                        begin
                            if(led_exist==1)
                                begin
                                    led_rst<=1;
                                    model<=led1;
                                end
                            else 
                                begin
                                    led<=Idle;
                                    led_rst<=0;
                                end
                        end
                    led1:
                        begin
                            led<=led1;
                            if(led_exist==1)
                                begin
                                    led_rst<=1;
                                    model<=led2;
                                end
                            else
                                begin
                                   led<=led1;
                                   led_rst<=0;   
                                end
                        end                   
                    led2:
                        begin
                            if(led_exist==1)
                                begin
                                    led_rst<=1;
                                    model<=led3;
                                end
                            else
                                begin
                                   led<=led2;
                                   led_rst<=0;   
                                end
                        end
                    led3:
                        begin
                            led<=led3;
                            if(led_exist==1)
                                begin
                                    led_rst<=1;
                                    model<=led4;
                                end
                            else
                                begin
                                   led<=led3;
                                   led_rst<=0;   
                                end
                        end
                    led4:
                        begin
                            led<=led4;   
                            if(led_exist==1)
                                begin
                                    led_rst<=1;
                                    model<=over;
                                end
                            else
                                begin
                                    led<=led4;
                                    led_rst<=0;   
                                end                        
                        end
                    over:
                        begin
                            if(led_exist==1)
                                begin
                                    led_rst<=1;
                                    model<=Idle;
                                end
                            else
                                begin
                                    led<=over;
                                    led_rst<=0;
                                end
                        end
                    default: led<=Idle;
                endcase 
        end

                            
    always @(posedge sys_clk or negedge rst_n) 
        begin
            if(!rst_n)
                begin
                    led_count<=0;
                    led_exist<=0;
                end
            else if(led_rst)
                begin
                    led_exist<=0;
                end
            else if (led_count>=Max_count_time)
                begin
                    led_count<=0;
                    led_exist<=1;
                end
            else
                begin
                    led_count<=(led_count+1);
                    led_exist<=0;
                end
        end
    
    endmodule