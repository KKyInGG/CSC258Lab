module part3(SW,KEY,fx,fy,fc,out_state,en1,en2,adder);
	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] fx;
	output [6:0] fy;
	output [2:0] fc;
	output [2:0] out_state;
	output en1,en2;
	output [3:0]adder;
	wire x1,y1,z1,start1,e1,i1;
	
	controller c1(
		.rset(KEY[0]),
		.clk(KEY[2]),
		.go(KEY[3]),
		.draw(KEY[1]),
		.lx(x1),
		.ly(y1),
		.lc(z1),
		.start(start1),
		.out_erase(e1),
		.out_update(i1),
		.state(out_state)
	);
	
	datapath d1(
		.colour(SW[9:7]), 
		.clk(KEY[2]), 
		.loc_in(SW[6:0]), 
		.en_x(x1), 
		.en_y(y1), 
		.en_c(z1), 
		.en_ix(start1), 
		.r_set(KEY[0]), 
		.erase(e1),
		.in_update(i1),
		.sx(fx), 
		.sy(fy), 
		.sc(fc)
		);
		
		
endmodule

module controller (rset, clk, go, draw, lx, ly, lc, start, out_erase,out_update,state);
	input rset,clk,go,draw;
	output reg lx,ly,lc,start,out_erase,out_update;
	output [2:0]state;
	wire [3:0]erase;
	
	
	framcounter ff(
		.start(draw), 
		.clock(clk), 
		.r_set(rset), 
		.q1(erase));
	assign e3 = erase;
			
   assign enable_1 = (erase == 4'b0000) ? 0:1;
	assign enable_2 = (erase == 4'd1) ? 0:1;
	
	reg [2:0] current,next;
	
	localparam Load_x_wait = 3'd0,
				  Load_x = 3'd1,
				  Load_y_wait = 3'd2,
				  Load_y = 3'd3,
				  Draw = 3'd4,
				  Draw2 = 3'd5,
				  Update = 3'd6;
	
	 always @(*)
		begin
			case(current)
				Load_x_wait: next = go ? Load_x : Load_x_wait;
				Load_x : next = go ? Load_x : Load_y_wait;
				Load_y_wait : next = go ? Load_y_wait : Load_y;
				Load_y : next = draw ? Load_y : Draw;
				Draw : next = enable_2 ? Draw : Draw2;
				Draw2: next = Update;
				Update: next = enable_1 ? Update: Draw;
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
				Draw: 
					begin
						start = 1'b1;
						out_erase = 1'b0;
						out_update = 1'b0;
					end			
				Draw2:
					begin
				      start = 1'b1;
					   out_erase = 1'b1;
						out_update = 1'b0;
					end
				Update:
					begin
						start = 1'b0;
						out_update = 1'b1;
					end
			endcase
	  end
	  
	  always @(posedge clk)
			begin
				if(!rset)
					current <= Load_x_wait;
				else
					current <= next;
			end
		assign state = current;
endmodule

module drawer(x,y,c,clk,erase,r_set, en_ix,sx,sy,sc);
	input [7:0] x;
	input [6:0] y;
	input [2:0] c;
	input clk, r_set, en_ix;
	output [7:0] sx;
	output [6:0] sy;
	output [2:0] sc;
	reg [1:0] ix;
	reg [1:0] iy;
	reg en_iy;
	input erase;
	reg [2:0] c_wire;
			
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
			

			always @ (*)
				begin
					if(erase)
						c_wire = 3'b000;
					else
						c_wire = c;
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
			assign sc = c_wire;
endmodule

				
	
module datapath (colour, clk, loc_in, en_x, en_y, en_c, en_ix, in_update, erase, r_set, sx, sy, sc );
		input [6:0] loc_in;
		input [2:0] colour;
		input clk,r_set, in_update,erase;
		input en_x, en_y, en_c, en_ix;
		output [7:0] sx;
		output [6:0]sy;
		output [2:0] sc;
		wire [3:0] w1;
		wire [7:0] x2;
		wire [6:0] y2;
		
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


		xcounter xx(
			.clk(clk), 
			.enable_x(in_update), 
			.orgin_x(x), 
			.out_x(x2), 
			.r_set(r_set));
		
		ycounter yy(
			.clk(clk), 
			.enable_y(in_update),
			.orgin_y(y), 
			.out_y(y2), 
			.r_set(r_set));

		drawer dd(
			.x(x2),
			.y(y2), 
			.c(c),
			.clk(clk), 
			.erase(erase), 
			.r_set(r_set),
			.en_ix(en_ix), 
			.sx(sx),
			.sy(sy),
			.sc(sc));
endmodule


module xcounter (clk, r_set,enable_x, orgin_x, out_x);
	input clk,r_set,enable_x;
	input [7:0]  orgin_x;
	reg right_x;
	output reg [7:0]out_x;
	
	always @(posedge clk)
		begin
			if(r_set == 1'b0)
				right_x <= 1'b1;
				out_x <= 8'd0;
			if(enable_x)
				begin 
					if(orgin_x == 8'b10011100)
						right_x <= 1'b0;
					if(orgin_x == 8'd0)
						right_x <= 1'b1;
					if(right_x)
						out_x <= orgin_x + 1;
					if(right_x == 1'b0)
						out_x <= orgin_x - 1;
				end
			else
				out_x <= orgin_x;

		end
endmodule

module ycounter (clk, enable_y,r_set,orgin_y,out_y);
	input enable_y,clk,r_set;
	input [6:0] orgin_y;
	output reg [6:0] out_y;
	reg up_y;
	
always @(*)
		begin
			if (r_set == 1'b0)
				 up_y <= 1'b0;
				 out_y <= 7'b0111100;
			if(enable_y)
				begin 
					if(orgin_y == 7'b1110100)
						up_y <= 1'b0;
					if(orgin_y == 8'd0)
						up_y <= 1'b1;
					if(up_y)
						out_y <= orgin_y + 1;
					if(up_y == 1'b0)
						out_y <= orgin_y - 1;
				end
			else
				out_y <= orgin_y;
		end
endmodule

module framcounter(start,clock,r_set,q1);
		input start;
		input clock,r_set;
		output reg [3:0]q1;
		wire [19:0] w1;
		wire enable_1;
		
		delaycounter d1(
			.en(start),
			.clk(clock),
			.rset(r_set),
			.q(w1)
		);
		
		assign enable_1 = (w1 == 20'd0) ? 1:0;
		
		always @(posedge clock)
		begin
			if(r_set == 1'b0)
				q1 <= 4'd1;
			if(enable_1)
				begin 
					if(q1 == 4'd0)
						q1 <= 4'd1;
					else
						q1 <= q1 - 1'b1;
				end
		end	
endmodule

module delaycounter(en,clk,rset,q);
		input en;
		input clk,rset;
		output reg [19:0]q;
		always @(posedge clk)
		begin
			if(rset == 1'b0)
				q <= 20'd1;
			if (en == 1'b1)
				begin 
					if(q == 20'd0)
						q <= 20'd1;
					else
						q <= q - 1'b1;
				end
		end	
endmodule
