module histEQ_proc
(
    input  wire                 clk                 ,
    input  wire                 rst_n               ,
    
    input  wire     [ 7:0]      pixel_level         ,
    input  wire     [19:0]      pixel_level_acc_num ,
    input  wire                 pixel_level_valid   ,
    output reg                  histEQ_start_flag   ,
    
    input  wire                 per_img_vsync       ,
    input  wire                 per_img_href        ,
    input  wire     [ 7:0]      per_img_gray        ,
    
    output wire                 post_img_vsync      ,
    output wire                 post_img_href       ,
    output wire     [ 7:0]      post_img_gray       
);
//----------------------------------------------------------------------
//  delay 1 clock
wire                            bram_a_wenb;
wire            [ 7:0]          bram_a_addr;
wire            [19:0]          bram_a_wdata;
wire            [ 7:0]          bram_b_addr;
wire            [19:0]          bram_b_rdata;

assign bram_a_wenb  = pixel_level_valid;
assign bram_a_addr  = pixel_level;
assign bram_a_wdata = pixel_level_acc_num;
assign bram_b_addr  = per_img_gray;

bram_ture_dual_port
#(
    .C_ADDR_WIDTH   (8 ),
    .C_DATA_WIDTH   (20)
)
u_bram_ture_dual_port
(
    .clka   (clk            ),
    .wea    (bram_a_wenb    ),
    .addra  (bram_a_addr    ),
    .dina   (bram_a_wdata   ),
    .douta  (               ),
    .clkb   (clk            ),
    .web    (1'b0           ),
    .addrb  (bram_b_addr    ),
    .dinb   (20'b0          ),
    .doutb  (bram_b_rdata   )
);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        histEQ_start_flag <= 1'b0;
    else
    begin
        if((pixel_level_valid == 1'b1)&&(pixel_level == 8'd255))
            histEQ_start_flag <= 1'b1;
        else
            histEQ_start_flag <= 1'b0;
    end
end

//----------------------------------------------------------------------
//  uint8(CumPixel/980) = round(CumPixel * 136957/2^27) , CumPixel <= 500*500
reg             [34:0]          mult_result;

always @(posedge clk)
begin
    mult_result <= bram_b_rdata * 18'd136957;
end

reg             [7:0]           pixel_data;

always @(posedge clk)
begin
    pixel_data <= mult_result[34:27] + mult_result[26];
end

//----------------------------------------------------------------------
//  lag 3 clocks signal sync
reg             [2:0]           per_img_vsync_r;
reg             [2:0]           per_img_href_r;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        per_img_vsync_r <= 3'b0;
        per_img_href_r  <= 3'b0;
    end
    else
    begin
        per_img_vsync_r <= {per_img_vsync_r[1:0],per_img_vsync};
        per_img_href_r  <= {per_img_href_r[1:0],per_img_href};
    end
end

//----------------------------------------------------------------------
assign post_img_vsync = per_img_vsync_r[2];
assign post_img_href  = per_img_href_r[2];
assign post_img_gray  = pixel_data;

endmodule