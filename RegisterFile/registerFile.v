

module dualPortRam #(parameter N = 32,
							parameter Add = $clog2(N))
							(
	input [N-1:0]dataIn,
	input	wr, clk,
	input [Add-1:0] addrLine_r1,addrLine_r2,addrLine_w1,
	output [N-1:0] dataOut1, dataOut2
);


generate
	begin: REGFILE
		// Declaring each register individually
		reg [N - 1 : 0] reg_r0;
		reg [N - 1 : 0] reg_r1;
		reg [N - 1 : 0] reg_r2;
		reg [N - 1 : 0] reg_r3;
		reg [N - 1 : 0] reg_r4;
		reg [N - 1 : 0] reg_r5;
		reg [N - 1 : 0] reg_r6;
		reg [N - 1 : 0] reg_r7;
		reg [N - 1 : 0] reg_r8;
		reg [N - 1 : 0] reg_r9;
		reg [N - 1 : 0] reg_r10;
		reg [N - 1 : 0] reg_r11;
		reg [N - 1 : 0] reg_r12;
		reg [N - 1 : 0] reg_r13;
		reg [N - 1 : 0] reg_r14;
		reg [N - 1 : 0] reg_r15;
		reg [N - 1 : 0] reg_r16;
		reg [N - 1 : 0] reg_r17;
		reg [N - 1 : 0] reg_r18;
		reg [N - 1 : 0] reg_r19;
		reg [N - 1 : 0] reg_r20;
		reg [N - 1 : 0] reg_r21;
		reg [N - 1 : 0] reg_r22;
		reg [N - 1 : 0] reg_r23;
		reg [N - 1 : 0] reg_r24;
		reg [N - 1 : 0] reg_r25;
		reg [N - 1 : 0] reg_r26;
		reg [N - 1 : 0] reg_r27;
		reg [N - 1 : 0] reg_r28;
		reg [N - 1 : 0] reg_r29;
		reg [N - 1 : 0] reg_r30;
		reg [N - 1 : 0] reg_r31;
		
		
		// Write Back
		always@(posedge clk)begin
			reg_r0 = 32'h00000000;
			if(wr) begin
					if(addrLine_w1 == 5'd1) reg_r1 <= dataIn;
					if(addrLine_w1 == 5'd2) reg_r2 <= dataIn;
					if(addrLine_w1 == 5'd3) reg_r3 <= dataIn;
					if(addrLine_w1 == 5'd4) reg_r4 <= dataIn;
					if(addrLine_w1 == 5'd5) reg_r5 <= dataIn;
					if(addrLine_w1 == 5'd6) reg_r6 <= dataIn;
					if(addrLine_w1 == 5'd7) reg_r7 <= dataIn;
					if(addrLine_w1 == 5'd8) reg_r8 <= dataIn;
					if(addrLine_w1 == 5'd9) reg_r9 <= dataIn;
					if(addrLine_w1 == 5'd10) reg_r10 <= dataIn;
					if(addrLine_w1 == 5'd11) reg_r11 <= dataIn;
					if(addrLine_w1 == 5'd12) reg_r12 <= dataIn;
					if(addrLine_w1 == 5'd13) reg_r13 <= dataIn;
					if(addrLine_w1 == 5'd14) reg_r14 <= dataIn;
					if(addrLine_w1 == 5'd15) reg_r15 <= dataIn;
					if(addrLine_w1 == 5'd16) reg_r16 <= dataIn;
					if(addrLine_w1 == 5'd17) reg_r17 <= dataIn;
					if(addrLine_w1 == 5'd18) reg_r18 <= dataIn;
					if(addrLine_w1 == 5'd19) reg_r19 <= dataIn;
					if(addrLine_w1 == 5'd20) reg_r20 <= dataIn;
					if(addrLine_w1 == 5'd21) reg_r21 <= dataIn;
					if(addrLine_w1 == 5'd22) reg_r22 <= dataIn;
					if(addrLine_w1 == 5'd23) reg_r23 <= dataIn;
					if(addrLine_w1 == 5'd24) reg_r24 <= dataIn;
					if(addrLine_w1 == 5'd25) reg_r25 <= dataIn;
					if(addrLine_w1 == 5'd26) reg_r26 <= dataIn;
					if(addrLine_w1 == 5'd27) reg_r27 <= dataIn;
					if(addrLine_w1 == 5'd28) reg_r28 <= dataIn;
					if(addrLine_w1 == 5'd29) reg_r29 <= dataIn;
					if(addrLine_w1 == 5'd30) reg_r30 <= dataIn;
					if(addrLine_w1 == 5'd31) reg_r31 <= dataIn;
			end
		end
		
		
		// Read
		// Read Buffers
		reg [N-1:0] buf_r1, buf_r2;
		always@(addrLine_r1,addrLine_r2)begin
			case(addrLine_r1)
				5'd0: buf_r1 = 32'h00000000;
				5'd1: buf_r1 = reg_r1;
				5'd2: buf_r1 = reg_r2;
				5'd3: buf_r1 = reg_r3;
				5'd4: buf_r1 = reg_r4;
				5'd5: buf_r1 = reg_r5;
				5'd6: buf_r1 = reg_r6;
				5'd7: buf_r1 = reg_r7;
				5'd8: buf_r1 = reg_r8;
				5'd9: buf_r1 = reg_r9;
				5'd10: buf_r1 = reg_r10;
				5'd11: buf_r1 = reg_r11;
				5'd12: buf_r1 = reg_r12;
				5'd13: buf_r1 = reg_r13;
				5'd14: buf_r1 = reg_r14;
				5'd15: buf_r1 = reg_r15;
				5'd16: buf_r1 = reg_r16;
				5'd17: buf_r1 = reg_r17;
				5'd18: buf_r1 = reg_r18;
				5'd19: buf_r1 = reg_r19;
				5'd20: buf_r1 = reg_r20;
				5'd21: buf_r1 = reg_r21;
				5'd22: buf_r1 = reg_r22;
				5'd23: buf_r1 = reg_r23;
				5'd24: buf_r1 = reg_r24;
				5'd25: buf_r1 = reg_r25;
				5'd26: buf_r1 = reg_r26;
				5'd27: buf_r1 = reg_r27;
				5'd28: buf_r1 = reg_r28;
				5'd29: buf_r1 = reg_r29;
				5'd30: buf_r1 = reg_r30;
				5'd31: buf_r1 = reg_r31;
				default: buf_r1 = 32'h00000000;
			endcase
			
			case(addrLine_r2)
				5'd0: buf_r2 = 32'h00000000;
				5'd1: buf_r2 = reg_r1;
				5'd2: buf_r2 = reg_r2;
				5'd3: buf_r2 = reg_r3;
				5'd4: buf_r2 = reg_r4;
				5'd5: buf_r2 = reg_r5;
				5'd6: buf_r2 = reg_r6;
				5'd7: buf_r2 = reg_r7;
				5'd8: buf_r2 = reg_r8;
				5'd9: buf_r2 = reg_r9;
				5'd10: buf_r2 = reg_r10;
				5'd11: buf_r2 = reg_r11;
				5'd12: buf_r2 = reg_r12;
				5'd13: buf_r2 = reg_r13;
				5'd14: buf_r2 = reg_r14;
				5'd15: buf_r2 = reg_r15;
				5'd16: buf_r2 = reg_r16;
				5'd17: buf_r2 = reg_r17;
				5'd18: buf_r2 = reg_r18;
				5'd19: buf_r2 = reg_r19;
				5'd20: buf_r2 = reg_r20;
				5'd21: buf_r2 = reg_r21;
				5'd22: buf_r2 = reg_r22;
				5'd23: buf_r2 = reg_r23;
				5'd24: buf_r2 = reg_r24;
				5'd25: buf_r2 = reg_r25;
				5'd26: buf_r2 = reg_r26;
				5'd27: buf_r2 = reg_r27;
				5'd28: buf_r2 = reg_r28;
				5'd29: buf_r2 = reg_r29;
				5'd30: buf_r2 = reg_r30;
				5'd31: buf_r2 = reg_r31;
				default: buf_r2 = 32'h00000000;
			endcase
		end
		
		
		assign dataOut1 = buf_r1;
		assign dataOut2 = buf_r2;
	
	end
endgenerate


endmodule
