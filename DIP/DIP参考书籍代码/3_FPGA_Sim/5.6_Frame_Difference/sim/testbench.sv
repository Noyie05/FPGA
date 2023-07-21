`timescale  1ns/1ns
module testbench;

localparam image_width  = 640;
localparam image_height = 480;
//----------------------------------------------------------------------
//  clk & rst_n
reg                             clk;
reg                             rst_n;

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial
begin
    rst_n = 1'b0;
    repeat(50) @(posedge clk);
    rst_n = 1'b1;
end

//----------------------------------------------------------------------
//  Image data prepred to be processd
reg                             per_img_vsync;
reg                             per_img_href;
reg             [7:0]           per_img_red;
reg             [7:0]           per_img_green;
reg             [7:0]           per_img_blue;

//  Image data has been processd
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
    $readmemh("../source_files/image_rgb.txt",mem);
    
    for(row_cnt = 0;row_cnt < image_height;row_cnt++)
    begin
        repeat(5) @(posedge clk);
        per_img_vsync = 1'b1;
        repeat(5) @(posedge clk);
        for(col_cnt = 0;col_cnt < image_width;col_cnt++)
        begin
            per_img_href  = 1'b1;
            per_img_red   = mem[(row_cnt*image_width+col_cnt)*3+0];
            per_img_green = mem[(row_cnt*image_width+col_cnt)*3+1];
            per_img_blue  = mem[(row_cnt*image_width+col_cnt)*3+2];
            @(posedge clk);
        end
        per_img_href  = 1'b0;
    end
    per_img_vsync = 1'b0;
    @(posedge clk);
    
endtask : image_input

reg                             post_img_vsync_r;

always @(posedge clk)
begin
    if(rst_n == 1'b0)
        post_img_vsync_r <= 1'b0;
    else
        post_img_vsync_r <= post_img_vsync;
end

wire                            post_img_vsync_pos;
wire                            post_img_vsync_neg;

assign post_img_vsync_pos = ~post_img_vsync_r &  post_img_vsync;
assign post_img_vsync_neg =  post_img_vsync_r & ~post_img_vsync;

task image_output;
    integer                     file_id;
    bit                         frame_flag;
    bit             [31:0]      col_cnt;
    
    frame_flag = 0;
    
    while(1)
    begin
        @(posedge clk);
        if(post_img_vsync_pos == 1'b1)
        begin
            frame_flag = 1;
            col_cnt = 0;
            file_id = $fopen("../print_files/image_YCbCr.txt","w");
        end
        
        if(frame_flag == 1'b1)
        begin
            if(post_img_href == 1'b1)
            begin
                $fwrite(file_id,"%h %h %h ",post_img_Y,post_img_Cb,post_img_Cr);
                col_cnt = col_cnt + 1;
            end
            
            if(col_cnt == image_width)
            begin
                col_cnt = 0;
                $fwrite(file_id,"\n");
            end
        end
        
        if(post_img_vsync_neg == 1'b1)
        begin
            $fclose(file_id);
            frame_flag = 0;
        end
    end
endtask : image_output

//----------------------------------------------------------------------
VIP_RGB888_YCbCr444 u_VIP_RGB888_YCbCr444
(
    //  global clock
    .clk            (clk            ),
    .rst_n          (rst_n          ),
    
    //  Image data prepred to be processd
    .per_img_vsync  (per_img_vsync  ),
    .per_img_href   (per_img_href   ),
    .per_img_red    (per_img_red    ),
    .per_img_green  (per_img_green  ),
    .per_img_blue   (per_img_blue   ),
    
    //  Image data has been processd
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
    wait(rst_n);
    fork
        begin 
            repeat(5) @(posedge clk); 
            image_input;
        end 
        image_output;
    join
end 

endmodule