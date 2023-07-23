// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   gray2bin.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   
// 
// Modification History
// Date         By          Version         Change Description
//----------------------------------------------------------------------
// 2022/03/20   gray2bin   1.0              Original
// 
// *********************************************************************
module gray2bin
#(
    parameter C_DATA_WIDTH = 8
)(
    input  wire [C_DATA_WIDTH-1:0]  gray,
    output wire [C_DATA_WIDTH-1:0]  bin
);
//----------------------------------------------------------------------
genvar                          i;

generate
    for(i = 0; i < C_DATA_WIDTH; i = i+1)
    begin : gray_to_bin
        assign bin[i] = ^(gray >> i);
    end
endgenerate

endmodule