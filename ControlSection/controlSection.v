module controlSection(
    input [5:0] op_code,
    input [5:0] func,
    input clk, reset,
    output reg [19:0] controlSignal
);

/*
+---------------+------------+
| Signal Name   | Bit Indices|
+---------------+------------+
| PCSrc         |   20:19    |
| RegDst        |   18:17    |
| RegInSrc      |   16:15    |
| ALUSrcY       |   14:13    |
| LogicFn       |   12:11    |
| FnType        |   10:9     |
| jumpAddr      |    8       |
| PCWrite       |    7       |
| Inst_data     |    6       |
| MemRead       |    5       |
| MemWrite      |    4       |
| IRWrite       |    3       |
| RegWrite      |    2       |
| ALUSrcX       |    1       |
| Add_Sub       |    0       |
+---------------+------------+
*/

reg RegInSrc, jumpAddr, PCWrite, Inst_data, MemRead, MemWrite, IRWrite, RegWrite, ALUSrcX, Add_Sub;
reg [1:0] PCSrc, RegDst, ALUSrcY, LogicFn, FnType;

reg [3:0] p_state, n_state;
parameter state0 = 0, state1 = 1, state2 = 2, state3 = 3, state4 = 4, state5 = 5, state6 = 6, state7 = 7, state8 = 8;


always @(p_state) begin
    
    // Init
    n_state = state0;
	 
	 
    jumpAddr = 0;
    PCWrite = 0;
    Inst_data = 0;
    MemRead = 0;
    MemWrite = 0;
    IRWrite = 0;
    RegWrite = 0;
    ALUSrcX = 0;
    Add_Sub = 0;
    PCSrc = 0;
    RegDst = 0;
    RegInSrc = 0;
    ALUSrcY = 0;
    LogicFn = 0;
    FnType = 0;
	
    case (p_state)
        state0: 
            begin
                Inst_data = 1'b0; 
                MemRead = 1'b1;
                IRWrite = 1'b1;
                ALUSrcX = 1'b0;
                ALUSrcY = 2'b00;
                Add_Sub = 1'b0;
                LogicFn = 2'b00;
                FnType = 2'b10;
                PCSrc = 2'b11;
                PCWrite = 1'b1;
                
                n_state = state1;
            end
        
        state1:
            begin
                ALUSrcX = 1'b0;
                ALUSrcY = 2'b11;
                Add_Sub = 1'b0;
                LogicFn = 2'b00;
                FnType = 2'b10;
                
                if ((op_code == 6'b000010) || (op_code == 6'b000001) || (op_code == 6'b000100) || 
                    (op_code == 6'b000101) || (op_code == 6'b000011) || (op_code == 6'b001111) || 
                    ((op_code == 6'b000000) && ((func == 6'b001000) || (func == 6'b001100))))
                    n_state = state5;
                else if ((op_code == 6'b100011) || (op_code == 6'b101011))
                    n_state = state2;
                else
                    n_state = state7;
            end
        
        state2:
            begin
                ALUSrcX = 1'b1;
                ALUSrcY = 2'b10;
                Add_Sub = 1'b0;
                LogicFn = 2'b00;
                FnType = 2'b10;
                
                if (op_code == 6'b101011)
                    n_state = state6;
                else
                    n_state = state3;
            end
        
        state3:
            begin
                Inst_data = 1'b1;
                MemRead = 1'b1;
                
                n_state = state4;
            end
        
        state4:
            begin
                RegDst = 1'b0;
                RegInSrc = 1'b0;
                RegWrite = 1'b1;
                
                n_state = state0;
            end
        
        state5:
            begin
                ALUSrcX = 1'b1;
                ALUSrcY = 2'b01;
                Add_Sub = 1'b1;
                LogicFn = 2'b00;
                FnType = 2'b10;
                
                if ((op_code == 6'b000010) || (op_code == 6'b000011))
                    jumpAddr = 1'b0;
                else if ((op_code == 6'b000000) && (func == 6'b001100))
                    jumpAddr = 1'b1;
                else
                    jumpAddr = 1'bx;
                
                if ((op_code == 6'b000010) || (op_code == 6'b000011) || 
                    ((op_code == 6'b000000) && (func == 6'b001100)))
                    PCSrc = 2'b00;
                else if ((op_code == 6'b000000) && (func == 6'b001000))
                    PCSrc = 2'b01;
                else
                    PCSrc = 2'b10;
                    
                n_state = state0;
            end
        
        state6:
            begin
                Inst_data = 1'b1;
                MemWrite = 1'b1;
                
                n_state = state0;
            end
        
        state7:
            begin
                ALUSrcX = 1'b1;
                if (op_code != 6'b000000)
                    ALUSrcY = 2'b10;
                else
                    ALUSrcY = 2'b01;
                
                {Add_Sub, LogicFn, FnType} = (op_code == 6'b001111) ? 5'bxxx00 :
                                             (op_code == 0 && func == 6'b100000) ? 5'b0xx10 :
                                             (op_code == 0 && func == 6'b100010) ? 5'b1xx10 :
                                             (op_code == 0 && func == 6'b101010) ? 5'b1xx01 :
                                             (op_code == 6'b001000) ? 'b0xx10 :
                                             (op_code == 'b001010) ? 'b1xx01 :
                                             (op_code == 0 && func == 'b100100) ? 'b00011 :
                                             (op_code == 0 && func == 'b100101) ? 'b00100 :
                                             (op_code == 0 && func == 'b100110) ? 'b01011 :
                                             (op_code == 0 && func == 'b100111) ? 'b01111 :
                                             (op_code == 'b001100) ? 'b00011 :
                                             (op_code == 'b001101) ? 'b00111 :
                                             (op_code == 'b001110) ? 'b01011 : 'bxxxxx;

                n_state = state8;
            end
        
        state8:
            begin
                if (op_code == 6'b000000) // R Type
                    RegDst = 2'b01;
                else
                    RegDst = 2'b00;     // I Type
                
                RegInSrc = 1'b1;
                RegWrite = 1'b1;
                
                n_state = state0;
            end
        
    endcase
    controlSignal = {{PCSrc},{RegDst},{ALUSrcY},{LogicFn},{FnType},
        {RegInSrc},{jumpAddr},{PCWrite},{Inst_data},{MemRead},{MemWrite},{IRWrite},{RegWrite},{ALUSrcX},{Add_Sub}};
end

always @(posedge clk)
begin
    if (reset == 1'b1)
        p_state <= state0;
    else
		p_state <= n_state;
end

endmodule
