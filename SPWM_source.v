`timescale 1ns / 1ns

module top(
	input clk,
	output out1,
	output out2
	);
	
	wire [5:0] w_sel1;
	wire w_sel2;
    wire w_CE;
	
	data_path d1(
        .clk(w_CE),
		.sel1(w_sel1),
		.sel2(w_sel2),
		.out1(out1),
		.out2(out2)
		);
		
	controller c1(
        .clk(w_CE),
		.sel1(w_sel1),
		.sel2(w_sel2)
		);
  
   clk_enable e1(
     .clk(clk),
     .CE(w_CE)
   );
endmodule 

module data_path(
	input clk,
	input [5:0] sel1,
	input sel2,
	output out1,
	output out2
	);
	
	wire w_1, w_2;
	
	
	spwm s1(
		.clk(clk),
		.sel1(sel1),
		.out(w_1)
		);
	
	spwm s2(
		.clk(clk),
		.sel1(sel1),
		.out(w_2)
		);
		
	H_driver H1(
		.clk(clk),
		.sel2(sel2),
		.in1(w_1),
		.in2(w_2),
		.out1(out1),
		.out2(out2)
		);
	
	endmodule
		
module spwm(
	input clk,
	input [5:0] sel1,
	output out
	);
	
	reg [6:0] counter = 1;
	reg [6:0] r_duty_cycle =0;
	
	always @ (posedge clk)
		begin
			case(sel1)
				0 : r_duty_cycle <= 0;
				1 : r_duty_cycle <= 9;
				2 : r_duty_cycle <= 17;
				3 : r_duty_cycle <= 26;
				4 : r_duty_cycle <= 35;
				5 : r_duty_cycle <= 42;
				6 : r_duty_cycle <= 50;
				7 : r_duty_cycle <= 57;
				8 : r_duty_cycle <= 64;
				9 : r_duty_cycle <= 71;
				10 : r_duty_cycle <= 77;
				11 : r_duty_cycle <= 82;
				12 : r_duty_cycle <= 87;
				13 : r_duty_cycle <= 90;
				14 : r_duty_cycle <= 93;
				15 : r_duty_cycle <= 96;
				16 : r_duty_cycle <= 97;
				17 : r_duty_cycle <= 98;
				18 : r_duty_cycle <= 99; //middle 
				19 : r_duty_cycle <= 98;
				20 : r_duty_cycle <= 97;
				21 : r_duty_cycle <= 96;
				22 : r_duty_cycle <= 93;
				23 : r_duty_cycle <= 90;
				24 : r_duty_cycle <= 87;
				25 : r_duty_cycle <= 82;
				26 : r_duty_cycle <= 77;
				27 : r_duty_cycle <= 71;
				28 : r_duty_cycle <= 64;
				29 : r_duty_cycle <= 57;
				30 : r_duty_cycle <= 50;
				31 : r_duty_cycle <= 42;
				32 : r_duty_cycle <= 35;
				33 : r_duty_cycle <= 26;
				34 : r_duty_cycle <= 17;
				35 : r_duty_cycle <= 9;
				36 : r_duty_cycle <= 0;
			endcase
		end
	
	always @ (posedge clk)
		begin
			if (counter <=100)
				counter <= counter +1;
			else 
				counter <=1;
		end
	
	assign out = (counter <= r_duty_cycle) ? 1:0;
	
endmodule 

module H_driver(
	input clk,
	input sel2,
	input in1,
	input in2,
	output out1,
	output out2
	);
	
	reg r_out1, r_out2;
	
	always @ (*) 
		begin
			case(sel2)
				0 : r_out1 <= in1; 
                1 : r_out1 <= 0;
            endcase
            case(sel2)
				0 : r_out2 <= 0;
				1 :	r_out2 <= in2;
			endcase
		end
	assign out1 = r_out1;
	assign out2 = r_out2;
	
endmodule 

module controller(
	input clk,
	output [5:0] sel1,
	output sel2
	);
	
	wire [5:0] sel1_to_sel2;
	
	sel1 s1(
		.clk(clk),
		.sel1(sel1_to_sel2)
		);
		
	sel1 s2(
		.clk(clk),
		.sel1(sel1)
		);
		
	sel2 s3(
		.clk(clk),
		.sel1(sel1_to_sel2),
		.sel2(sel2)
		);
	
endmodule
	
module sel1(
	input clk,
	output [5:0] sel1
	);
	
	reg [5:0] r_sel1 =0; 
	reg [6:0] r_count =0;
    reg r_sel_pulse =0;
	
	always @ (posedge clk)
		begin
			if (r_count <= 99)
				r_count <= r_count +1;
			else
				begin
					r_count <= 0;
					r_sel_pulse <= 1;
				end
	
			if (r_sel_pulse)
				begin
					r_sel_pulse <=0;
					r_sel1 <= r_sel1 +1;
					   if (r_sel1 >36)
				            begin
				               r_sel1 <=0;
				            end
					
				end
		end
	
	assign sel1 = r_sel1;
endmodule

module sel2(
	input clk,
	input [5:0] sel1,
	output sel2
	);
	
	reg r_sel2 = 0;
	
	always @ (posedge clk) 
		begin 
			if (sel1 <= 0)
				r_sel2 <= ~r_sel2;
		end
		
	assign sel2 = r_sel2;
	
endmodule 

module clk_enable(
  input clk,
  output CE  //clock enable 
);
  
  reg [9:0] r_count = 0;
  reg r_CE;
  
  always @ (posedge clk)
    begin 
      if (r_count <= 250 )
        begin 
          r_count <= r_count +1;
          r_CE <= 0;
        end
      
      else 
        begin 
          r_count <= 0;
          r_CE <=1;
        end

    end
  
  assign CE = r_CE;
  
endmodule 
