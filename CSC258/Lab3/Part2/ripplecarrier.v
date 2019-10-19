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
