module hist_stat
(
    input  wire                 clk                 ,
    input  wire                 rst_n               ,
    
    input  wire                 img_vsync           ,
    input  wire                 img_href            ,
    input  wire     [ 7:0]      img_gray            ,
    
    output reg      [ 7:0]      pixel_level         ,
    output reg      [19:0]      pixel_level_acc_num ,
    output reg                  pixel_level_valid   
);
//----------------------------------------------------------------------
//  bram signals define
wire                            bram_a_wenb;
wire            [ 7:0]          bram_a_addr;
wire            [19:0]          bram_a_rdata;
wire                            bram_b_wenb;
wire            [ 7:0]          bram_b_addr;
wire            [19:0]          bram_b_wdata;
wire            [19:0]          bram_b_rdata;

//----------------------------------------------------------------------
//  preprocess
reg             [7:0]           pixel_data;

always @(posedge clk)
begin
    pixel_data <= img_gray;
end

reg                             pixel_data_valid;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_data_valid <= 1'b0;
    else
        pixel_data_valid <= img_href;
end

reg                             img_vsync_dly;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        img_vsync_dly <= 1'b0;
    else
        img_vsync_dly <= img_vsync;
end

wire                            pixel_data_eop;
assign pixel_data_eop = img_vsync_dly & ~img_vsync;

//----------------------------------------------------------------------
//  preprocess
reg             [7:0]           pixel_data_tmp;

always @(posedge clk)
begin
    pixel_data_tmp <= pixel_data;
end

reg                             pixel_data_valid_tmp1;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_data_valid_tmp1 <= 1'b0;
    else
    begin
        if(pixel_data_valid == 1'b1)
        begin
            if(pixel_data_valid_tmp1 == 1'b0)
                pixel_data_valid_tmp1 <= 1'b1;
            else
            begin
                if(pixel_data_tmp == pixel_data)
                    pixel_data_valid_tmp1 <= 1'b0;
                else
                    pixel_data_valid_tmp1 <= 1'b1;
            end
        end
        else
            pixel_data_valid_tmp1 <= 1'b0;
    end
end

reg             [1:0]           pixel_data_cnt_tmp;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_data_cnt_tmp <= 2'd1;
    else
    begin
        if((pixel_data_valid == 1'b1)&&(pixel_data_valid_tmp1 == 1'b1)&&(pixel_data_tmp == pixel_data))
            pixel_data_cnt_tmp <= 2'd2;
        else
            pixel_data_cnt_tmp <= 2'd1;
    end
end

reg                             pixel_data_eop_tmp;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_data_eop_tmp <= 1'b0;
    else
        pixel_data_eop_tmp <= pixel_data_eop;
end

//----------------------------------------------------------------------
//  c1
reg             [7:0]           pixel_data_c1;

always @(posedge clk)
begin
    pixel_data_c1 <= pixel_data;
end

reg                             pixel_data_eop_c1;
reg                             pixel_data_valid_tmp_c1;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        pixel_data_eop_c1       <= 1'b0;
        pixel_data_valid_tmp_c1 <= 1'b0;
    end
    else
    begin
        pixel_data_eop_c1       <= pixel_data_eop_tmp;
        pixel_data_valid_tmp_c1 <= pixel_data_valid_tmp1;
    end
end

//----------------------------------------------------------------------
//  c2 : delay 3 clock
reg             [7:0]           pixel_data_c2;

always @(posedge clk)
begin
    pixel_data_c2 <= pixel_data_c1;
end

reg                             pixel_data_eop_tmp1_c2;
reg                             pixel_data_eop_tmp2_c2;
reg                             pixel_data_eop_c2;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        pixel_data_eop_tmp1_c2 <= 1'b0;
        pixel_data_eop_tmp2_c2 <= 1'b0;
        pixel_data_eop_c2      <= 1'b0;
    end
    else
    begin
        pixel_data_eop_tmp1_c2 <= pixel_data_eop_c1;
        pixel_data_eop_tmp2_c2 <= pixel_data_eop_tmp1_c2;
        pixel_data_eop_c2      <= pixel_data_eop_tmp2_c2;
    end
end

//----------------------------------------------------------------------
//  c3
reg                             bram_rw_ctrl_flag_c3;
reg             [8:0]           bram_rw_ctrl_cnt;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        bram_rw_ctrl_flag_c3 <= 1'b0;
    else
    begin
        if(pixel_data_eop_c2 == 1'b1)
            bram_rw_ctrl_flag_c3 <= 1'b1;
        else if(bram_rw_ctrl_cnt == 9'h100)
            bram_rw_ctrl_flag_c3 <= 1'b0;
        else
            bram_rw_ctrl_flag_c3 <= bram_rw_ctrl_flag_c3;
    end
end

reg             [8:0]           bram_rw_ctrl_cnt_dly;

always @(posedge clk)
begin
    bram_rw_ctrl_cnt_dly <= bram_rw_ctrl_cnt;
end

always @(*)
begin
    if(bram_rw_ctrl_flag_c3 == 1'b1)
        bram_rw_ctrl_cnt <= bram_rw_ctrl_cnt_dly + 1'b1;
    else
        bram_rw_ctrl_cnt <= 9'b0;
end

wire            [7:0]           bram_addr_c3;
assign bram_addr_c3 = bram_rw_ctrl_cnt - 1'b1;

//----------------------------------------------------------------------
//  c4
reg                             bram_rw_ctrl_flag_c4;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        bram_rw_ctrl_flag_c4 <= 1'b0;
    else
        bram_rw_ctrl_flag_c4 <= bram_rw_ctrl_flag_c3;
end

reg             [7:0]           bram_addr_c4;

always @(posedge clk)
begin
    bram_addr_c4 <= bram_addr_c3;
end

//----------------------------------------------------------------------
//  c5
reg             [7:0]           pixel_level_c5;

always @(posedge clk)
begin
    pixel_level_c5 <= bram_addr_c4;
end

reg             [19:0]          pixel_level_num_c5;

always @(posedge clk)
begin
    if(bram_rw_ctrl_flag_c4 == 1'b1)
        pixel_level_num_c5 <= bram_b_rdata;
    else
        pixel_level_num_c5 <= 20'b0;
end

reg                             pixel_level_valid_c5;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_level_valid_c5 <= 1'b0;
    else
        pixel_level_valid_c5 <= bram_rw_ctrl_flag_c4;
end

//----------------------------------------------------------------------
//  c6
reg             [7:0]           pixel_level_c6;

always @(posedge clk)
begin
    pixel_level_c6 <= pixel_level_c5;
end

reg             [19:0]          pixel_level_acc_num_c6;

always @(posedge clk)
begin
    if(pixel_level_valid_c5 == 1'b1)
    begin
        if(pixel_level_c5 == 8'b0)
            pixel_level_acc_num_c6 <= pixel_level_num_c5;
        else
            pixel_level_acc_num_c6 <= pixel_level_acc_num_c6 + pixel_level_num_c5;
    end
    else
        pixel_level_acc_num_c6 <= pixel_level_acc_num_c6;
end

reg                             pixel_level_valid_c6;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_level_valid_c6 <= 1'b0;
    else
        pixel_level_valid_c6 <= pixel_level_valid_c5;
end

//----------------------------------------------------------------------
//  signal output
always @(posedge clk)
begin
    pixel_level         <= pixel_level_c6;
    pixel_level_acc_num <= pixel_level_acc_num_c6;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_level_valid <= 1'b0;
    else
        pixel_level_valid <= pixel_level_valid_c6;
end

//----------------------------------------------------------------------
//  bram_a20d256_b20d256 module initialization
assign bram_a_wenb  = bram_rw_ctrl_flag_c4;
assign bram_a_addr  = (bram_rw_ctrl_flag_c4 == 1'b1) ? bram_addr_c4 : pixel_data_tmp;
assign bram_b_wenb  = pixel_data_valid_tmp_c1;
assign bram_b_addr  = (bram_rw_ctrl_flag_c3 == 1'b1) ? bram_addr_c3 : pixel_data_c2;
assign bram_b_wdata = bram_a_rdata + pixel_data_cnt_tmp;

bram_ture_dual_port
#(
    .C_ADDR_WIDTH   (8 ),
    .C_DATA_WIDTH   (20)
)
u_bram_ture_dual_port
(
    .clka   (clk            ),
    .wea    (bram_a_wenb    ),
    .addra  (bram_a_addr    ),
    .dina   (20'b0          ),
    .douta  (bram_a_rdata   ),
    .clkb   (clk            ),
    .web    (bram_b_wenb    ),
    .addrb  (bram_b_addr    ),
    .dinb   (bram_b_wdata   ),
    .doutb  (bram_b_rdata   )
);

endmodule