module Matrix_Generate_5X5_8Bit
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
    input  wire     [7:0]       per_img_gray            ,   //  Prepared Image brightness input
    
    //  Image data has been processed
    output wire                 matrix_img_vsync        ,   //  processed Image data vsync valid signal
    output wire                 matrix_img_href         ,   //  processed Image data href vaild  signal
    output wire                 matrix_top_edge_flag    ,   //  processed Image top edge
    output wire                 matrix_bottom_edge_flag ,   //  processed Image bottom edge
    output wire                 matrix_left_edge_flag   ,   //  processed Image left edge
    output wire                 matrix_right_edge_flag  ,   //  processed Image right edge
    output reg      [7:0]       matrix_p11              ,   //  5X5 Matrix output
    output reg      [7:0]       matrix_p12              ,
    output reg      [7:0]       matrix_p13              ,
    output reg      [7:0]       matrix_p14              ,
    output reg      [7:0]       matrix_p15              ,
    output reg      [7:0]       matrix_p21              ,
    output reg      [7:0]       matrix_p22              ,
    output reg      [7:0]       matrix_p23              ,
    output reg      [7:0]       matrix_p24              ,
    output reg      [7:0]       matrix_p25              ,
    output reg      [7:0]       matrix_p31              ,  
    output reg      [7:0]       matrix_p32              ,
    output reg      [7:0]       matrix_p33              ,
    output reg      [7:0]       matrix_p34              ,
    output reg      [7:0]       matrix_p35              ,
    output reg      [7:0]       matrix_p41              ,
    output reg      [7:0]       matrix_p42              ,
    output reg      [7:0]       matrix_p43              ,
    output reg      [7:0]       matrix_p44              ,
    output reg      [7:0]       matrix_p45              ,
    output reg      [7:0]       matrix_p51              ,
    output reg      [7:0]       matrix_p52              ,
    output reg      [7:0]       matrix_p53              ,
    output reg      [7:0]       matrix_p54              ,
    output reg      [7:0]       matrix_p55              
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
reg             [11:0]          extend_last_two_row_cnt;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        extend_last_two_row_cnt <= 12'b0;
    else
    begin
        if((per_img_href == 1'b1)&&(vcnt == IMG_VDISP - 1'b1)&&(hcnt == IMG_HDISP - 1'b1))
            extend_last_two_row_cnt <= 12'd1;
        else if((extend_last_two_row_cnt > 12'b0)&&(extend_last_two_row_cnt < {DELAY_NUM,1'b0} + {IMG_HDISP,1'b0}))
            extend_last_two_row_cnt <= extend_last_two_row_cnt + 1'b1;
        else
            extend_last_two_row_cnt <= 12'b0;
    end
end

wire extend_2nd_last_row_en = (extend_last_two_row_cnt > DELAY_NUM)&(extend_last_two_row_cnt <= DELAY_NUM + IMG_HDISP) ? 1'b1 : 1'b0;
wire extend_1st_last_row_en = (extend_last_two_row_cnt > {DELAY_NUM,1'b0} + IMG_HDISP) ? 1'b1 : 1'b0;

wire                            fifo1_wenb;
wire            [7:0]           fifo1_wdata;
wire                            fifo1_renb;
wire            [7:0]           fifo1_rdata;

wire                            fifo2_wenb;
wire            [7:0]           fifo2_wdata;
wire                            fifo2_renb;
wire            [7:0]           fifo2_rdata;

wire                            fifo3_wenb;
wire            [7:0]           fifo3_wdata;
wire                            fifo3_renb;
wire            [7:0]           fifo3_rdata;

wire                            fifo4_wenb;
wire            [7:0]           fifo4_wdata;
wire                            fifo4_renb;
wire            [7:0]           fifo4_rdata;

assign fifo1_wenb  = per_img_href;
assign fifo1_wdata = per_img_gray;
assign fifo1_renb  = per_img_href & (vcnt > 11'd0) | extend_2nd_last_row_en;

assign fifo2_wenb  = per_img_href & (vcnt > 11'd0) | extend_2nd_last_row_en;
assign fifo2_wdata = fifo1_rdata;
assign fifo2_renb  = per_img_href & (vcnt > 11'd1) | extend_2nd_last_row_en | extend_1st_last_row_en;

assign fifo3_wenb  = per_img_href & (vcnt > 11'd1) | extend_2nd_last_row_en;
assign fifo3_wdata = fifo2_rdata;
assign fifo3_renb  = per_img_href & (vcnt > 11'd2) | extend_2nd_last_row_en | extend_1st_last_row_en;

assign fifo4_wenb  = per_img_href & (vcnt > 11'd2) | extend_2nd_last_row_en;
assign fifo4_wdata = fifo3_rdata;
assign fifo4_renb  = per_img_href & (vcnt > 11'd3) | extend_2nd_last_row_en | extend_1st_last_row_en;

sync_fifo
#(
    .C_FIFO_WIDTH   (8      ),
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
    .C_FIFO_WIDTH   (8      ),
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

sync_fifo
#(
    .C_FIFO_WIDTH   (8      ),
    .C_FIFO_DEPTH   (1024   )
)
u3_sync_fifo
(
    .rst        (~rst_n     ),
    .clk        (clk        ),
    
    .wr_en      (fifo3_wenb ),
    .din        (fifo3_wdata), 
    .full       (           ),
    
    .rd_en      (fifo3_renb ),
    .dout       (fifo3_rdata),
    .empty      (           ),
    .data_count (           )
);

sync_fifo
#(
    .C_FIFO_WIDTH   (8      ),
    .C_FIFO_DEPTH   (1024   )
)
u4_sync_fifo
(
    .rst        (~rst_n     ),
    .clk        (clk        ),
    
    .wr_en      (fifo4_wenb ),
    .din        (fifo4_wdata), 
    .full       (           ),
    
    .rd_en      (fifo4_renb ),
    .dout       (fifo4_rdata),
    .empty      (           ),
    .data_count (           )
);

//----------------------------------------------------------------------
//  Read data from fifo
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        {matrix_p11, matrix_p12, matrix_p13, matrix_p14, matrix_p15} <= 40'h0;
        {matrix_p21, matrix_p22, matrix_p23, matrix_p24, matrix_p25} <= 40'h0;
        {matrix_p31, matrix_p32, matrix_p33, matrix_p34, matrix_p35} <= 40'h0;
        {matrix_p41, matrix_p42, matrix_p43, matrix_p44, matrix_p45} <= 40'h0;
        {matrix_p51, matrix_p52, matrix_p53, matrix_p54, matrix_p55} <= 40'h0;
    end
    else
    begin
        {matrix_p11, matrix_p12, matrix_p13, matrix_p14, matrix_p15} <= {matrix_p12, matrix_p13, matrix_p14, matrix_p15, fifo4_rdata};      //  1st row input
        {matrix_p21, matrix_p22, matrix_p23, matrix_p24, matrix_p25} <= {matrix_p22, matrix_p23, matrix_p24, matrix_p25, fifo3_rdata};      //  2nd row input
        {matrix_p31, matrix_p32, matrix_p33, matrix_p34, matrix_p35} <= {matrix_p32, matrix_p33, matrix_p34, matrix_p35, fifo2_rdata};      //  3rd row input
        {matrix_p41, matrix_p42, matrix_p43, matrix_p44, matrix_p45} <= {matrix_p42, matrix_p43, matrix_p44, matrix_p45, fifo1_rdata};      //  4rd row input
        {matrix_p51, matrix_p52, matrix_p53, matrix_p54, matrix_p55} <= {matrix_p52, matrix_p53, matrix_p54, matrix_p55, per_img_gray};     //  5rd row input
    end
end

reg             [2:0]           vsync;
reg             [2:0]           href;
reg             [2:0]           top_edge_flag;
reg             [2:0]           bottom_edge_flag;
reg             [2:0]           left_edge_flag;
reg             [2:0]           right_edge_flag;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        vsync <= 3'b0;
    else
    begin
        if((per_img_href == 1'b1)&&(vcnt == 11'd2)&&(hcnt == 11'b0))
            vsync[0] <= 1'b1;
        else if(extend_last_two_row_cnt == {DELAY_NUM,1'b0} + {IMG_HDISP,1'b0})
            vsync[0] <= 1'b0;
        else
            vsync[0] <= vsync[0];
        vsync[2:1] <= vsync[1:0];
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        href             <= 3'b0;
        top_edge_flag    <= 3'b0;
        bottom_edge_flag <= 3'b0;
        left_edge_flag   <= 3'b0;
        right_edge_flag  <= 3'b0;
    end
    else
    begin
        href[0]               <= per_img_href & (vcnt > 11'd1) | extend_2nd_last_row_en | extend_1st_last_row_en;
        href[2:1]             <= href[1:0];
        top_edge_flag[0]      <= per_img_href & ((vcnt == 11'd2) | (vcnt == 11'd3));
        top_edge_flag[2:1]    <= top_edge_flag[1:0];
        bottom_edge_flag[0]   <= extend_2nd_last_row_en | extend_1st_last_row_en;
        bottom_edge_flag[2:1] <= bottom_edge_flag[1:0];
        left_edge_flag[0]     <= per_img_href & (vcnt > 11'd1) & (hcnt <= 11'd1) | (extend_last_two_row_cnt == DELAY_NUM + 1'b1) | (extend_last_two_row_cnt == DELAY_NUM + 2'd2) 
                                | (extend_last_two_row_cnt == {DELAY_NUM,1'b0} + IMG_HDISP + 1'b1) | (extend_last_two_row_cnt == {DELAY_NUM,1'b0} + IMG_HDISP + 2'd2);
        left_edge_flag[2:1]   <= left_edge_flag[1:0];
        right_edge_flag[0]    <= per_img_href & (vcnt > 11'd1) & (hcnt >= IMG_HDISP - 2'd2) | (extend_last_two_row_cnt == DELAY_NUM + IMG_HDISP - 1'b1) | (extend_last_two_row_cnt == DELAY_NUM + IMG_HDISP) 
                                | (extend_last_two_row_cnt == {DELAY_NUM,1'b0} + {IMG_HDISP,1'b0} - 1'b1) | (extend_last_two_row_cnt == {DELAY_NUM,1'b0} + {IMG_HDISP,1'b0});
        right_edge_flag[2:1]  <= right_edge_flag[1:0];
    end
end

assign matrix_img_vsync        = vsync[2];
assign matrix_img_href         = href[2];
assign matrix_top_edge_flag    = top_edge_flag[2];
assign matrix_bottom_edge_flag = bottom_edge_flag[2];
assign matrix_left_edge_flag   = left_edge_flag[2];
assign matrix_right_edge_flag  = right_edge_flag[2];

endmodule