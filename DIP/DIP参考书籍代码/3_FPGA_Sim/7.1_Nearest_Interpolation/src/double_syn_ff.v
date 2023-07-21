// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   double_syn_ff.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   
// 
// Modification History
// Date         By             Version         Change Description
//----------------------------------------------------------------------
// 2022/03/20   double_syn_ff  1.0              Original
// 
// *********************************************************************
module double_syn_ff
#(
    parameter C_DATA_WIDTH = 8
)(
    input  wire                     rst_n   ,
    input  wire                     clk     ,
    input  wire [C_DATA_WIDTH-1:0]  din     ,
    output reg  [C_DATA_WIDTH-1:0]  dout
);
//----------------------------------------------------------------------
//  内部变量定义
reg         [C_DATA_WIDTH-1:0]      data_r;

//----------------------------------------------------------------------
//  对输入信号进行两级同步后输出
always @(posedge clk or negedge rst_n)
begin
    if(rst_n == 1'b0)
        {dout,data_r} <= {(2*C_DATA_WIDTH){1'b0}};
    else
        {dout,data_r} <= {data_r,din};
end

endmodule