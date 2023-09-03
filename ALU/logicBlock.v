module logicBlock #(parameter N = 16)(
	input [N-1:0] a,b,		// Inputs
	input [1:0] opType,		// Operation Type
	output [N-1:0] out
);

assign out = (opType[1] & opType[0]) ? ~(a | b):
				 (opType[1] & ~opType[0]) ? (a ^ b):
				 (~opType[1] & opType[0]) ? (a | b):
				 (a & b);
				 

endmodule
