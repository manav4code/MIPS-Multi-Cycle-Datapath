/*
**************************************************
32-bit Barrel Shifter with 5 functionality.
**************************************************
Functions:
> Logical Left Shift
> Logical Right Shift
> Arithmetic Right Shift

Implementation:
Structural Modelling style using generate block.
Nlog2N 4x1 MUX are used with connection hardwired
stage-wise. As per the shift amount, stages performs
shifting operation. 

> For LSL: All n-bit MSB connections are made with
(N-n) remaining LSB connection. n = 2 ** stage number.
> For LSR: All n-bit LSB connections are made with
(N-n) remaining MSB connections. n = 2 ** stage number.
> For ASR: All n-bit MSB bits are connected to N-1 bit.
Thus, Most signigicant bit is replicated by the shift amount.
**************************************************
*/

module barrelShifter #(
	parameter N = 16,
	parameter B = $clog2(N)		
) (
	input [N-1:0]num,
	input [B-1:0]shift_num,
	input LbarR,
	input ASR,rotate,
	output [N-1:0] out
);

wire [N-1:0] inbtw [B:0];
wire [1:0] sbit [B-1:0];

genvar k;
generate
	for (k = 0; k < B; k = k+1) begin: select_logic
		assign sbit[k][1] = LbarR & shift_num[k];
		assign sbit[k][0] = (ASR == 1'b1) ? 1'b0 : shift_num[k];
	end
endgenerate

assign inbtw[B] = num;

genvar i,j;
generate
	for(i = B-1; i >= 0; i = i-1) begin: stage
		for(j = N-1; j >= 0; j = j-1) begin: mux
		
			if(j >= N-(2**i)) begin
				mux8x1 mz(.sel(sbit[i]), .rotate(rotate), .in({1'b0, inbtw[i+1][N-1], inbtw[i+1][j-(2**i)], inbtw[i+1][j]}), .rr(inbtw[i+1][(2**i)-(N-j)]), .rl(inbtw[i+1][j-(2**i)]), .out(inbtw[i][j]));
			end
			else if(j < N-(2**i) && j >= (2**i)) begin
				mux8x1 ml(.sel(sbit[i]), .rotate(rotate), .in({inbtw[i+1][j+(2**i)], inbtw[i+1][j+(2**i)], inbtw[i+1][j-(2**i)], inbtw[i+1][j]}), .rr(inbtw[i+1][j+(2**i)]), .rl(inbtw[i+1][j-(2**i)]), .out(inbtw[i][j]));
			end
			else begin
				mux8x1 ms(.sel(sbit[i]), .rotate(rotate), .in({inbtw[i+1][j+(2**i)], inbtw[i+1][j+(2**i)], 1'b0, inbtw[i+1][j]}), .rr(inbtw[i+1][j+(2**i)]), .rl(inbtw[i+1][(N+j)-(2**i)]), .out(inbtw[i][j]));
			end
			
		end
	end
endgenerate

assign out = inbtw[0];

endmodule
