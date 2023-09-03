module dataCache #(parameter N = 32)(
	input [N-1:0] dataAddr,dataIn,
	input [1:0] opType,
	input inst_data,
	output [N-1:0] dataOut
);

/*
Input - Output Description

dataAddr -> Data Address Line
dataIn -> Input Data i.e. Write Operation
opType -> Operation Type  i.e. Read/ Write
dataOut -> Output Data i.e. Read Operation

-> Functionality:
opType[1] -> Data Write
opType[0] -> Data Read

|--------------------------------------|
| Data Read | Data Write |   Status    |
|-----------|------------|-------------|
|     0     |     0      | No operation|
|     0     |     1      |    Write    |
|     1     |     0      |    Read     |
|     1     |     1      |   Invalid   |
|--------------------------------------|


*/




wire [6:0] addrLine;

assign addrLine = {inst_data,dataAddr[5:0]};

generate 
	begin: DATACACHE
	reg [N-1:0] mem [127:0];
	
	// Write Operation
	always@(*)begin
		if(opType[1] & ~opType[0]) begin
				mem[addrLine] = dataIn;
			end
	end

	reg [N-1:0] bufOut;
	always@(*)begin
		if(opType[0] & ~opType[1]) bufOut = mem[addrLine];
		else bufOut = 32'h00000000;
	end
	
	assign dataOut = bufOut;
	end
endgenerate
endmodule

