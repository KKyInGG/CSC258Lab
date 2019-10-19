module ALU(SW,KEY,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
		input [7:0] SW;
		input [2:0] KEY;
		output [7:0] LEDR;
	   output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
		wire[4:0] adder1,adder2;

		sevesegments h0(
        .s0(SW[0]),
        .s1(SW[1]),
        .s2(SW[2]),
		  .s3(SW[3]),
		  .m(HEX0[6:0])
        );
		
		sevesegments h1(
        .s0(0),
        .s1(0),
        .s2(0),
		  .s3(0),
		  .m(HEX1[6:0])
        );
		 
		 sevesegments h2(
        .s0(SW[4]),
        .s1(SW[5]),
        .s2(SW[6]),
		  .s3(SW[7]),
		  .m(HEX2[6:0])
        );
		  
		  
		  sevesegments h3(
        .s0(0),
        .s1(0),
        .s2(0),
		  .s3(0),
		  .m(HEX3[6:0])
        );
		

		 ripplecarrier add1(
			.SW({0,SW[7:0]}),
			.LEDR(adder1[4:0])
		 );
		 
		 
		 ripplecarrier add2(
			.SW({0,SW[7:4],4'b0001}),
			.LEDR(adder2[4:0])
		 );
		
		reg [7:0] ALUout;
		
		always @(*)
		begin
			case(KEY[2:0])
				3'b000: ALUout = SW[7:0];
				3'b001: ALUout = {SW[7:4] ^ SW[3:0], SW[7:4] | SW[3:0]};
				3'b010: ALUout = {3'b000,adder1[4:0]};
				3'b011: ALUout = SW[7:4] + SW[3:0];
				3'b100: ALUout = {3'b000,adder2[4:0]};
				3'b101: ALUout = {SW[7:4] || SW[3:0]};
				default: ALUout = 0;
			endcase
		end
		assign LEDR[7:0] = ALUout[7:0];
		
		sevesegments h4(
        .s0(ALUout[0]),
        .s1(ALUout[1]),
        .s2(ALUout[2]),
		  .s3(ALUout[3]),
		  .m(HEX4[6:0])
        );
		
		 sevesegments h5(
        .s0(ALUout[4]),
        .s1(ALUout[5]),
        .s2(ALUout[6]),
		  .s3(ALUout[7]),
		  .m(HEX5[6:0])
        );
		 
endmodule
// adding 0 in front of any positive number is called sign-extension and does nt change the 
// value of the number

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

module ripplecarrier(SW,LEDR);
	 input [8:0] SW;
    output [4:0] LEDR;
	 wire c1, c2, c3;
	 
	  fulladder a0(
        .A(SW[4]),
        .B(SW[0]),
        .cin(SW[8]),
		  .S(LEDR[0]),
		  .cout(c1)
     );
	  
	  
	  fulladder a1(
        .A(SW[5]),
        .B(SW[1]),
        .cin(c1),
		  .S(LEDR[1]),
		  .cout(c2)
     );
	 
	 
	  fulladder a2(
        .A(SW[6]),
        .B(SW[2]),
        .cin(c2),
		  .S(LEDR[2]),
		  .cout(c3)
     );
	  
	  
	  fulladder a3(
        .A(SW[7]),
        .B(SW[3]),
        .cin(c3),
		  .S(LEDR[3]),
		  .cout(LEDR[4])
     );
endmodule

module fulladder(A,B,cin,S,cout);
	input A,B,cin;
	output S,cout;
	assign cout = A & B | B & cin | A & cin;
	assign S = ~A & ~B & cin | ~A & B & ~cin | A & B & cin | A & ~B & ~cin ;
endmodule
