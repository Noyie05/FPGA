`timescale 10ms/10ms
module Running_Light_top ();
    
    reg [1:0] sel;
    reg sys_clk;
    reg sys_rst;
    wire [7:0] Y_out;

    initial 
     begin
        sys_clk=0;
        sel=0;
        sys_rst=0;
        #10 sys_rst=~sys_rst;   
     end

     always #1 sys_clk=~sys_clk;

     Running_Light Running_Light(
         .S(sel),
         .clk(sys_clk),
         .rst(sys_rst),
         .Y(Y_out)
     );

endmodule //Running_Light_top