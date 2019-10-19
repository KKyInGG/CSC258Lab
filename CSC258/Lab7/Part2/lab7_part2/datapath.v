module datapath (colour, clk, loc_in, en_x, en_y, en_c, en_ix, r_set, sx, sy, sc );
		input [6:0] loc_in;
		input [2:0] colour;
		input clk,r_set;
		input en_x, en_y, en_c, en_ix;
		reg en_iy;
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
							ix <= 2'b00;
							en_iy <= 1'b1;
						end
					else
						begin
							ix <= ix + 2'b01;
							en_iy <= 1'b0;
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

					
				
						
					
					