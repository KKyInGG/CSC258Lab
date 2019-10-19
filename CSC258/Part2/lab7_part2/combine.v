// Part 2 skeleton

module part2
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    
    // Instansiate datapath
	// datapath d0(...);

    // Instansiate FSM control
    // control c0(...);
	 combine c1(
			.SW(SW[9:0]),
			.KEY(KEY[3:0]),
			.C(CLOCK_50),
			.fx(x),
			.fy(y),
			.fc(c),
			.fe(writeEN)
			);
    
endmodule

module combine(SW,KEY,C,fx,fy,fc,fe);
	input [9:0] SW;
	input [3:0] KEY;
	input c;
	output [7:0] fx;
	output [6:0] fy;
	output [2:0] fc;
	output fe;
	
	wire x1,y1,z1,start1;
	
	controller c1(
		.rset(KEY[0]),
		.clk(c),
		.go(KEY[3]),
		.draw(KEY[1]),
		.lx(x1),
		.ly(y1),
		.lc(z1),
		.start(start1)
	);
	
	datapath d1(
		.colour(SW[9:7]), 
		.clk(c), 
		.loc_in(SW[6:0]), 
		.en_x(x1), 
		.en_y(y1), 
		.en_c(z1), 
		.en_ix(start1), 
		.r_set(KEY[0]), 
		.sx(fx), 
		.sy(fy), 
		.sc(fc)
		);
		
	assign fe = KEY[1];
		
endmodule

module controller (rset, clk, go, draw, lx, ly, lc, start);
	input rset,clk,go,draw;
	output reg lx,ly,lc,start;

	reg [2:0] current,next;
	
	localparam Load_x_wait = 3'd0,
				  Load_x = 3'd1,
				  Load_y_wait = 3'd2,
				  Load_y = 3'd3,
				  Draw = 3'd4;
	
	 always @(*)
		begin
			case(current)
				Load_x_wait: next = go ? Load_x : Load_x_wait;
				Load_x : next = go ? Load_x : Load_y_wait;
				Load_y_wait : next = go ? Load_y_wait : Load_y;
				Load_y : next = draw ? Load_y : Draw;
				Draw : next = go ? Draw : Load_x_wait;
				default: next = Load_x_wait;
			endcase
		end
		
	
	  always @(*) 
		begin
			lx = 1'b0;
			ly = 1'b0;
			lc = 1'b0;
			start = 1'b0;
			
			case(current)
				Load_x_wait: lx = 1'b1;
				Load_y_wait:
					begin
						ly = 1'b1;
						lc = 1'b1;
					end
				Draw: start = 1'b1;
			endcase
	  end
	  
	  always @(posedge clk)
			begin
				if(!rset)
					current <= Load_x_wait;
				else
					current <= next;
			end
endmodule

				
	
module datapath (colour, clk, loc_in, en_x, en_y, en_c, en_ix, r_set, sx, sy, sc );
		input [6:0] loc_in;
		input [2:0] colour;
		input clk,r_set;
		input en_x, en_y, en_c, en_ix;
		output [7:0] sx;
		output [6:0]sy;
		output [2:0] sc;
		
		reg [7:0] x;
		reg [6:0] y;
		reg [2:0] c;	
		
		always @(posedge clk)
			begin
				if(!r_set)
					begin
						x <= 8'd0;
						y <= 7'd0;
						c <= 3'd0;
					end
				else
					begin
						if(en_x)
							x <= {1'b0, loc_in};
						if(en_y)
							y <= {loc_in};
						if (en_c)
							c <= colour;
					end
			end
	  
	  reg [1:0] ix;
	  reg [1:0] iy;
	  reg en_iy;
			
	  always @(posedge clk)
			begin
				if(!r_set)
					begin
						ix <= 2'd0;
						iy <= 2'd0;
					end
				if(en_ix)
					if (ix == 2'b11)
					   begin
							en_iy <= 1'b1;
							ix <= 2'b00;
						end
					else
						begin
						   en_iy <= 1'b0;
							ix <= ix + 2'b01;
						end
			end
			
		  
		  always @(posedge clk)
			begin
				if(!r_set)
					begin
						ix <= 2'd0;
						iy <= 2'd0;
					end
				if(en_iy)
					if (iy == 2'b11)
					   begin
							iy <= 2'b00;
						end
					else
						iy <= iy + 2'b01;
			end
			
			assign sx = x + ix;
			assign sy = y + iy;
			assign sc = c;
			
endmodule

