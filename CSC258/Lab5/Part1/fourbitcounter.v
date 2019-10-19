module fourbitcounter(SW,KEY,HEX0,HEX1,LEDR);
   // KEY0 is clk
	//SW1 is Enable(t0)
	//SW0 is rset/clearb
	//Hex to display value of counter
	
	input [9:0]SW;
	input [0:0]KEY;
	input [6:0]HEX0,HEX1;
	output [0:0]LEDR;
	wire w0,w1,w2,w3,w4,w5,w6,w7;
	
	MyTFF t0(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1]),
		.q(w0)
	);
	
	MyTFF t1(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1] & w0),
		.q(w1)
	);
	
	MyTFF t2(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1] & w0 & w1),
		.q(w2)
	);
	
	MyTFF t3(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1] & w0 & w1 & w2),
		.q(w3)
	);
	
	MyTFF t4(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1] & w0 & w1 & w2 & w3),
		.q(w4)
	);
	
	MyTFF t5(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1] & w0 & w1 & w2 & w3 & w4),
		.q(w5)
	);
	
	MyTFF t6(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1] & w0 & w1 & w2 & w3 & w4 & w5),
		.q(w6)
	);
	
	MyTFF t7(
		.clk(KEY[0]),
		.rset(SW[0]),
		.t(SW[1] & w0 & w1 & w2 & w3 & w4 & w5 & w6),
		.q(w7)
	);
	
	
   sevesegments se1(
	     .s0(w0),
		  .s1(w1),
		  .s2(w2),
		  .s3(w3),
		  .m(HEX0)		 
	);
	
	sevesegments se2(
	     .s0(w4),
		  .s1(w5),
		  .s2(w6),
		  .s3(w7),
		  .m(HEX1)		 
	);

endmodule
	
module MyTFF(t,clk,rset,q);
	input t,clk,rset;
	reg q0;
	output q;
	always @(posedge clk, negedge rset)
		begin
			if(rset == 1'b0)
				q0 <= 1'b0;
			else if (t == 1'b1)
				q0 <= ~q0;
		end
	 assign q = q0;			
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