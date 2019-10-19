module ram32x4top(SW,KEY,HEX0,HEX2,HEX4,HEX5);
        input [9:0] SW;
 	input [0:0] KEY;
        output [6:0] HEX0,HEX2,HEX4,HEX5;
	wire[4:0] s;

	ram32x4 r1(
	   .address(SW[8:4]),
           .clock(KEY[0]),
           .data(SW[3:0]),
           .wren(SW[9]),
           .q(s)
	);
        
	
 	sevesegments s0(
   	    .s0(s[0]),
            .s1(s[1]), 
            .s2(s[2]), 
            .s3(s[3]), 
            .m(HEX0)
	);
	
	 	sevesegments s1(
   	    .s0(SW[0]),
            .s1(SW[1]), 
            .s2(SW[2]), 
            .s3(SW[3]), 
            .m(HEX2)
	);

	 	sevesegments s2(
   	    .s0(SW[4]),
            .s1(SW[5]), 
            .s2(SW[6]), 
            .s3(SW[7]), 
            .m(HEX4)
	);

 	sevesegments s3(
   	    .s0(SW[4]),
            .s1(SW[5]), 
            .s2(SW[6]), 
            .s3(SW[7]), 
            .m(HEX5)
	);
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
