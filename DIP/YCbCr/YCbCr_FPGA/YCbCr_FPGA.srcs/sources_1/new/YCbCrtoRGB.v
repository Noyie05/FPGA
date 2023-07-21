module YCbCrtoRGB(
    input sys_clk,
    input sys_rst,
//per_*为预处理数据 post_*为已处理数据
//per
    input per_img_vsync,
    input per_img_href,
    input [7:0] per_img_red,
    input [7:0] per_img_green,
    input [7:0] per_img_blue,
//post
    output  post_img_vsync,
    output  post_img_href,
    output [7:0] post_img_Y,
    output [7:0] post_img_Cb,
    output wire [7:0] post_img_Cr 
);
//step1
reg [15:0] img_red_r0,img_red_r1,img_red_r2;
reg [15:0] img_green_r0,img_green_r1,img_green_r2;
reg [15:0] img_blue_r0,img_blue_r1,img_blue_r2;
always @(posedge sys_clk ) 
    begin
        img_red_r0  <=per_img_red*8'd76;
        img_red_r1  <=per_img_red*8'd43;
        img_red_r2  <=per_img_red*8'd128;
        img_green_r0<=per_img_green*8'd150;
        img_green_r1<=per_img_green*8'd84;
        img_green_r2<=per_img_green*8'd107;
        img_blue_r0 <=per_img_blue*8'd29;
        img_blue_r1 <=per_img_blue*8'd128;
        img_blue_r2 <=per_img_blue*8'd20;
    end
//step2
reg [15:0] img_Y_r0,img_Cb_r0,img_Cr_r0;
always @(posedge sys_clk ) 
    begin
        img_Y_r0 <=img_red_r0+img_green_r0+img_blue_r0;
        img_Cb_r0<=img_red_r1-img_green_r1-img_blue_r1+16'd32768;
        img_Cr_r0<=img_red_r2-img_green_r2-img_blue_r2+16'd32768;
    end
//step3
reg [7:0] img_Y_r1,img_Cb_r1,img_Cr_r1;
always @(posedge sys_clk ) 
    begin
        img_Y_r1 <=img_Y_r0[15:8];
        img_Cb_r1<=img_Cb_r0[15:8];
        img_Cr_r1<=img_Cr_r0[15:8];
    end
//step4
reg [2:0] per_img_vsync_r,per_img_href_r;
always @(posedge sys_clk or negedge sys_rst) 
    begin
        if(!sys_rst)
            begin
                per_img_vsync_r<=0;
                per_img_href_r <=0;
            end
        else
            begin
                per_img_vsync_r<={per_img_vsync_r[1:0],per_img_vsync};
                per_img_href_r <={per_img_vsync_r[1:0],per_img_href};
            end
    end

assign post_img_vsync=per_img_vsync_r[2];
assign post_img_href =per_img_href_r[2];
assign post_img_Y    =post_img_href?img_Y_r1 :8'd0;
assign post_img_Cb   =post_img_href?img_Cb_r1:8'd0;
assign post_img_Cr   =post_img_href?img_Cr_r1:8'd0;
endmodule