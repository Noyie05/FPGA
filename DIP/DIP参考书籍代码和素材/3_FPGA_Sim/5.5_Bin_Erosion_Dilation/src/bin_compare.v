// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   bin_compare.v
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
module bin_compare
#(
    parameter   [10:0]  IMG_HDISP = 11'd640,                //  640*480
    parameter   [10:0]  IMG_VDISP = 11'd480
)
(
    input  wire                 clk             ,
    input  wire                 rst_n           ,
    
    input  wire     [3:0]       thresh          ,
    
    //  Image data prepared to be processed
    input  wire                 per_img_vsync   ,       //  Prepared Image data vsync valid signal
    input  wire                 per_img_href    ,       //  Prepared Image data href vaild  signal
    input  wire                 per_img_bit     ,       //  Prepared Image brightness input
    
    //  Image data has been processed
    output reg                  post_img_vsync  ,       //  processed Image data vsync valid signal
    output reg                  post_img_href   ,       //  processed Image data href vaild  signal
    output reg                  post_img_bit            //  processed Image brightness output
);
//----------------------------------------------------------------------
//  Generate 8Bit 3X3 Matrix
wire                            matrix_img_vsync;
wire                            matrix_img_href;
wire                            matrix_top_edge_flag;
wire                            matrix_bottom_edge_flag;
wire                            matrix_left_edge_flag;
wire                            matrix_right_edge_flag;
wire                            matrix_p11;
wire                            matrix_p12;
wire                            matrix_p13;
wire                            matrix_p21;
wire                            matrix_p22;
wire                            matrix_p23;
wire                            matrix_p31; 
wire                            matrix_p32;
wire                            matrix_p33;

Matrix_Generate_3X3_1Bit
#(
    .IMG_HDISP  (IMG_HDISP  ),
    .IMG_VDISP  (IMG_VDISP  )
)
u_Matrix_Generate_3X3_1Bit
(
    //  global clock & reset
    .clk                    (clk                    ),
    .rst_n                  (rst_n                  ),
    
    //  Image data prepared to be processed
    .per_img_vsync          (per_img_vsync          ),      //  Prepared Image data vsync valid signal
    .per_img_href           (per_img_href           ),      //  Prepared Image data href vaild  signal
    .per_img_bit            (per_img_bit            ),      //  Prepared Image brightness input
    
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
//  calc sum of [p11,p12,p13;p21,p22,p23;p31,p32,p33]
reg             [1:0]           data_sum1;
reg             [1:0]           data_sum2;
reg             [1:0]           data_sum3;
reg             [3:0]           data_sum;

always @(posedge clk)
begin
    data_sum1 <= matrix_p11 + matrix_p12 + matrix_p13;
    data_sum2 <= matrix_p21 + matrix_p22 + matrix_p23;
    data_sum3 <= matrix_p31 + matrix_p32 + matrix_p33;
    data_sum  <= data_sum1 + data_sum2 + data_sum3;
end

//----------------------------------------------------------------------
//  lag 2 clocks signal sync
reg             [1:0]           matrix_img_vsync_r1;
reg             [1:0]           matrix_img_href_r1;
reg             [1:0]           matrix_edge_flag_r1;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        matrix_img_vsync_r1 <= 2'b0;
        matrix_img_href_r1  <= 2'b0;
        matrix_edge_flag_r1 <= 2'b0;
    end
    else
    begin
        matrix_img_vsync_r1 <= {matrix_img_vsync_r1[0],matrix_img_vsync};
        matrix_img_href_r1  <= {matrix_img_href_r1[0],matrix_img_href};
        matrix_edge_flag_r1 <= {matrix_edge_flag_r1[0],matrix_top_edge_flag | matrix_bottom_edge_flag | matrix_left_edge_flag | matrix_right_edge_flag};
    end
end

//----------------------------------------------------------------------
//  result output
always @(posedge clk)
begin
    if(matrix_edge_flag_r1[1] == 1'b1)
        post_img_bit <= 1'b0;
    else if(data_sum >= thresh)
        post_img_bit <= 1'b1;
    else
        post_img_bit <= 1'b0;
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
        post_img_vsync <= matrix_img_vsync_r1[1];
        post_img_href  <= matrix_img_href_r1[1];
    end
end

endmodule