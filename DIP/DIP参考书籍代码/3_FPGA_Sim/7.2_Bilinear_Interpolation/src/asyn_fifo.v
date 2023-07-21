// *********************************************************************
// 
// Copyright (C) 2021-20xx CrazyBird Corporation
// 
// Filename     :   asyn_fifo.v
// Author       :   CrazyBird
// Email        :   CrazyBirdLin@qq.com
// 
// Description  :   
// 
// Modification History
// Date         By          Version         Change Description
//----------------------------------------------------------------------
// 2022/03/20   asyn_fifo   1.0             Original
// 
// *********************************************************************
module asyn_fifo
#(
    parameter C_DATA_WIDTH       = 8,
    parameter C_FIFO_DEPTH_WIDTH = 4
)(
    input  wire                         wr_rst_n,
    input  wire                         wr_clk,
    input  wire                         wr_en,
    input  wire [C_DATA_WIDTH-1:0]      wr_data,
    output reg                          wr_full,
    output reg  [C_FIFO_DEPTH_WIDTH:0]  wr_cnt,
    input  wire                         rd_rst_n,
    input  wire                         rd_clk,
    input  wire                         rd_en,
    output wire [C_DATA_WIDTH-1:0]      rd_data,
    output reg                          rd_empty,
    output reg  [C_FIFO_DEPTH_WIDTH:0]  rd_cnt
);
//----------------------------------------------------------------------
//  内部变量定义
reg     [C_DATA_WIDTH-1:0]      mem     [0:(1 << C_FIFO_DEPTH_WIDTH)-1];
wire    [C_FIFO_DEPTH_WIDTH-1:0]        wr_addr;
wire    [C_FIFO_DEPTH_WIDTH-1:0]        rd_addr;
wire    [C_FIFO_DEPTH_WIDTH:0]          next_wr_bin_ptr;
wire    [C_FIFO_DEPTH_WIDTH:0]          next_rd_bin_ptr;
reg     [C_FIFO_DEPTH_WIDTH:0]          wr_bin_ptr;
reg     [C_FIFO_DEPTH_WIDTH:0]          rd_bin_ptr;
wire    [C_FIFO_DEPTH_WIDTH:0]          next_wr_gray_ptr;
wire    [C_FIFO_DEPTH_WIDTH:0]          next_rd_gray_ptr;
wire    [C_FIFO_DEPTH_WIDTH:0]          syn_wr_bin_ptr_rd_clk;
wire    [C_FIFO_DEPTH_WIDTH:0]          syn_rd_bin_ptr_wr_clk;
wire    [C_FIFO_DEPTH_WIDTH:0]          syn_wr_gray_ptr_rd_clk;
wire    [C_FIFO_DEPTH_WIDTH:0]          syn_rd_gray_ptr_wr_clk;
wire    [C_FIFO_DEPTH_WIDTH:0]          wr_cnt_w;
wire    [C_FIFO_DEPTH_WIDTH:0]          rd_cnt_w;
wire                                    wr_full_w;
wire                                    rd_empty_w;

//----------------------------------------------------------------------
//  双端口RAM的读写
//  写RAM
always @(posedge wr_clk)
begin
    if((wr_en & ~wr_full) == 1'b1)
        mem[wr_addr] <= wr_data;
end
//  读RAM
assign rd_data = mem[rd_addr];

//----------------------------------------------------------------------
//  二进制写指针的产生
assign next_wr_bin_ptr = wr_bin_ptr + (wr_en & ~wr_full);

always @(posedge wr_clk or negedge wr_rst_n)
begin
    if(wr_rst_n == 1'b0)
        wr_bin_ptr <= {(C_FIFO_DEPTH_WIDTH+1){1'b0}};
    else
        wr_bin_ptr <= next_wr_bin_ptr;
end

//----------------------------------------------------------------------
//  RAM写地址的产生
assign wr_addr = wr_bin_ptr[C_FIFO_DEPTH_WIDTH-1:0];

//----------------------------------------------------------------------
//  二进制写指针转换成格雷码写指针
bin2gray 
#(
    .C_DATA_WIDTH(C_FIFO_DEPTH_WIDTH+1)
)
u_bin2gray_wr 
(
    .bin    (next_wr_bin_ptr    ),
    .gray   (next_wr_gray_ptr   )
);

//----------------------------------------------------------------------
//  对格雷码读指针在写时钟域中进行两级同步
double_syn_ff 
#(
    .C_DATA_WIDTH(C_FIFO_DEPTH_WIDTH+1)
)
u_double_syn_ff_wr 
(
    .rst_n  (wr_rst_n               ),
    .clk    (wr_clk                 ),
    .din    (next_rd_gray_ptr       ),
    .dout   (syn_rd_gray_ptr_wr_clk )
);

//----------------------------------------------------------------------
//  同步后的格雷码读指针转换成同步后的二进制读指针
gray2bin 
#(
    .C_DATA_WIDTH(C_FIFO_DEPTH_WIDTH+1)
)
u_gray2bin_wr 
(
    .gray   (syn_rd_gray_ptr_wr_clk ),
    .bin    (syn_rd_bin_ptr_wr_clk  )
);

//----------------------------------------------------------------------
//  FIFO写满标志位的产生和写FIFO数据量的计数
assign wr_full_w = (next_wr_gray_ptr == ({~syn_rd_gray_ptr_wr_clk[C_FIFO_DEPTH_WIDTH:C_FIFO_DEPTH_WIDTH-1],
                    syn_rd_gray_ptr_wr_clk[C_FIFO_DEPTH_WIDTH-2:0]}));
assign wr_cnt_w  = next_wr_bin_ptr - syn_rd_bin_ptr_wr_clk;

always @(posedge wr_clk or negedge wr_rst_n)
begin
    if(wr_rst_n == 1'b0)
    begin
        wr_full <= 1'b1;
        wr_cnt  <= {(C_FIFO_DEPTH_WIDTH+1){1'b0}};
    end
    else
    begin
        wr_full <= wr_full_w;
        wr_cnt  <= wr_cnt_w;
    end
end

//----------------------------------------------------------------------
//  二进制读指针的产生
assign next_rd_bin_ptr = rd_bin_ptr + (rd_en & ~rd_empty);

always @(posedge rd_clk or negedge rd_rst_n)
begin
    if(rd_rst_n == 1'b0)
        rd_bin_ptr <= {(C_FIFO_DEPTH_WIDTH+1){1'b0}};
    else
        rd_bin_ptr <= next_rd_bin_ptr;
end

//----------------------------------------------------------------------
//  RAM读地址的产生
assign rd_addr = rd_bin_ptr[C_FIFO_DEPTH_WIDTH-1:0];

//----------------------------------------------------------------------
//  二进制读指针转换成格雷码读指针
bin2gray 
#(
    .C_DATA_WIDTH(C_FIFO_DEPTH_WIDTH+1)
)
u_bin2gray_rd 
(
    .bin    (next_rd_bin_ptr    ),
    .gray   (next_rd_gray_ptr   )
);

//----------------------------------------------------------------------
//  对格雷码写指针在读时钟域中进行两级同步
double_syn_ff 
#(
    .C_DATA_WIDTH(C_FIFO_DEPTH_WIDTH+1)
)
u_double_syn_ff_rd 
(
    .rst_n  (rd_rst_n               ),
    .clk    (rd_clk                 ),
    .din    (next_wr_gray_ptr       ),
    .dout   (syn_wr_gray_ptr_rd_clk )
);

//----------------------------------------------------------------------
//  同步后的格雷码写指针转换成同步后的二进制写指针
gray2bin
#(
    .C_DATA_WIDTH(C_FIFO_DEPTH_WIDTH+1)
)
u_gray2bin_rd 
(
    .gray   (syn_wr_gray_ptr_rd_clk ),
    .bin    (syn_wr_bin_ptr_rd_clk  )
);

//----------------------------------------------------------------------
//  FIFO读空标志位的产生和读FIFO数据量的计数
assign rd_empty_w = (next_rd_gray_ptr == syn_wr_gray_ptr_rd_clk);
assign rd_cnt_w   = syn_wr_bin_ptr_rd_clk - next_rd_bin_ptr;

always @(posedge rd_clk or negedge rd_rst_n)
begin
    if(rd_rst_n == 1'b0)
    begin
        rd_empty <= 1'b1;
        rd_cnt   <= {(C_FIFO_DEPTH_WIDTH+1){1'b0}};
    end
    else
    begin
        rd_empty <= rd_empty_w;
        rd_cnt   <= rd_cnt_w;
    end
end

endmodule