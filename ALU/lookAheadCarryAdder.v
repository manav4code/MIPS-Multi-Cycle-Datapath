module lookAheadCarryAdder #(parameter N = 16)(
			input [N-1:0]a,b,
			input c_in,
			output [N-1:0] sum,
			output [1:0] c_out
			);

wire [N:0]C;
wire [N-1:0] G,P,SUM;

assign C[0] = c_in;


genvar i;
generate
for(i = 0; i < N; i = i+1)begin:l1
	adder a1(.a(a[i]),.b(b[i]),.c(C[i]),.sum(SUM[i]),.cout());
	end
endgenerate

genvar j;
generate
for(j = 0; j < N; j = j+1)begin:l2
	assign G[j] = a[j] & b[j];
	assign P[j] = a[j] ^ b[j];
	assign C[j+1] = G[j] | (P[j]&C[j]);
	end
endgenerate


assign sum = SUM;
assign c_out = {C[N],C[N-1]};

endmodule



module adder(input a,b,c,
		output reg sum,cout);

always@(*)begin
{cout,sum} = a+b+c;
end
endmodule
