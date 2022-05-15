module ripple_carry_adder #(parameter N=4) 
(input [N-1:0] A,B,
input cin,
output [N-1:0] S,
output cout);

wire [N-2:0] c;
generate
genvar i;

for (i=0; i<N; i=i+1) begin:add
	case(i)
		0: full_adder x(A[i],B[i],cin,S[i],c[i]);
		N-1: full_adder x(A[i],B[i],c[i-1],S[i],cout);
		default: full_adder x(A[i],B[i],c[i-1],S[i],c[i]);
	endcase
end
endgenerate
endmodule

module full_adder
(input a,b,cin,
output s,cout);
	assign s = a^b^cin;
	assign cout = a*b + (a^b)*cin;
endmodule


module register_N_bits #(parameter N=8)(
input clk,aclr,
input wire [N-1:0] data,
output reg [N-1:0] out);
always @(posedge clk or negedge aclr)
	if(!aclr) out = {N{1'b0}};
	else out <= data;
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

module accum_N_bits
(input [7:0] SW, input [1:0] KEY, output [9:0] LEDR, output [0:6] HEX3, HEX2, HEX1, HEX0);
wire [7:0] A, sum, S;
wire logic, cout, carry, overflow;
assign logic = cout ^ sum[7];
assign LEDR[7:0] = S;
assign LEDR[8] = carry;
assign LEDR[9] = overflow;
decoder_hex_10_normal h1(SW[7:4], HEX3);
decoder_hex_10_normal h2(SW[3:0], HEX2);
decoder_hex_10_normal h3(S[7:4], HEX1);
decoder_hex_10_normal h4(S[3:0], HEX0);
register_N_bits #(8) (KEY[1], KEY[0],SW,A);
ripple_carry_adder #(8) (A,S,1'b0,sum, cout);
register_N_bits #(8) (KEY[1], KEY[0], sum, S);
register_N_bits #(1) (KEY[1], KEY[0], logic, overflow);
register_N_bits #(1) (KEY[1], KEY[0], cout, carry);
endmodule
