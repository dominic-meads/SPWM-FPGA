  
`timescale 1ns / 1ns

module tb;
	reg clk;
	wire out1,out2;
	
	always #4 clk = ~clk; 
	
	top uut(clk,out1,out2);
	
	initial
		begin
			clk=0;
			#1000000000
			$finish;
			
		end
endmodule
