module full_adder
(input a,b,cin,
output s,cout);
	assign {cout, s} = a+b+cin;
endmodule


module decoder_hex_10(
	input [3:0]x,
	output reg [0:6]h);
	
	always @(x)
		case (x)
			0: h = 7'b1000000;
			1: h = 7'b1111001;
			2: h = 7'b0100100;
			3: h = 7'b0110000;
			4: h = 7'b0011001;
			5: h = 7'b0010010;
			6: h = 7'b0000010;
			7: h = 7'b1111000;
			8: h = 7'b0000000;
			9: h = 7'b0011000;
			default: h = 7'b1111111;
		endcase
endmodule

module decoder_hex_10_normal(
	input [3:0]x,
	output reg [0:6]h);
	
	always @(x)
		case (x)
			0: h = 7'b0000000;
			1: h = 7'b0000001;
			2: h = 7'b0000010;
			3: h = 7'b0000011;
			4: h = 7'b0000100;
			5: h = 7'b0000101;
			6: h = 7'b0000110;
			7: h = 7'b0000111;
			8: h = 7'b0001000;
			9: h = 7'b0001001;
			default: h = 7'b1111111;
		endcase
endmodule

module array_multiplier_4_bits
(input [7:0] SW, output [0:6] HEX5, HEX4, HEX2, HEX0);
wire [3:0] A, B;
wire [7:0] P;
wire cout1, cout2,cout3,cout4,cout5,cout6,cout7,cout8,cout9,cout10,cout11;
wire s_fa12, s_fa13, s_fa14,s_fa22, s_fa23,s_fa24;
assign A = SW[7:4];
assign B = SW[3:0];
assign P[0] = A[0]&B[0];
// Pierwsza warstwa
full_adder fa11(A[1]&B[0], A[0]&B[1], 1'b0, P[1],cout1);
full_adder fa12(A[2]&B[0], A[1]&B[1], cout1, s_fa12,cout2);
full_adder fa13(A[3]&B[0], A[2]&B[1], cout2, s_fa13, cout3);
full_adder fa14(1'b0, A[3]&B[1], cout3, s_fa14,cout4);
// Druga warstwa
full_adder fa21(s_fa12, A[0]&B[2],1'b0, P[2], cout5);	
full_adder fa22(s_fa13, A[1]&B[2],cout5, s_fa22, cout6);	
full_adder fa23(s_fa14, A[2]&B[2],cout6, s_fa23, cout7);	
full_adder fa24(cout4, A[3]&B[2],cout7, s_fa24, cout8);	
// Trzecia warstwa
full_adder fa31(s_fa22, A[0]&B[3],1'b0, P[3], cout9);	
full_adder fa32(s_fa23, A[1]&B[3],cout9, P[4], cout10);	
full_adder fa33(s_fa24, A[2]&B[3],cout10, P[5], cout11);	

full_adder fa34(cout8, A[3]&B[3],cout11, P[6], P[7]);
decoder_hex_10_normal ha(A,HEX2);
decoder_hex_10_normal hb(B,HEX0);
decoder_hex_10_normal hp1(P/10,HEX5);
decoder_hex_10_normal hp2(P%10,HEX4);


endmodule
