`timescale  1ns/1ns
module testbench;

localparam image_width  = 640;
localparam image_height = 480;
//----------------------------------------------------------------------
//  sys_clk & sys_rst
reg                             sys_clk;
reg                             sys_rst;

initial
begin
    sys_clk = 1'b0;
    forever #5 sys_clk = ~sys_clk;
end

initial
begin
    sys_rst = 1'b0;
    repeat(50) @(posedge sys_clk);
    sys_rst = 1'b1;
end

//----------------------------------------------------------------------
//  Image data prepred to be processed
reg                             per_img_vsync;
reg                             per_img_href;
reg             [7:0]           per_img_red;
reg             [7:0]           per_img_green;
reg             [7:0]           per_img_blue;

//  Image data has been processed
wire                            post_img_vsync;
wire                            post_img_href;
wire            [7:0]           post_img_Y;
wire            [7:0]           post_img_Cb;
wire            [7:0]           post_img_Cr;

//----------------------------------------------------------------------
//  task and function
task image_input;
    bit             [31:0]      row_cnt;
    bit             [31:0]      col_cnt;
    bit             [7:0]       mem     [image_width*image_height*3-1:0];
    $readmemh("../../../../Scripts/img_RGB.dat",mem);
    for(row_cnt = 0;row_cnt < image_height;row_cnt++)
    begin
        repeat(5) @(posedge sys_clk);
        per_img_vsync = 1'b1;
        repeat(5) @(posedge sys_clk);
        for(col_cnt = 0;col_cnt < image_width;col_cnt++)
        begin
            per_img_href  = 1'b1;
            per_img_red   = mem[(row_cnt*image_width+col_cnt)*3+0];
            per_img_green = mem[(row_cnt*image_width+col_cnt)*3+1];
            per_img_blue  = mem[(row_cnt*image_width+col_cnt)*3+2];
            @(posedge sys_clk);
        end
        per_img_href  = 1'b0;
    end
    per_img_vsync = 1'b0;
    @(posedge sys_clk);
    
endtask : image_input

reg                             post_img_vsync_r;

always @(posedge sys_clk)
begin
    if(sys_rst == 1'b0)
        post_img_vsync_r <= 1'b0;
    else
        post_img_vsync_r <= post_img_vsync;
end

wire                            post_img_vsync_pos;
wire                            post_img_vsync_neg;

assign post_img_vsync_pos = ~post_img_vsync_r &  post_img_vsync;
assign post_img_vsync_neg =  post_img_vsync_r & ~post_img_vsync;

task image_result_check;
    bit                         frame_flag;
    bit         [31:0]          row_cnt;
    bit         [31:0]          col_cnt;
    bit         [ 7:0]          mem     [image_width*image_height*3-1:0];
    
    frame_flag = 0;
    $readmemh("../../../../Scripts/img_YCbCr.dat",mem);
    while(1)
    begin
        @(posedge sys_clk);
        if(post_img_vsync_pos == 1'b1)
        begin
            frame_flag = 1;
            row_cnt = 0;
            col_cnt = 0;
            $display("##############image result check begin##############");
        end
        
        if(frame_flag == 1'b1)
        begin
            if(post_img_href == 1'b1)
            begin
                if((post_img_Y != mem[(row_cnt*image_width+col_cnt)*3+0])||(post_img_Cb != mem[(row_cnt*image_width+col_cnt)*3+1])||(post_img_Cr != mem[(row_cnt*image_width+col_cnt)*3+2]))
                begin
                    $display("result error ---> row_num : %0d;col_num : %0d;pixel data(y cb cr) : (%h %h %h);reference data(y cb cr) : (%h %h %h)",row_cnt+1,col_cnt+1,post_img_Y,post_img_Cb,post_img_Cr,mem[(row_cnt*image_width+col_cnt)*3+0],mem[(row_cnt*image_width+col_cnt)*3+1],mem[(row_cnt*image_width+col_cnt)*3+2]);
                end
                col_cnt = col_cnt + 1;
            end
            
            if(col_cnt == image_width)
            begin
                col_cnt = 0;
                row_cnt = row_cnt + 1;
            end
        end
        
        if(post_img_vsync_neg == 1'b1)
        begin
            frame_flag = 0;
            $display("##############image result check end##############");
        end
    end
endtask : image_result_check

//----------------------------------------------------------------------
RGB2YCbCr RGB2YCbCr
(
    //  global clock
    .sys_clk            (sys_clk            ),
    .sys_rst          (sys_rst          ),
    
    //  Image data prepred to be processed
    .per_img_vsync  (per_img_vsync  ),
    .per_img_href   (per_img_href   ),
    .per_img_red    (per_img_red    ),
    .per_img_green  (per_img_green  ),
    .per_img_blue   (per_img_blue   ),
    
    //  Image data has been processed
    .post_img_vsync (post_img_vsync ),
    .post_img_href  (post_img_href  ),
    .post_img_Y     (post_img_Y     ),
    .post_img_Cb    (post_img_Cb    ),
    .post_img_Cr    (post_img_Cr    )
);

initial
begin
    per_img_vsync = 0;
    per_img_href  = 0;
    per_img_red   = 0;
    per_img_green = 0;
    per_img_blue  = 0;
end

initial 
begin
    wait(sys_rst);
    fork
        begin 
            repeat(5) @(posedge sys_clk); 
            image_input;
        end 
        image_result_check;
    join
end 

endmodule