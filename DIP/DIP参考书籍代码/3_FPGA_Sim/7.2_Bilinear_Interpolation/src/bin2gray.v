// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   bin2gray.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   
// 
// Modification History
// Date         By          Version         Change Description
//----------------------------------------------------------------------
// 2022/03/20   bin2gray   1.0              Original
// 
// *********************************************************************
module bin2gray
#(
    parameter C_DATA_WIDTH = 8
)(
    input  wire [C_DATA_WIDTH-1:0]  bin,
    output wire [C_DATA_WIDTH-1:0]  gray
);
//----------------------------------------------------------------------
assign gray = {1'b0,bin[C_DATA_WIDTH-1:1]} ^ bin;

endmodule