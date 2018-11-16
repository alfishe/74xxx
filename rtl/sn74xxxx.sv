
// Purpose: 3-line to 8-line decoder / demultiplexer
// Western: SN74LS138A/SN54LS138/SN54S138
// USSR: K555ID7
module decoder_74138
(
	input [2:0] x,	// (A, B, C)
	
	input g1,				// G1
	input g2a_n,		// G2A/
	input g2b_n,		// G2B/
	
	output [7:0] y	// Y0-Y7
);

wire g2 = g2a_n | g2b_n;


wire en = ~(~g1 | g2);

// Shortest notation via assign
// Just decode 3 bits value to one of 8 output signals if 'en' signal permits
assign y = (en) ? ~(1 << x) : 8'b1111_1111;

/*
// Straightforward implementation via assign
assign y = (
	{ en, x[2], x[1], x[0] } == 4'b1000) ? 8'b1111_1110 :
( { en, x[2], x[1], x[0] } == 4'b1001) ? 8'b1111_1101 :
( { en, x[2], x[1], x[0] } == 4'b1010) ? 8'b1111_1011 :
( { en, x[2], x[1], x[0] } == 4'b1011) ? 8'b1111_0111 :
( { en, x[2], x[1], x[0] } == 4'b1100) ? 8'b1110_1111 :
( { en, x[2], x[1], x[0] } == 4'b1101) ? 8'b1101_1111 :
( { en, x[2], x[1], x[0] } == 4'b1110) ? 8'b1011_1111 :
( { en, x[2], x[1], x[0] } == 4'b1111) ? 8'b0111_1111 :
	8'b1111_1111;
*/

/*
// Case-based implementation. Requires register
// (otherwise it's not possible to change output within combinational logic block)
always_comb
begin
	casex ( { g1, g2, x[2], x[1], x[0] } )
		'bx1_xxx: y = 8'b1111_1111;
		'b0x_xxx: y = 8'b1111_1111;
		'b10_000: y = 8'b1111_1110;
		'b10_001: y = 8'b1111_1101;
		'b10_010: y = 8'b1111_1011;
		'b10_011: y = 8'b1111_0111;
		'b10_100: y = 8'b1110_1111;
		'b10_101: y = 8'b1101_1111;
		'b10_110: y = 8'b1011_1111;
		'b10_111: y = 8'b0111_1111;
	endcase
end
*/

/*
assign y[7] = g2a_n | g2b_n | (~g1) | (~x[0]) | (~x[1]) | (~x[2]); 
assign y[6] = g2a_n | g2b_n | (~g1) | (~x[0]) | (~x[1]) | x[2]; 
assign y[5] = g2a_n | g2b_n | (~g1) | (~x[0]) | x[1] | (~x[2]); 
assign y[4] = g2a_n | g2b_n | (~g1) | (~x[0]) | x[1] | x[2];
assign y[3] = g2a_n | g2b_n | (~g1) | x[0] | (~x[1]) | (~x[2]); 
assign y[2] = g2a_n | g2b_n | (~g1) | x[0] | (~x[1]) | x[2]; 
assign y[1] = g2a_n | g2b_n | (~g1) | x[0] | x[1] | (~x[2]); 
assign y[0] = g2a_n | g2b_n | (~g1) | x[0] | x[1] | x[2]; 
*/

endmodule


// Purpose: Dual 4 to 1 line selector/multiplexer
// Western: SN74LS253
// USSR: K555KP12
module selector_74253
(
	input [3:0] input_1c,				// (1C0, 1C1, 1C2, 1C3)
	input [3:0] input_2c,				// (2C0, 2C1, 2C2, 2C3)
	input [1:0] select,					// (A, B)
	input output_control_1g_n,	// 1G/
	input output_control_2g_n,	// 2G/

	output [1:0] y							// (1Y, 2Y)
);

assign y[0] = ~output_control_1g_n & input_1c[select];
assign y[1] = ~output_control_2g_n & input_2c[select];

endmodule

// Purpose: Single 4 to 1 line selector/multiplexer
module selector_4_to_1
(
	input [3:0] c,
	input [1:0] select,
	input output_control_n,

	output y
);

assign y = ~output_control_n & c[select];

endmodule

// Purpose: Quad 2 to 1 data selector / multiplexer
// Western: SN74LS157
// USSR: K555KP16
module selector_74157
(
);

endmodule

// Purpose D flip-flop
// Western: SN74LS74
// USSR: K555TM2
module dff_7474
(
	input nR,
	input D,
	input C,
	input nS,

	output reg Q,
	output reg nQ
);
// Simulation delay
localparam dff7474_delay = 1;

//assign nQ = ~Q;

always_ff @(posedge C or negedge nR or negedge nS) begin
	if (nR == 0 && nS == 0) // Special handling for SN7474 series behavior
	begin
		Q <= #dff7474_delay 1'b1;
		nQ <= #dff7474_delay 1'b1;
	end
	else if (nR == 0)
	begin
		Q <= #dff7474_delay 1'b0;
		nQ <= #dff7474_delay 1'b1;
	end
	else if (nS == 0)
	begin
		Q <= #dff7474_delay 1'b1;
		nQ <= #dff7474_delay 1'b0;
	end
	else
	begin
		Q <= #dff7474_delay D;
		nQ <= #dff7474_delay ~D;
	end
end

endmodule