module Matrix_Generate_3X3_1Bit
#(
    parameter   [10:0]  IMG_HDISP = 11'd640,            //  640*480
    parameter   [10:0]  IMG_VDISP = 11'd480,
    parameter   [10:0]  DELAY_NUM = 11'd10              //  Interval period from the penultimate row to the last row
)
(
    //  global clock & reset
    input  wire                 clk                     ,
    input  wire                 rst_n                   ,
    
    //  Image data prepared to be processed
    input  wire                 per_img_vsync           ,   //  Prepared Image data vsync valid signal
    input  wire                 per_img_href            ,   //  Prepared Image data href vaild  signal
    input  wire                 per_img_bit             ,   //  Prepared Image brightness input
    
    //  Image data has been processed
    output wire                 matrix_img_vsync        ,   //  processed Image data vsync valid signal
    output wire                 matrix_img_href         ,   //  processed Image data href vaild  signal
    output wire                 matrix_top_edge_flag    ,   //  processed Image top edge
    output wire                 matrix_bottom_edge_flag ,   //  processed Image bottom edge
    output wire                 matrix_left_edge_flag   ,   //  processed Image left edge
    output wire                 matrix_right_edge_flag  ,   //  processed Image right edge
    output reg                  matrix_p11              ,   //  3X3 Matrix output
    output reg                  matrix_p12              ,
    output reg                  matrix_p13              ,
    output reg                  matrix_p21              ,
    output reg                  matrix_p22              ,
    output reg                  matrix_p23              ,
    output reg                  matrix_p31              ,  
    output reg                  matrix_p32              ,
    output reg                  matrix_p33              
);
//----------------------------------------------------------------------
//  href & vsync counter
reg             [10:0]          hcnt;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hcnt <= 11'b0;
    else
    begin
        if(per_img_href == 1'b1)
            hcnt <= hcnt + 1'b1;
        else
            hcnt <= 11'b0;
    end
end

reg                             per_img_href_dly;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        per_img_href_dly <= 1'b0;
    else
        per_img_href_dly <= per_img_href;
end

wire img_href_neg = ~per_img_href & per_img_href_dly;       //  falling edge of per_img_href

reg             [10:0]          vcnt;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        vcnt <= 11'b0;
    else
    begin
        if(per_img_vsync == 1'b0)
            vcnt <= 11'b0;
        else if(img_href_neg == 1'b1)
            vcnt <= vcnt + 1'b1;
        else
            vcnt <= vcnt;
    end
end

//----------------------------------------------------------------------
//  two fifo for raw data buffer
reg             [10:0]          extend_last_row_cnt;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        extend_last_row_cnt <= 11'b0;
    else
    begin
        if((per_img_href == 1'b1)&&(vcnt == IMG_VDISP - 1'b1)&&(hcnt == IMG_HDISP - 1'b1))
            extend_last_row_cnt <= 11'd1;
        else if((extend_last_row_cnt > 11'b0)&&(extend_last_row_cnt < DELAY_NUM + IMG_HDISP))
            extend_last_row_cnt <= extend_last_row_cnt + 1'b1;
        else
            extend_last_row_cnt <= 11'b0;
    end
end

wire extend_last_row_en = (extend_last_row_cnt > DELAY_NUM) ? 1'b1 : 1'b0;

wire                            fifo1_wenb;
wire                            fifo1_wdata;
wire                            fifo1_renb;
wire                            fifo1_rdata;

wire                            fifo2_wenb;
wire                            fifo2_wdata;
wire                            fifo2_renb;
wire                            fifo2_rdata;

assign fifo1_wenb  = per_img_href;
assign fifo1_wdata = per_img_bit;
assign fifo1_renb  = per_img_href & (vcnt > 11'b0) | extend_last_row_en;

assign fifo2_wenb  = per_img_href & (vcnt > 11'b0);
assign fifo2_wdata = fifo1_rdata;
assign fifo2_renb  = per_img_href & (vcnt > 11'b1) | extend_last_row_en;

sync_fifo
#(
    .C_FIFO_WIDTH   (1      ),
    .C_FIFO_DEPTH   (1024   )
)
u1_sync_fifo
(
    .rst        (~rst_n     ),
    .clk        (clk        ),
    
    .wr_en      (fifo1_wenb ),
    .din        (fifo1_wdata), 
    .full       (           ),
    
    .rd_en      (fifo1_renb ),
    .dout       (fifo1_rdata),
    .empty      (           ),
    .data_count (           )
);

sync_fifo
#(
    .C_FIFO_WIDTH   (1      ),
    .C_FIFO_DEPTH   (1024   )
)
u2_sync_fifo
(
    .rst        (~rst_n     ),
    .clk        (clk        ),
    
    .wr_en      (fifo2_wenb ),
    .din        (fifo2_wdata), 
    .full       (           ),
    
    .rd_en      (fifo2_renb ),
    .dout       (fifo2_rdata),
    .empty      (           ),
    .data_count (           )
);

//----------------------------------------------------------------------
//  Read data from fifo
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        {matrix_p11, matrix_p12, matrix_p13} <= 3'h0;
        {matrix_p21, matrix_p22, matrix_p23} <= 3'h0;
        {matrix_p31, matrix_p32, matrix_p33} <= 3'h0;
    end
    else
    begin
        {matrix_p11, matrix_p12, matrix_p13} <= {matrix_p12, matrix_p13, fifo2_rdata};      //  1st row input
        {matrix_p21, matrix_p22, matrix_p23} <= {matrix_p22, matrix_p23, fifo1_rdata};      //  2nd row input
        {matrix_p31, matrix_p32, matrix_p33} <= {matrix_p32, matrix_p33, per_img_bit};     //  3rd row input
    end
end

reg             [1:0]           vsync;
reg             [1:0]           href;
reg             [1:0]           top_edge_flag;
reg             [1:0]           bottom_edge_flag;
reg             [1:0]           left_edge_flag;
reg             [1:0]           right_edge_flag;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        vsync <= 2'b0;
    else
    begin
        if((per_img_href == 1'b1)&&(vcnt == 11'd1)&&(hcnt == 11'b0))
            vsync[0] <= 1'b1;
        else if(extend_last_row_cnt == DELAY_NUM + IMG_HDISP)
            vsync[0] <= 1'b0;
        else
            vsync[0] <= vsync[0];
        vsync[1] <= vsync[0];
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        href             <= 2'b0;
        top_edge_flag    <= 2'b0;
        bottom_edge_flag <= 2'b0;
        left_edge_flag   <= 2'b0;
        right_edge_flag  <= 2'b0;
    end
    else
    begin
        href[0]             <= per_img_href & (vcnt > 11'b0) | extend_last_row_en;
        href[1]             <= href[0];
        top_edge_flag[0]    <= per_img_href & (vcnt == 11'd1);
        top_edge_flag[1]    <= top_edge_flag[0];
        bottom_edge_flag[0] <= extend_last_row_en;
        bottom_edge_flag[1] <= bottom_edge_flag[0];
        left_edge_flag[0]   <= per_img_href & (vcnt > 11'b0) & (hcnt == 11'b0) | (extend_last_row_cnt == DELAY_NUM + 1'b1);
        left_edge_flag[1]   <= left_edge_flag[0];
        right_edge_flag[0]  <= per_img_href & (vcnt > 11'b0) & (hcnt == IMG_HDISP - 1'b1) | (extend_last_row_cnt == DELAY_NUM + IMG_HDISP);
        right_edge_flag[1]  <= right_edge_flag[0];
    end
end

assign matrix_img_vsync        = vsync[1];
assign matrix_img_href         = href[1];
assign matrix_top_edge_flag    = top_edge_flag[1];
assign matrix_bottom_edge_flag = bottom_edge_flag[1];
assign matrix_left_edge_flag   = left_edge_flag[1];
assign matrix_right_edge_flag  = right_edge_flag[1];

endmodule