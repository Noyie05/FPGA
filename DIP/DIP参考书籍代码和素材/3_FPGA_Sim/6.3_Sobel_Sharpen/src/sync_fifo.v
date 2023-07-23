module sync_fifo
#(
    parameter C_FIFO_WIDTH      = 8 ,
    parameter C_FIFO_DEPTH      = 16
)(
    input  wire                             rst         ,
    input  wire                             clk         ,
    
    input  wire                             wr_en       ,
    input  wire [C_FIFO_WIDTH - 1:0]        din         , 
    output reg                              full        ,
    
    input  wire                             rd_en       ,
    output wire [C_FIFO_WIDTH - 1:0]        dout        ,
    output reg                              empty       ,
    output reg  [clogb2(C_FIFO_DEPTH-1):0]  data_count
);
//------------------------------------------------------
//  signals define
reg     [C_FIFO_WIDTH - 1:0]            mem [C_FIFO_DEPTH - 1:0];
reg     [clogb2(C_FIFO_DEPTH-1) - 1:0]  write_pointer;
reg     [clogb2(C_FIFO_DEPTH-1) - 1:0]  read_pointer;
wire                                    write_valid;
wire                                    read_valid;

//------------------------------------------------------
//  fifo write
always @(posedge clk)
begin
    if(rst == 1'b1)
        write_pointer <= 0;
    else
    begin
        if((wr_en == 1'b1)&&(full == 1'b0))
            write_pointer <= write_pointer + 1'b1;
        else
            write_pointer <= write_pointer;
    end
end

always @(posedge clk)
begin
    if((wr_en == 1'b1)&&(full == 1'b0))
        mem[write_pointer] <= din;
    else
        mem[write_pointer] <= mem[write_pointer];
end

always @(posedge clk)
begin
    if(rst == 1'b1)
        full <= 1'b0;
    else
    begin
        if((write_pointer == read_pointer - 1'b1)&&(wr_en == 1'b1)&&(rd_en == 1'b0))
            full <= 1'b1;
        else if((full == 1'b1)&&(rd_en == 1'b1))
            full <= 1'b0;
        else
            full <= full;
    end
end

//------------------------------------------------------
//  fifo read
always @(posedge clk)
begin
    if(rst == 1'b1)
        read_pointer <= 0;
    else
    begin
        if((rd_en == 1'b1)&&(empty == 1'b0))
            read_pointer <= read_pointer + 1'b1;
        else
            read_pointer <= read_pointer;
    end
end

assign dout = mem[read_pointer];

always @(posedge clk)
begin
    if(rst == 1'b1)
        empty <= 1'b1;
    else
    begin
        if((read_pointer == write_pointer - 1'b1)&&(rd_en == 1'b1)&&(wr_en == 1'b0))
            empty <= 1'b1;
        else if((empty == 1'b1)&&(wr_en == 1'b1))
            empty <= 1'b0;
        else
            empty <= empty;
    end
end

//------------------------------------------------------
//  fifo count
assign write_valid = wr_en & ~full;
assign read_valid  = rd_en & ~empty;

always @(posedge clk)
begin
    if(rst == 1'b1)
        data_count <= 0;
    else
    begin
        case({write_valid,read_valid})
            2'b10 : data_count <= data_count + 1'b1;
            2'b01 : data_count <= data_count - 1'b1;
            default : data_count <= data_count;
        endcase
    end
end

function integer clogb2;
    input integer depth;
    for(clogb2 = 0; depth > 0; clogb2 = clogb2 + 1)
        depth = depth >> 1;
endfunction

endmodule