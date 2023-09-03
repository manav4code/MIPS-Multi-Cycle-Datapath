module multiCycleDatapath #(parameter N = 32)(
	input [N-1:0] program, addr, init_PC,
	input pmode,
	input clk, reset,
	input SysCallAddr,
	output [1:0] flags
);

/*
Inputs:
> program -> Instructions to be loaded in Instruction Cache
> addr -> Address on which program is loaded
> init_PC -> Starting value of PC at the time of execution begins
> pmode -> 1 - Programming Mode, 0 -> Execution Mode
> clk & reset
> flags[1] -> Zero Flag, flags[0] -> Overflow Flag
*/


reg [N-1:0] PC, inst_reg, data_reg, x_reg, y_reg, z_reg;

//-----------------------------------------------------------------
// Instruction Decoding
wire [4:0] rs, rt, rd;
wire [25:0] jta;
wire [15:0] immediate;
wire [5:0] opcode, fnclass;

assign rs = inst_reg[25:21];
assign rt = inst_reg[20:16];
assign rd = inst_reg[15:11];
assign jta = inst_reg[25:0];
assign immediate = inst_reg[15:0];
assign opcode =inst_reg[31:26];
assign fnclass = inst_reg[5:0];

//-----------------------------------------------------------------
// Control Section - Signals
wire ctrlClock;
wire [19:0] controlSignal;
wire [1:0] PCSrc, RegDst, ALUSrcY, LogicFn, FnType;
wire RegInSrc, jumpAddr, PCWrite, Inst_data, MemRead, MemWrite, IRWrite, RegWrite, ALUSrcX, Add_Sub;

assign PCSrc = controlSignal[19:18];
assign RegDst = controlSignal[17:16];
assign ALUSrcY = controlSignal[15:14];
assign LogicFn = controlSignal[13:12];
assign FnType = controlSignal[11:10];
assign RegInSrc = controlSignal[9];
assign jumpAddr = controlSignal[8];
assign PCWrite = controlSignal[7];
assign Inst_data = controlSignal[6];
assign MemRead = controlSignal[5];
assign MemWrite = controlSignal[4];
assign IRWrite = controlSignal[3];
assign RegWrite = controlSignal[2];
assign ALUSrcX = controlSignal[1];
assign Add_Sub = controlSignal[0];
/*
controlSignal = {{PCSrc},{RegDst},{ALUSrcY},{LogicFn},{FnType},
{RegInSrc},{jumpAddr},{PCWrite},{Inst_data},{MemRead},{MemWrite},{IRWrite},{RegWrite},{ALUSrcX},{Add_Sub}};
*/

assign ctrlClock = (pmode == 1) ? 1'b0 : clk;
// --> Control Section Instantiation
controlSection CONTROL(
	.op_code(opcode),
	.func(fnclass),
	.clk(ctrlClock),
	.reset(reset),
	.controlSignal(controlSignal)
);
//-----------------------------------------------------------------
// Cache signals and wires 
wire [N-1:0] cacheAddress, cacheOut, cacheIn;
wire read, write, IbarD;

// IbarD bifurcates address space for data and instruction. This bit will be MSB of the address.
assign IbarD = (pmode == 1) ? 1'b0 : Inst_data;

assign cacheAddress = (pmode == 1) ? addr :
					  (Inst_data == 1'b0) ? (PC >> 2) : z_reg;
							 
assign cacheIn = (pmode == 1) ? program : y_reg;

assign read = (pmode == 1) ? 1'b0 : MemRead;
assign write = (pmode == 1) ? 1'b1 : MemWrite;

// --> Cache Instantiation
dataCache #(N) CACHE(
	.inst_data(IbarD),
	.dataAddr(cacheAddress),
	.dataIn(cacheIn),
	.opType({write, read}),
	.dataOut(cacheOut)
);

//-----------------------------------------------------------------
// Register File

wire [4:0] regDstAddr;
wire [N-1:0] writeBackData, x_reg_wire, y_reg_wire;

assign regDstAddr = (RegDst == 0) ? rt : 
						  (RegDst == 1) ? rd :
						  (RegDst == 2) ? 5'b11111 : 'bz;

assign writeBackData = (RegInSrc == 0) ? data_reg : z_reg;

//--> Register File instantiation
dualPortRam #(N) REGFILE(
	.dataIn(writeBackData),
	.wr(RegWrite),
	.clk(clk),
	.addrLine_r1(rs),
	.addrLine_r2(rt),
	.addrLine_w1(regDstAddr),
	.dataOut1(x_reg_wire),
	.dataOut2(y_reg_wire)
);
//-----------------------------------------------------------------
// ALU 
wire [N-1:0] alu_1, alu_2, alu_out;

assign alu_1 = (ALUSrcX == 0) ? PC : x_reg;
assign alu_2 = (ALUSrcY == 0) ? 4'b0100 :
					(ALUSrcY == 1) ? y_reg :
					(ALUSrcY == 2) ? {{16{immediate[15]}},immediate} :
					{{14{immediate[15]}},immediate,2'b00};
// --> ALU Instantiation
alunbit #(N) ALU(
	.in1(alu_1),
	.in2(alu_2),
	.ALUfunc({Add_Sub,LogicFn,FnType}),
	.out(alu_out),
	.zero(flags[1]),
	.ovfl(flags[0])
);
//-----------------------------------------------------------------
// Unconditional Jumps
wire [N-1-2:0] jump_pc;

assign jump_pc = (jumpAddr == 0) ? {PC[31:28],jta} : SysCallAddr;
//-----------------------------------------------------------------
wire [N-1:0] PCin;

assign PCin = (PCSrc == 0) ? {jump_pc,2'b00} :
				  (PCSrc == 1) ? x_reg :
				  (PCSrc == 2) ? z_reg : alu_out;

//-----------------------------------------------------------------


always@(posedge clk)begin
	if(pmode == 1'b0 && reset == 1'b1)begin
		PC = init_PC;
	end
	else begin
		if(PCWrite) PC = PCin;
		if(IRWrite) begin
			inst_reg = cacheOut;
		end
		data_reg = cacheOut;
		z_reg = alu_out;
		x_reg = x_reg_wire;
		y_reg = y_reg_wire;
	end
end



endmodule
