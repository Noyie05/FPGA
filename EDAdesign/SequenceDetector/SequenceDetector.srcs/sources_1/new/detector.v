module detector 
(
    input x,
    input sys_clk,
    input sys_rst,

    output z    
);

reg [2:0] state;
wire z;

parameter Idle =3'b0,
          A=3'd1,
          B=3'd2,
          C=3'd3,
          D=3'd4,
          E=3'd5,
          F=3'd6,
          G=3'd7;

assign z=(state==D&&x==0)?1:0;

always @(posedge sys_clk or negedge sys_rst) 
    begin
        if(!sys_rst)
            begin
                state<=Idle;
            end
        else
            case (state)
                Idle:
                if(x==1)
                    state<=A;
                else
                    state<=Idle;
                A:
                if(x==0)
                    state<=B;
                else
                    state<=A;
                B:
                if(x==0)
                    state<=C; 
                else
                    state<=F;
                C:
                if(x==1)
                    state<=D;
                else
                    state<=G;
                D:
                if(x==0)
                    state<=E;
                else
                    state<=A;
///////////////////////////////////////////
                E:
                if(x==0)
                    state<=C;
                else
                    state<=A;
                F:
                if(x==0)
                    state<=A;
                else
                    state<=B;
                G:
                if(x==1)
                    state<=F;
                else
                    state<=B;
                default :state<=Idle;
            endcase
    end
        

endmodule //detector