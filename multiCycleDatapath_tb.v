module multiCycleDatapath_tb;


parameter N = 32;

reg [N-1:0] program, addr, init_PC;
reg pmode, clk, reset, SysCallAddr;

wire [1:0] flags;


multiCycleDatapath #(N) DUT (
    .program(program),
    .addr(addr),
    .init_PC(init_PC),
    .pmode(pmode),
    .clk(clk),
    .reset(reset),
    .SysCallAddr(SysCallAddr),
    .flags(flags)
);

integer file;

initial begin

    file = $fopen("outputLog.txt","w");

    clk = 0;
    pmode = 1;
    reset = 0;
    init_PC = 0;
end

always #10 clk = ~clk;

reg [31:0] inst_array [5:0]; // Declare an array of 5 32-bit values
integer i;
integer loc;

initial begin
    // Initialize the array with the provided values
    inst_array[0] = 32'b00100000000000010000000000000010; // addi $r1,$r0,#2
    inst_array[1] = 32'b00100000000000100000000000000101; // addi $r2,$r0,#5
    inst_array[2] = 32'b00000000001000100001100000100000; // add $r3,$r1,$r2
    inst_array[3] = 32'b10101100001000110000000000000000; // sw $r3, 0($r1)
    inst_array[4] = 32'b10001100001001000000000000000000; // lw $r4, 0($r1)

    $fwrite(file, "Loading Instructions in the Memory");

    for(i = 0; i < 5; i = i + 1)begin
        addr = i;
        program = inst_array[i];
        @(posedge clk);
        $fwrite(file, "Instruction: %b @ %b", DUT.CACHE.DATACACHE.mem[i], DUT.CACHE.addrLine);
    end
    $fwrite(file, "Loaded!");

    $fwrite(file, "Execution:\n\n");

    
    pmode = 0;
    reset = 1;
    init_PC = 0;

    i = 0;

    repeat(22) begin

        @(posedge clk);
        #1;
        if(reset == 1) reset = 0;

        $fwrite(file, "Clock Cycle: %d\n", i);
        $fwrite(file, "PC: %b\n", DUT.PC);
        $fwrite(file, "----------------------------------------\n");
        $fwrite(file, "Control Signals: \n");
        $fwrite(file, "Current State: %d, Next State: %d\n", DUT.CONTROL.p_state, DUT.CONTROL.n_state);
        $fwrite(file, "Inst_data = %b\n", DUT.Inst_data);
        $fwrite(file, "MemRead = %b\n", DUT.MemRead);
        $fwrite(file, "MemWrite = %b\n", DUT.MemWrite);
        $fwrite(file, "IRWrite = %b\n", DUT.IRWrite);
        $fwrite(file, "PCSrc = %b\n", DUT.PCSrc);
        $fwrite(file, "jumpAddr = %b\n", DUT.jumpAddr);
        $fwrite(file, "PCWrite = %b\n", DUT.PCWrite);
        $fwrite(file, "----------------------------------------\n");
        $fwrite(file, "Instruction: %b\n", DUT.inst_reg);
        $fwrite(file, "rs: %b\n", DUT.rs);
        $fwrite(file, "rt: %b\n", DUT.rt);
        $fwrite(file, "rd: %b\n", DUT.rd);
        $fwrite(file, "jta: %b\n", DUT.jta);
        $fwrite(file, "immediate: %b\n", DUT.immediate);
        $fwrite(file, "opcode: %b\n", DUT.opcode);
        $fwrite(file, "fnclass: %b\n", DUT.fnclass);
        $fwrite(file, "----------------------------------------\n");
        $fwrite(file, "ALU:\n");
        $fwrite(file, "Add_Sub = %b\n", DUT.Add_Sub);
        $fwrite(file, "LogicFn = %b\n", DUT.LogicFn);
        $fwrite(file, "FnType = %b\n", DUT.FnType);
        $fwrite(file, "ALUSrcX = %b\n", DUT.ALUSrcX);
        $fwrite(file, "ALUSrcY = %b\n", DUT.ALUSrcY);
        $fwrite(file, "Operand 1: %b, Operand 2: %b\n", DUT.alu_1, DUT.alu_2);
        $fwrite(file, "ALU Output: %b\n", DUT.alu_out);
        $fwrite(file, "----------------------------------------\n");
        $fwrite(file, "Register File\n");
        $fwrite(file, "Write-Back Data: %b\n", DUT.writeBackData);
        $fwrite(file, "RegWrite = %b\n", DUT.RegWrite);
        $fwrite(file, "RegDst = %b\n", DUT.RegDst);
        $fwrite(file, "RegInSrc = %b\n", DUT.RegInSrc);
        $fwrite(file, "RegDstAddr: %b\n", DUT.regDstAddr);
        $fwrite(file, "REG 1: %b\n",DUT.REGFILE.REGFILE.reg_r1);
        $fwrite(file, "REG 2: %b\n", DUT.REGFILE.REGFILE.reg_r2);
        $fwrite(file, "REG 3: %b\n", DUT.REGFILE.REGFILE.reg_r3);
        $fwrite(file, "REG 4: %b\n", DUT.REGFILE.REGFILE.reg_r4);
        $fwrite(file, "----------------------------------------\n");
        $fwrite(file, "Data Cache\n");
        $fwrite(file, "Cache Address: %b\n", DUT.cacheAddress);
        $fwrite(file, "Cache Data: %b\n", DUT.cacheIn);
        $fwrite(file, "Cache Data @ 1000010: %b\n", DUT.CACHE.DATACACHE.mem[7'b1000010]);
        $fwrite(file, "----------------------------------------\n");

        i = i + 1;
    end

    $fclose(file);
    $finish(0);
end

endmodule
