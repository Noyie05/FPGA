// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   median_filter_proc.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   
// 
// Modification History
// Date         By          Version         Change Description
//----------------------------------------------------------------------
// 2022/03/13   CrazyBird   1.0             Original
// 
// *********************************************************************
module median_filter_proc
#(
    parameter   [10:0]  IMG_HDISP = 11'd640,                //  640*480
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
wire            [7:0]           matrix_p21;
wire            [7:0]           matrix_p22;
wire            [7:0]           matrix_p23;
wire            [7:0]           matrix_p31; 
wire            [7:0]           matrix_p32;
wire            [7:0]           matrix_p33;

Matrix_Generate_3X3_8Bit
#(
    .IMG_HDISP  (IMG_HDISP  ),
    .IMG_VDISP  (IMG_VDISP  )
)
u_Matrix_Generate_3X3_8Bit
(
    //  global clock & reset
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),
    
    //  Image data prepared to be processed
    .per_img_vsync          (per_img_vsync          ),      //  Prepared Image data vsync valid signal
    .per_img_href           (per_img_href           ),      //  Prepared Image data href vaild  signal
    .per_img_gray           (per_img_gray           ),      //  Prepared Image brightness input
    
    //  Image data has been processed
    .matrix_img_vsync       (matrix_img_vsync       ),      //  processed Image data vsync valid signal
    .matrix_img_href        (matrix_img_href        ),      //  processed Image data href vaild  signal
    .matrix_top_edge_flag   (matrix_top_edge_flag   ),      //  processed Image top edge
    .matrix_bottom_edge_flag(matrix_bottom_edge_flag),      //  processed Image bottom edge
    .matrix_left_edge_flag  (matrix_left_edge_flag  ),      //  processed Image left edge
    .matrix_right_edge_flag (matrix_right_edge_flag ),      //  processed Image right edge
    .matrix_p11             (matrix_p11             ),      //  3X3 Matrix output
    .matrix_p12             (matrix_p12             ),
    .matrix_p13             (matrix_p13             ),
    .matrix_p21             (matrix_p21             ),
    .matrix_p22             (matrix_p22             ),
    .matrix_p23             (matrix_p23             ),
    .matrix_p31             (matrix_p31             ),  
    .matrix_p32             (matrix_p32             ),
    .matrix_p33             (matrix_p33             )
);

//----------------------------------------------------------------------
reg             [7:0]           row1_min_data;
reg             [7:0]           row1_med_data;
reg             [7:0]           row1_max_data;

always @(posedge clk)
begin
    if((matrix_p11 <= matrix_p12)&&(matrix_p11 <= matrix_p13))
        row1_min_data <= matrix_p11;
    else if((matrix_p12 <= matrix_p11)&&(matrix_p12 <= matrix_p13))
        row1_min_data <= matrix_p12;
    else
        row1_min_data <= matrix_p13;
end

always @(posedge clk)
begin
    if((matrix_p11 <= matrix_p12)&&(matrix_p11 >= matrix_p13)||(matrix_p11 >= matrix_p12)&&(matrix_p11 <= matrix_p13))
        row1_med_data <= matrix_p11;
    else if((matrix_p12 <= matrix_p11)&&(matrix_p12 >= matrix_p13)||(matrix_p12 >= matrix_p11)&&(matrix_p12 <= matrix_p13))
        row1_med_data <= matrix_p12;
    else
        row1_med_data <= matrix_p13;
end

always @(posedge clk)
begin
    if((matrix_p11 >= matrix_p12)&&(matrix_p11 >= matrix_p13))
        row1_max_data <= matrix_p11;
    else if((matrix_p12 >= matrix_p11)&&(matrix_p12 >= matrix_p13))
        row1_max_data <= matrix_p12;
    else
        row1_max_data <= matrix_p13;
end

reg             [7:0]           row2_min_data;
reg             [7:0]           row2_med_data;
reg             [7:0]           row2_max_data;

always @(posedge clk)
begin
    if((matrix_p21 <= matrix_p22)&&(matrix_p21 <= matrix_p23))
        row2_min_data <= matrix_p21;
    else if((matrix_p22 <= matrix_p21)&&(matrix_p22 <= matrix_p23))
        row2_min_data <= matrix_p22;
    else
        row2_min_data <= matrix_p23;
end

always @(posedge clk)
begin
    if((matrix_p21 <= matrix_p22)&&(matrix_p21 >= matrix_p23)||(matrix_p21 >= matrix_p22)&&(matrix_p21 <= matrix_p23))
        row2_med_data <= matrix_p21;
    else if((matrix_p22 <= matrix_p21)&&(matrix_p22 >= matrix_p23)||(matrix_p22 >= matrix_p21)&&(matrix_p22 <= matrix_p23))
        row2_med_data <= matrix_p22;
    else
        row2_med_data <= matrix_p23;
end

always @(posedge clk)
begin
    if((matrix_p21 >= matrix_p22)&&(matrix_p21 >= matrix_p23))
        row2_max_data <= matrix_p21;
    else if((matrix_p22 >= matrix_p21)&&(matrix_p22 >= matrix_p23))
        row2_max_data <= matrix_p22;
    else
        row2_max_data <= matrix_p23;
end

reg             [7:0]           row3_min_data;
reg             [7:0]           row3_med_data;
reg             [7:0]           row3_max_data;

always @(posedge clk)
begin
    if((matrix_p31 <= matrix_p32)&&(matrix_p31 <= matrix_p33))
        row3_min_data <= matrix_p31;
    else if((matrix_p32 <= matrix_p31)&&(matrix_p32 <= matrix_p33))
        row3_min_data <= matrix_p32;
    else
        row3_min_data <= matrix_p33;
end

always @(posedge clk)
begin
    if((matrix_p31 <= matrix_p32)&&(matrix_p31 >= matrix_p33)||(matrix_p31 >= matrix_p32)&&(matrix_p31 <= matrix_p33))
        row3_med_data <= matrix_p31;
    else if((matrix_p32 <= matrix_p31)&&(matrix_p32 >= matrix_p33)||(matrix_p32 >= matrix_p31)&&(matrix_p32 <= matrix_p33))
        row3_med_data <= matrix_p32;
    else
        row3_med_data <= matrix_p33;
end

always @(posedge clk)
begin
    if((matrix_p31 >= matrix_p32)&&(matrix_p31 >= matrix_p33))
        row3_max_data <= matrix_p31;
    else if((matrix_p32 >= matrix_p31)&&(matrix_p32 >= matrix_p33))
        row3_max_data <= matrix_p32;
    else
        row3_max_data <= matrix_p33;
end

//----------------------------------------------------------------------
reg             [7:0]           max_of_min_data;
reg             [7:0]           med_of_med_data;
reg             [7:0]           min_of_max_data;

always @(posedge clk)
begin
    if((row1_min_data >= row2_min_data)&&(row1_min_data >= row3_min_data))
        max_of_min_data <= row1_min_data;
    else if((row2_min_data >= row1_min_data)&&(row2_min_data >= row3_min_data))
        max_of_min_data <= row2_min_data;
    else
        max_of_min_data <= row3_min_data;
end

always @(posedge clk)
begin
    if((row1_med_data >= row2_med_data)&&(row1_med_data <= row3_med_data)||(row1_med_data <= row2_med_data)&&(row1_med_data >= row3_med_data))
        med_of_med_data <= row1_med_data;
    else if((row2_med_data >= row1_med_data)&&(row2_med_data <= row3_med_data)||(row2_med_data <= row1_med_data)&&(row2_med_data >= row3_med_data))
        med_of_med_data <= row2_med_data;
    else
        med_of_med_data <= row3_med_data;
end

always @(posedge clk)
begin
    if((row1_max_data <= row2_max_data)&&(row1_max_data <= row3_max_data))
        min_of_max_data <= row1_max_data;
    else if((row2_max_data <= row1_max_data)&&(row2_max_data <= row3_max_data))
        min_of_max_data <= row2_max_data;
    else
        min_of_max_data <= row3_max_data;
end

//----------------------------------------------------------------------
reg             [7:0]           pixel_data;

always @(posedge clk)
begin
    if((max_of_min_data >= med_of_med_data)&&(max_of_min_data <= min_of_max_data)||(max_of_min_data <= med_of_med_data)&&(max_of_min_data >= min_of_max_data))
        pixel_data <= max_of_min_data;
    else if((med_of_med_data >= max_of_min_data)&&(med_of_med_data <= min_of_max_data)||(med_of_med_data <= max_of_min_data)&&(med_of_med_data >= min_of_max_data))
        pixel_data <= med_of_med_data;
    else
        pixel_data <= min_of_max_data;
end

//----------------------------------------------------------------------
//  lag 3 clocks signal sync
reg             [2:0]           matrix_img_vsync_r1;
reg             [2:0]           matrix_img_href_r1;
reg             [2:0]           matrix_edge_flag_r1;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        matrix_img_vsync_r1 <= 3'b0;
        matrix_img_href_r1  <= 3'b0;
        matrix_edge_flag_r1 <= 3'b0;
    end
    else
    begin
        matrix_img_vsync_r1 <= {matrix_img_vsync_r1[1:0],matrix_img_vsync};
        matrix_img_href_r1  <= {matrix_img_href_r1[1:0],matrix_img_href};
        matrix_edge_flag_r1 <= {matrix_edge_flag_r1[1:0],matrix_top_edge_flag | matrix_bottom_edge_flag | matrix_left_edge_flag | matrix_right_edge_flag};
    end
end

reg             [7:0]           matrix_p22_r1       [0:2];

always @(posedge clk)
begin
    matrix_p22_r1[0] <= matrix_p22;
    matrix_p22_r1[1] <= matrix_p22_r1[0];
    matrix_p22_r1[2] <= matrix_p22_r1[1];
end

//----------------------------------------------------------------------
//  result output
always @(posedge clk)
begin
    if(matrix_edge_flag_r1[2] == 1'b1)
        post_img_gray <= matrix_p22_r1[2];
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
        post_img_vsync <= matrix_img_vsync_r1[2];
        post_img_href  <= matrix_img_href_r1[2];
    end
end

endmodule