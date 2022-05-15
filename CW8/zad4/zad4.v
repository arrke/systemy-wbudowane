module adder_N_bits #(parameter N=8)
(input [N-1:0] A, B, input cin,
output [N-1:0] s, output cout);
	assign {cout, s} = A+B+cin;
endmodule


module register_N_bits_aclr_ena
#(parameter N=8)
(input clk,aclr,ena,input [N-1:0] D,
output reg[N-1:0] Q);
always @(posedge clk,negedge aclr)
if (~aclr) 
Q <= {N{1'b0}};
else if (ena)
Q <= D;
else
                              Q <= Q;
endmodule


module multiplier_N_bits #(parameter N=8)
(input [N-1:0] a,b, output [2*N-1:0] p);
	wire [7:0] m[7:0];
	wire [7:0] s[1:7];
	wire cout[1:7];
	genvar i;
	generate
		for(i=0; i<N; i=i+1) begin:bl1
		assign m[i] = a & {N{b[i]}};
		end
	endgenerate
	adder_N_bits #(N) ex1({1'b0,m[0][N-1:1]},m[1],1'b0,s[1],cout[1]);
	generate
		for(i=2; i<N; i=i+1) begin:bl2
		adder_N_bits #(N) 
		exi({cout[i-1],s[i-1][N-1:1]},m[i],1'b0,s[i],cout[i]);
		end
	endgenerate
	assign p[0] = m[0][0];
	generate
		for(i=1;i<N-1;i=i+1) begin:bl3
		assign p[i] = s[i][0];
		end
	endgenerate
	assign p[2*N-2:N-1] = s[N-1];
	assign p[2*N-1] = cout[N-1];
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


module zad4
(input [9:0]SW,
 input [1:0] KEY,
 output [0:6] HEX3, HEX2, HEX1, HEX0,
 output reg [7:0] LEDR);
 
 assign clk = KEY[1];
 assign aclr = KEY[0];
 assign EA = SW[9];
 assign EB = SW[8];
 wire [7:0] A,B, Data;
 wire [15:0] M,P;
 
 assign Data = SW[7:0];
  always @(*)
	if(SW[9] && !SW[8]) LEDR = A;
	else if(SW[8] && !SW[9]) LEDR = B;
	else LEDR = 8'b00000000;
 register_N_bits_aclr_ena #(8) register_1(clk, aclr, EA, Data, A);
 register_N_bits_aclr_ena #(8) register_2(clk, aclr, EB, Data, B);
 multiplier_N_bits #(8) exM(A,B,M);
 register_N_bits_aclr_ena #(16) exP(clk,aclr,1'b1,M,P);
 decoder_hex_10_normal d1(P%10,HEX0);
 decoder_hex_10_normal d2((P%100)/10,HEX1);
 decoder_hex_10_normal d3((P%1000)/100,HEX2);
 decoder_hex_10_normal d4((P%10000)/1000,HEX3);
endmodule
