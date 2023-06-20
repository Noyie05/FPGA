module Running_Light (
    input  wire [1:0]S,
    input  wire clk,
    input  wire rst,
    output wire Y
);

    reg [1:0] sel;
    reg [7:0] Y_out;
    reg [31:0] state_count;
    reg [7:0]  state_exist;
    reg count_rst;
    parameter 
               model_1=2'b00,
               model_2=2'b01,
               model_3=2'b10,
               model_4=2'b11,

              
    parameter Idle =8'b0,
              Special=8'b11110000;

    parameter Count_time=100;

    always @(posedge clk or negedge rst) 
        begin
            case (sel)
                model_1:
                    begin
                      
                    end 
                model_2:
                model_3:
                model_4:
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
                        state_exist<=0;
                        count_rst<=0;
                    end
        end

    assign Y=Y_out;
    
endmodule //Running_Light