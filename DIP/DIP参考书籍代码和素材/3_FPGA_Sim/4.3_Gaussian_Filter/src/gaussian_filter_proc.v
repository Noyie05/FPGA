// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   gaussian_filter_proc.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   
// 
// Modification History
// Date         By          Version         Change Description
//----------------------------------------------------------------------
// 2022/03/16   CrazyBird   1.0             Original
// 
// *********************************************************************
module gaussian_filter_proc
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
//  [p11,p12,p13,p14,p15]   [32,38,40,38,32]
//  [p21,p22,p23,p24,p25]   [38,45,47,45,38]
//  [p31,p32,p33,p34,p35] * [40,47,50,47,40]
//  [p41,p42,p43,p44,p45]   [38,45,47,45,38]
//  [p51,p52,p53,p54,p55]   [32,38,40,38,32]
reg             [13:0]          mult_result11;
reg             [13:0]          mult_result12;
reg             [13:0]          mult_result13;
reg             [13:0]          mult_result14;
reg             [13:0]          mult_result15;
reg             [13:0]          mult_result21;
reg             [13:0]          mult_result22;
reg             [13:0]          mult_result23;
reg             [13:0]          mult_result24;
reg             [13:0]          mult_result25;
reg             [13:0]          mult_result31;
reg             [13:0]          mult_result32;
reg             [13:0]          mult_result33;
reg             [13:0]          mult_result34;
reg             [13:0]          mult_result35;
reg             [13:0]          mult_result41;
reg             [13:0]          mult_result42;
reg             [13:0]          mult_result43;
reg             [13:0]          mult_result44;
reg             [13:0]          mult_result45;
reg             [13:0]          mult_result51;
reg             [13:0]          mult_result52;
reg             [13:0]          mult_result53;
reg             [13:0]          mult_result54;
reg             [13:0]          mult_result55;

always @(posedge clk)
begin
    mult_result11 <= matrix_p11 * 6'd32;
    mult_result12 <= matrix_p12 * 6'd38;
    mult_result13 <= matrix_p13 * 6'd40;
    mult_result14 <= matrix_p14 * 6'd38;
    mult_result15 <= matrix_p15 * 6'd32;
    mult_result21 <= matrix_p21 * 6'd38;
    mult_result22 <= matrix_p22 * 6'd45;
    mult_result23 <= matrix_p23 * 6'd47;
    mult_result24 <= matrix_p24 * 6'd45;
    mult_result25 <= matrix_p25 * 6'd38;
    mult_result31 <= matrix_p31 * 6'd40;
    mult_result32 <= matrix_p32 * 6'd47;
    mult_result33 <= matrix_p33 * 6'd50;
    mult_result34 <= matrix_p34 * 6'd47;
    mult_result35 <= matrix_p35 * 6'd40;
    mult_result41 <= matrix_p41 * 6'd38;
    mult_result42 <= matrix_p42 * 6'd45;
    mult_result43 <= matrix_p43 * 6'd47;
    mult_result44 <= matrix_p44 * 6'd45;
    mult_result45 <= matrix_p45 * 6'd38;
    mult_result51 <= matrix_p51 * 6'd32;
    mult_result52 <= matrix_p52 * 6'd38;
    mult_result53 <= matrix_p53 * 6'd40;
    mult_result54 <= matrix_p54 * 6'd38;
    mult_result55 <= matrix_p55 * 6'd32;
end

reg             [15:0]          sum_result1;
reg             [15:0]          sum_result2;
reg             [15:0]          sum_result3;
reg             [15:0]          sum_result4;
reg             [15:0]          sum_result5;

always @(posedge clk)
begin
    sum_result1 <= mult_result11 + mult_result12 + mult_result13 + mult_result14 + mult_result15;
    sum_result2 <= mult_result21 + mult_result22 + mult_result23 + mult_result24 + mult_result25;
    sum_result3 <= mult_result31 + mult_result32 + mult_result33 + mult_result34 + mult_result35;
    sum_result4 <= mult_result41 + mult_result42 + mult_result43 + mult_result44 + mult_result45;
    sum_result5 <= mult_result51 + mult_result52 + mult_result53 + mult_result54 + mult_result55;
end

reg             [17:0]          sum_result;

always @(posedge clk)
begin
    sum_result <= sum_result1 + sum_result2 + sum_result3 + sum_result4 + sum_result5;
end

reg             [7:0]           pixel_data;

always @(posedge clk)
begin
    pixel_data <= sum_result[17:10] + sum_result[9];
end

//----------------------------------------------------------------------
//  lag 4 clocks signal sync
reg             [3:0]           matrix_img_vsync_r;
reg             [3:0]           matrix_img_href_r;
reg             [3:0]           matrix_edge_flag_r;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        matrix_img_vsync_r <= 4'b0;
        matrix_img_href_r  <= 4'b0;
        matrix_edge_flag_r <= 4'b0;
    end
    else
    begin
        matrix_img_vsync_r <= {matrix_img_vsync_r[2:0],matrix_img_vsync};
        matrix_img_href_r  <= {matrix_img_href_r[2:0],matrix_img_href};
        matrix_edge_flag_r <= {matrix_edge_flag_r[2:0],matrix_top_edge_flag | matrix_bottom_edge_flag | matrix_left_edge_flag | matrix_right_edge_flag};
    end
end

reg             [7:0]           matrix_p33_r    [0:3];

always @(posedge clk)
begin
    matrix_p33_r[0] <= matrix_p33;
    matrix_p33_r[1] <= matrix_p33_r[0];
    matrix_p33_r[2] <= matrix_p33_r[1];
    matrix_p33_r[3] <= matrix_p33_r[2];
end

//----------------------------------------------------------------------
//  result output
always @(posedge clk)
begin
    if(matrix_edge_flag_r[3] == 1'b1)
        post_img_gray <= matrix_p33_r[3];
    else
        post_img_gray <= pixel_data;
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
        post_img_vsync <= matrix_img_vsync_r[3];
        post_img_href  <= matrix_img_href_r[3];
    end
end

endmodule