module Part2(SW, CLOCK_50, HEX0);
   //SW[9] reset, SW[7]parellel
	//	SW[6:3] loading
	//SW[1:0] switches cases
	input [9:0]SW;
	input CLOCK_50;
	output [6:0]HEX0;
	wire [27:0]out1,out2,out3,out4;
	wire [3:0]r;
	reg enable;
	
		ratedivider r1(
		.d({27'b0, 1'b1}),
		.clk(CLOCK_50),
		.rset(SW[9]),
		.q(out1)
	);
	
		ratedivider r2(
		.d({2'b00, 26'd49999999}),
		.clk(CLOCK_50),
		.rset(SW[9]),
		.q(out2)
	);
	
		ratedivider r3(
		.d({1'b0, 27'd99999999}),
		.clk(CLOCK_50),
		.rset(SW[9]),
		.q(out3)
	);
	
			ratedivider r4(
		.d({28'd199999999}),
		.clk(CLOCK_50),
		.rset(SW[9]),
		.q(out4)
	);
	
	
	always @(*)
		begin
			case(SW[1:0])
				2'b00: enable = (out1 == 0) ? 1: 0;
				2'b01: enable = (out2 == 0) ? 1: 0;
				2'b10: enable = (out3 == 0) ? 1: 0;
				2'b11: enable = (out4 == 0) ? 1: 0;
				default: enable = 1'b0;
			endcase
		end
	
	displaycounter counter(
		.d1(SW[6:3]),
		.clk1(CLOCK_50),
		.rset1(SW[9]),
		.par1(SW[7]),
		.en1(enable),
		.q1(r)
	);

	
	sevesegments hex0(
		.s0(r[0]),
		.s1(r[1]),
		.s2(r[2]),
		.s3(r[3]),
		.m(HEX0)
	);

endmodule

module displaycounter(d1,clk1,rset1,par1,en1,q1);
	   input [3:0]d1;
		input clk1,rset1,par1,en1;
		output reg [3:0]q1;
		
		always @(posedge clk1, negedge rset1)
		begin
			if(rset1 == 1'b0)
				q1 <= 4'b0000;
			else if (par1 == 1'b1)
				q1 <= d1;
			else if (en1 == 1'b1)
				begin 
					if(q1 == 4'b1111)
						q1 <= 4'b0000;
					else
						q1 <= q1 + 1'b1;
				end
		end
endmodule


module ratedivider(d,clk,rset,q);
		input [27:0]d;
		input clk,rset;
		output reg [27:0]q;
		always @(posedge clk)
		begin
			if(rset == 1'b0)
				q <= d;
			else
				begin 
					if(q == 27'd0)
						q <= d;
					else
						q <= q - 1'b1;
				end
		end	
endmodule

module sevesegments(s0, s1, s2, s3, m);
    input s0, s1, s2, s3;
    output [6:0] m;
	 
    assign m[0] = ~s3 &  ~s2 &  ~s1 & s0
							| ~s3 & s2 & ~s1 & ~s0
							| s3 & s2 & ~s1 & s0 
							| s3 & ~s2 & s1 & s0;
					
	 assign m[1] = ~s3 &  s2 &  ~s1 & s0
							| s2 & s1 & ~s0
							|  s3 & s2 & ~s0
							|  s3 & s1 & s0;
    
	 assign m[2] = ~s3 & ~s2&  s1 & ~s0
							| s3 & s2 & s1 
							| s3 & s2 & ~s0; 
 
    assign m[3] = ~s3 &  s2 &  ~s1 & ~s0 
							| s3 & ~s2 & s1 & ~s0 
							| ~s2 & ~s1 & s0
							| s2 & s1 & s0;
 
    assign m[4] = ~s3 & s0 
							| ~s3 & s2 & ~s1
							| ~s2 & ~s1 & s0;
 
    assign m[5] = ~s3 &  ~s2 & s0
							| ~ s3 & ~s2 & s1
							|~ s3 & s1 & s0
							| s3 & s2 & ~s1 & s0;
					
	 assign m[6] = ~s3 &  ~s2 &  ~s1
							| ~s3 & s2 & s1 & s0
							| s3 & s2 & ~s1 & ~s0;
endmodule

