module shifter(SW,KEY,LEDR);
	// represent the LoadVal[7:0]
	input [9:0]SW;
	//ASR, ShiftRight,Load_n,clk
	input [3:0]KEY;
	output [7:0]LEDR;
	wire c0;
	
	mux2to1 m0(
		.x(1'b0),
		.y(SW[7]),
		.s(KEY[3]),
		.m(c0)
	);
	
	shifter_bit s0(
	    .load_val(SW[7]),
		 .in(c0),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[7])
	);
	
	shifter_bit s1(
	    .load_val(SW[6]),
		 .in(LEDR[7]),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[6])
		 );
	
	shifter_bit s2(
	    .load_val(SW[5]),
		 .in(LEDR[6]),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[5])
	);
	
	shifter_bit s3(
	    .load_val(SW[4]),
		 .in(LEDR[5]),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[4])
	);
	
	shifter_bit s4(
	    .load_val(SW[3]),
		 .in(LEDR[4]),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[3])
	);
	
	shifter_bit s5(
	    .load_val(SW[2]),
		 .in(LEDR[3]),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[2])
	);
	
	shifter_bit s6(
	    .load_val(SW[1]),
		 .in(LEDR[2]),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[1])
	);
	
	shifter_bit s7(
	    .load_val(SW[0]),
		 .in(LEDR[1]),
		 .shift(KEY[2]),
		 .load_n(KEY[1]),
		 .clk(KEY[0]),
		 .reset_n(SW[9]),
		 .out(LEDR[0])
	);
	
endmodule

module shifter_bit(load_val, in, shift, load_n, clk, reset_n, out);
	input load_val, in, shift, load_n, clk, reset_n;
	output out;
	wire connect,connect1;
	
	mux2to1 M2(
		.x(out),
		.y(in),
		.s(shift),
		.m(connect)
	);
	
	mux2to1 M1(
		.x(load_val),
		.y(connect),
		.s(load_n),
		.m(connect1)
	);
	
	flipflop F0(
		.d(connect1),
		.q(out),
		.clock(clk),
		.reset_n(reset_n)
		);
endmodule

module flipflop(d,clock,reset_n,q);
	input d,clock,reset_n;
	reg q0;
	output q;
	always @(posedge clock)
		begin
			if(reset_n == 1'b1)
				q0 <= 0;
			else
				q0 <= d;
		end
	assign q = q0;
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
endmodule 