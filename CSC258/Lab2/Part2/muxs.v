module muxs(SW, LEDR);
    input [9:0] SW;
    output [9:0] LEDR;
	 
    mux4to1 u0(
        .x(SW[0]),
        .w(SW[1]),
        .v(SW[2]),
		  .u(SW[3]),
		  .s0(SW[9]),
		  .s1(SW[8]),
        .m(LEDR[0])
        );
		  
endmodule

module mux4to1(x,w,v,u,s0,s1,m);
	input x,w,v,u,s0,s1;
	output m;
	wire mux2a, mux2b;
	
	mux2to1 a(
		.v(u),
		.b(v),
		.n(s0),
		.o(mux2a)
		);
		
	mux2to1 b(
		.v(w),
		.b(x),
		.n(s0),
		.o(mux2b)
		);
	
	mux2to1 c(
		.v(mux2a),
		.b(mux2b),
		.n(s1),
		.o(m)
	);
	

endmodule

module mux2to1(v, b, n, o);
    input v; //selected when s is 0
    input b; //selected when s is 1
    input n; //select signal
    output o; //output
  
    assign o = n & b | ~n & v;
endmodule 
