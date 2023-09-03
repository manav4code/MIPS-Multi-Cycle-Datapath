module alunbit #(parameter N = 32) 
	(
    input [N-1:0] in1,in2,		// in1 -> A, in2 -> B
    input [4:0] ALUfunc,
    output [N-1:0] out,
    output ovfl,zero
);


/******************************************************************/
/*
ALUfunc[4] -> Add'sub
ALUfunc[3:2] -> LogicFn
ALUfunc[1:0] -> FnClass
*/
/******************************************************************/

// For Adder
wire [N-1:0] adderOut;
wire [1:0] carry;

// For Logic Block
wire [N-1:0] logicOut;

// For Shifter
wire [N-1:0] shiftOut;

// For slti & slt
wire slt;
assign slt = (adderOut[N-1] == 1) && (!ovfl);

// Module Instatiations
/******************************************************************/
// Adder

subAdder #(N) ADD(.a(in1),.b(in2),.c_in(ALUfunc[4]), .sum(adderOut), .c_out(carry));
/******************************************************************/


/******************************************************************/
// Barrel Shifter
/*
	input [N-1:0]num,
	input [B-1:0]shift_num,
	input LbarR,
	input ASR,rotate,
	output [N-1:0] out
*/
// Configured for LUI  i.e left shift number by 16

barrelShifter #(N) SHIFT(.num(in2), .shift_num(5'b10000), .LbarR(1'b0), .ASR(1'b0), .out(shiftOut), .rotate(1'b0));
/******************************************************************/

/******************************************************************/
// Logic Block
/*
	input [N-1:0] a,b;		// Inputs
	input [1:0] opType;		// Operation Type
	output [N-1:0] out
*/

logicBlock #(N) LOGIC(.a(in1), .b(in2), .opType(ALUfunc[3:2]), .out(logicOut));
/******************************************************************/


assign out = (ALUfunc[1] & ALUfunc[0]) ? logicOut :
				 (ALUfunc[1] & ~ALUfunc[0]) ? adderOut :
				 (~ALUfunc[1] & ALUfunc[0]) ? slt : shiftOut;
				 
assign ovfl = (carry[1] ^ carry[0]);
assign zero = (~|adderOut);

endmodule
