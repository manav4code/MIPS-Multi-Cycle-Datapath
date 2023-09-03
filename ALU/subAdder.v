module subAdder #(parameter N = 16)(
		input [N-1:0]a,b,
		input c_in,
		output  [N-1:0]sum,
		output  [1:0] c_out
);

wire [N-1:0]btemp;

assign btemp = b ^ {N{c_in}};
lookAheadCarryAdder #(N) adder0(.a(a), .b(btemp), .c_in(c_in), .c_out(c_out), .sum(sum));

endmodule
