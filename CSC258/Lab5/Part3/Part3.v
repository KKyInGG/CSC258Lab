module Part3(SW,KEY,CLOCK_50,LEDR);
	// 0.5s for dot (between dots has 0)
	// 3*0.5s for dash
	//0.5s between multiple dots and dahses
	input CLOCK_50;
	input [9:0]SW;
	input [1:0]KEY;
	output [0:0]LEDR;
	reg [13:0]LUT;
	wire [13:0]load;
	wire [27:0] out;
	reg par_load;
	//key0 is reset,key1 is start
	//SW[2:0] is select output
	always @(negedge KEY[1], negedge KEY[0])
	begin
		if(KEY[0] == 1'b0)
			begin 
				par_load <= 1'b1;
			end
		else if (KEY[1] == 1'b0)
			begin
				par_load <= 1'b0;
			end
	 end
				
	
	always @(*)
		begin
			case(SW[2:0])
				3'b000: LUT = {6'b101010,8'd0};
				3'b001: LUT = {4'b1110, 10'd0};
				3'b010: LUT = {8'b10101110, 6'd0};
				3'b011: LUT = {10'b1010101110,4'd0};
				3'b100: LUT = {10'b1011101110, 4'd0};
				3'b101: LUT = {12'b111010101110, 2'd0};
				3'b110: LUT = {14'b11101011101110};
				3'b111: LUT = {12'b111011101010,2'd0};
				default: LUT = 14'b000000000000;
			endcase
		end
	assign load = LUT;
	
	ratedivider r3(
		.d({2'b00,26'10111110101111000001111111}),
		.clk(CLOCK_50),
		.rset(KEY[0]),
		.q(out)
	);
	
	assign enable = (out == 0) ? 1: 0;
	
	shifter_bit s(
		.load_val(load), 
		.par1(par_load), 
		.en1(enable), 
		.clk(CLOCK_50), 
		.rset(KEY[0]), 
		.out(LEDR[0])
	 );

endmodule

module ratedivider(d,clk,rset,q);
		input [27:0]d;
		input clk,rset;
		output reg [27:0]q;
		always @(posedge clk)
		begin
			if(rset == 1'b0)
				q <= 27'd0;
			else 
				begin 
					if(q == 27'd0)
						q <= d;
					else
						q <= q - 1'b1;
				end
		end	
endmodule

module shifter_bit(load_val, par1, en1, clk, rset, out);
	input [13:0]load_val;
	input par1,en1,clk,rset;
	output reg out;
	reg [13:0]q1;

	always @(posedge clk, negedge rset)
		begin
			if(rset == 1'b0)
				begin
					out <= 1'b0;
					q1 <= load_val;
				end
			else if (par1 == 1'b1)
				begin
					out <= 1'b0;
					q1 <= load_val;
				end
			else if (en1 == 1'b1)
				begin 
					out <= q1[13];
					q1 <= q1 << 1'b1;
				end
		end
endmodule
