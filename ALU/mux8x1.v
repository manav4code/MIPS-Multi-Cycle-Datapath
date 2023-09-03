module mux8x1(
	input [3:0]in,
	input rl,rr,
	input [1:0]sel,
	input rotate,
	output out
);

assign out = rotate ?((~sel[1] & ~sel[0] & in[0]) |
              (~sel[1] & sel[0] & rl) |
              (sel[1] & ~sel[0] & in[0]) |
              (sel[1] & sel[0] & rr)):
				  ((~sel[1] & ~sel[0] & in[0]) |
              (~sel[1] & sel[0] & in[1]) |
              (sel[1] & ~sel[0] & in[2]) |
              (sel[1] & sel[0] & in[3]));

endmodule
