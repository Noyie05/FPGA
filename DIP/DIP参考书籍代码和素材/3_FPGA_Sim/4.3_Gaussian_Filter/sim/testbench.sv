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
//  Image data prepred to be processed
reg                             per_img_vsync;
reg                             per_img_href;
reg             [7:0]           per_img_gray;

//  Image data has been processed
wire                            post_img_vsync;
wire                            post_img_href;
wire            [7:0]           post_img_gray;

//----------------------------------------------------------------------
//  task and function
task image_input;
    bit             [31:0]      row_cnt;
    bit             [31:0]      col_cnt;
    bit             [7:0]       mem     [image_width*image_height-1:0];
    $readmemh("../../../../1_Matlab_Project/4.3_Gaussian_Filter/img_Gray1.dat",mem);
    
    for(row_cnt = 0;row_cnt < image_height;row_cnt++)
    begin
        repeat(5) @(posedge clk);
        per_img_vsync = 1'b1;
        repeat(5) @(posedge clk);
        for(col_cnt = 0;col_cnt < image_width;col_cnt++)
        begin
            per_img_href  = 1'b1;
            per_img_gray  = mem[row_cnt*image_width+col_cnt];
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

task image_result_check;
    bit                         frame_flag;
    bit         [31:0]          row_cnt;
    bit         [31:0]          col_cnt;
    bit         [ 7:0]          mem     [image_width*image_height-1:0];
    
    frame_flag = 0;
    $readmemh("../../../../1_Matlab_Project/4.3_Gaussian_Filter/img_Gray2.dat",mem);
    
    while(1)
    begin
        @(posedge clk);
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
                if(post_img_gray != mem[row_cnt*image_width+col_cnt])
                begin
                    $display("result error ---> row_num : %0d;col_num : %0d;pixel data : %h;reference data : %h",row_cnt+1,col_cnt+1,post_img_gray,mem[row_cnt*image_width+col_cnt]);
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
gaussian_filter_proc
#(
    .IMG_HDISP  (image_width    ),
    .IMG_VDISP  (image_height   )
)
u_gaussian_filter_proc
(
    .clk            (clk            ),
    .rst_n          (rst_n          ),
    
    //  Image data prepared to be processed
    .per_img_vsync  (per_img_vsync  ),       //  Prepared Image data vsync valid signal
    .per_img_href   (per_img_href   ),       //  Prepared Image data href vaild  signal
    .per_img_gray   (per_img_gray   ),       //  Prepared Image brightness input
    
    //  Image data has been processed
    .post_img_vsync (post_img_vsync ),       //  processed Image data vsync valid signal
    .post_img_href  (post_img_href  ),       //  processed Image data href vaild  signal
    .post_img_gray  (post_img_gray  )        //  processed Image brightness output
);

initial
begin
    per_img_vsync = 0;
    per_img_href  = 0;
    per_img_gray  = 0;
end

initial 
begin
    wait(rst_n);
    fork
        begin 
            repeat(5) @(posedge clk); 
            image_input;
        end 
        image_result_check;
    join
end 

endmodule