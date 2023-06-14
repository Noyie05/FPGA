`timescale 1ns/1ns

module horse_lights_tb();
	reg [1:0]S;
	reg clk;
	wire [7:0]Y;
	
horse_lights horse_lights
(
	.S(S),
	.clk(clk),
	.Y(Y)
);

	initial
	begin
	
		clk=0;
		S=2'b00;
		rst=0;
		#10 rst=~rst;
		#400   	S=2'b01;
		#200	S=2'b10;
		#200 	S=2'b11;

		#100 $stop;                       
		$display("Running testbench");                       
	end 
	
	always                                                                 
	begin                                                  
		#5 clk=~clk;                                         
	end   
	
endmodule
	