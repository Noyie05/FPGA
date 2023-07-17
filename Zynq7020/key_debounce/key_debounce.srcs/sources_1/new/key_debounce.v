module key_debounce (
    input  sys_clk,
    input  sys_rst,
    input  bottom_in,
    output reg button_pos,
    output reg button_neg,
    output reg buttom_out 
);

//Parameter 
parameter N=32,
          FREQ=50,
          Max_time=20;

localparam Timer_max_val=Max_time*1000*FREQ;

endmodule //key_debounce