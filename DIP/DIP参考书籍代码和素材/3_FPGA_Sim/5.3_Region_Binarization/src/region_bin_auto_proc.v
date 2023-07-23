// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   region_bin_auto_proc.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   
// 
// Modification History
// Date         By          Version         Change Description
//----------------------------------------------------------------------
// 2022/03/17   CrazyBird   1.0             Original
// 
// *********************************************************************
module region_bin_auto_proc
#(
    parameter   [10:0]  IMG_HDISP = 11'd640,            //  640*480
    parameter   [10:0]  IMG_VDISP = 11'd480
)
(
    input  wire                 clk             ,
    input  wire                 rst_n           ,
    
    //  Image data prepared to be processed
    input  wire                 per_img_vsync   ,       //  Prepared Image data vsync valid signal
    input  wire                 per_img_href    ,       //  Prepared Image data href vaild  signal
    input  wire     [7:0]       per_img_gray    ,       //  Prepared Image brightness input
    
    //  Image data has been processed
    output reg                  post_img_vsync  ,       //  processed Image data vsync valid signal
    output reg                  post_img_href   ,       //  processed Image data href vaild  signal
    output reg      [7:0]       post_img_gray           //  processed Image brightness output
);
//----------------------------------------------------------------------
//  Generate 8Bit 3X3 Matrix
wire                            matrix_img_vsync;
wire                            matrix_img_href;
wire                            matrix_top_edge_flag;
wire                            matrix_bottom_edge_flag;
wire                            matrix_left_edge_flag;
wire                            matrix_right_edge_flag;
wire            [7:0]           matrix_p11;
wire            [7:0]           matrix_p12;
wire            [7:0]           matrix_p13;
wire            [7:0]           matrix_p14;
wire            [7:0]           matrix_p15;
wire            [7:0]           matrix_p21;
wire            [7:0]           matrix_p22;
wire            [7:0]           matrix_p23;
wire            [7:0]           matrix_p24;
wire            [7:0]           matrix_p25;
wire            [7:0]           matrix_p31;
wire            [7:0]           matrix_p32;
wire            [7:0]           matrix_p33;
wire            [7:0]           matrix_p34;
wire            [7:0]           matrix_p35;
wire            [7:0]           matrix_p41;
wire            [7:0]           matrix_p42;
wire            [7:0]           matrix_p43;
wire            [7:0]           matrix_p44;
wire            [7:0]           matrix_p45;
wire            [7:0]           matrix_p51;
wire            [7:0]           matrix_p52;
wire            [7:0]           matrix_p53;
wire            [7:0]           matrix_p54;
wire            [7:0]           matrix_p55;

Matrix_Generate_5X5_8Bit
#(
    .IMG_HDISP  (IMG_HDISP  ),
    .IMG_VDISP  (IMG_VDISP  )
)
u_Matrix_Generate_5X5_8Bit
(
    //  global clock & reset
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),
    
    //  Image data prepared to be processed
    .per_img_vsync          (per_img_vsync          ),  //  Prepared Image data vsync valid signal
    .per_img_href           (per_img_href           ),  //  Prepared Image data href vaild  signal
    .per_img_gray           (per_img_gray           ),  //  Prepared Image brightness input
    
    //  Image data has been processed
    .matrix_img_vsync       (matrix_img_vsync       ),  //  processed Image data vsync valid signal
    .matrix_img_href        (matrix_img_href        ),  //  processed Image data href vaild  signal
    .matrix_top_edge_flag   (matrix_top_edge_flag   ),  //  processed Image top edge
    .matrix_bottom_edge_flag(matrix_bottom_edge_flag),  //  processed Image bottom edge
    .matrix_left_edge_flag  (matrix_left_edge_flag  ),  //  processed Image left edge
    .matrix_right_edge_flag (matrix_right_edge_flag ),  //  processed Image right edge
    .matrix_p11             (matrix_p11             ),  //  5X5 Matrix output
    .matrix_p12             (matrix_p12             ),
    .matrix_p13             (matrix_p13             ),
    .matrix_p14             (matrix_p14             ),
    .matrix_p15             (matrix_p15             ),
    .matrix_p21             (matrix_p21             ),
    .matrix_p22             (matrix_p22             ),
    .matrix_p23             (matrix_p23             ),
    .matrix_p24             (matrix_p24             ),
    .matrix_p25             (matrix_p25             ),
    .matrix_p31             (matrix_p31             ),  
    .matrix_p32             (matrix_p32             ),
    .matrix_p33             (matrix_p33             ),
    .matrix_p34             (matrix_p34             ),
    .matrix_p35             (matrix_p35             ),
    .matrix_p41             (matrix_p41             ),
    .matrix_p42             (matrix_p42             ),
    .matrix_p43             (matrix_p43             ),
    .matrix_p44             (matrix_p44             ),
    .matrix_p45             (matrix_p45             ),
    .matrix_p51             (matrix_p51             ),
    .matrix_p52             (matrix_p52             ),
    .matrix_p53             (matrix_p53             ),
    .matrix_p54             (matrix_p54             ),
    .matrix_p55             (matrix_p55             )
);

//----------------------------------------------------------------------
//              [p11,p12,p13,p14,p15]
//              [p21,p22,p23,p24,p25]
//  calc sum of [p31,p32,p33,p34,p35]
//              [p41,p42,p43,p44,p45]
//              [p51,p52,p53,p54,p55]
reg             [10:0]          data_sum1;
reg             [10:0]          data_sum2;
reg             [10:0]          data_sum3;
reg             [10:0]          data_sum4;
reg             [10:0]          data_sum5;

always @(posedge clk)
begin
    data_sum1 <= matrix_p11 + matrix_p12 + matrix_p13 + matrix_p14 + matrix_p15;
    data_sum2 <= matrix_p21 + matrix_p22 + matrix_p23 + matrix_p24 + matrix_p25;
    data_sum3 <= matrix_p31 + matrix_p32 + matrix_p33 + matrix_p34 + matrix_p35;
    data_sum4 <= matrix_p41 + matrix_p42 + matrix_p43 + matrix_p44 + matrix_p45;
    data_sum5 <= matrix_p51 + matrix_p52 + matrix_p53 + matrix_p54 + matrix_p55;
end

reg             [12:0]          data_sum;

always @(posedge clk)
begin
    data_sum <= data_sum1 + data_sum2 + data_sum3 + data_sum4 + data_sum5;
end

//----------------------------------------------------------------------
//  thresh = floor(sum/25*0.9) ==> floor(sum*603980 >> 24)
reg             [31:0]          mult_result;

always @(posedge clk)
begin
    mult_result <= data_sum*20'd603980;
end

wire            [7:0]          thresh;
assign thresh = mult_result[31:24];

//----------------------------------------------------------------------
//  lag 3 clocks signal sync
reg             [2:0]           matrix_img_vsync_r;
reg             [2:0]           matrix_img_href_r;
reg             [2:0]           matrix_edge_flag_r;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        matrix_img_vsync_r <= 3'b0;
        matrix_img_href_r  <= 3'b0;
        matrix_edge_flag_r <= 3'b0;
    end
    else
    begin
        matrix_img_vsync_r <= {matrix_img_vsync_r[1:0],matrix_img_vsync};
        matrix_img_href_r  <= {matrix_img_href_r[1:0],matrix_img_href};
        matrix_edge_flag_r <= {matrix_edge_flag_r[1:0],matrix_top_edge_flag | matrix_bottom_edge_flag | matrix_left_edge_flag | matrix_right_edge_flag};
    end
end

reg             [7:0]           matrix_p33_r    [0:2];

always @(posedge clk)
begin
    matrix_p33_r[0] <= matrix_p33;
    matrix_p33_r[1] <= matrix_p33_r[0];
    matrix_p33_r[2] <= matrix_p33_r[1];
end

//----------------------------------------------------------------------
//  result output
always @(posedge clk or negedge rst_n)
begin
    if(matrix_edge_flag_r[2] == 1'b1)
        post_img_gray <= 8'd255;
    else if(matrix_p33_r[2] < thresh)
        post_img_gray <= 8'd0;
    else
        post_img_gray <= 8'd255;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        post_img_vsync <= 1'b0;
        post_img_href  <= 1'b0;
    end
    else
    begin
        post_img_vsync <= matrix_img_vsync_r[2];
        post_img_href  <= matrix_img_href_r[2];
    end
end

endmodule