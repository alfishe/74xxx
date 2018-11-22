`timescale 1ns / 1ps

// Purpose: 3-line to 8-line decoder / demultiplexer
// Western: SN74LS138A/SN54LS138/SN54S138
// USSR: K555ID7/К555ИД7
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

// Purpose: Quaduple 2 to 1 line selector/multiplexer
// Western: SN74LS257
// USSR: K555KP11/К555КП11
module selector_74257
(
  input [1:0] P [3:0],  // 4 input pairs (1A+1B, 2A+2B, 3A+3B. 4A+4B)
  input select,
  input g_n,            // Input enable (0 = enable, 1 = disable)

  output [3:0] Y        // 4 separatea outputs (1Y = 1A/1B; 2Y = 2A/2B, 3Y = 3A/3B; 4Y = 4A/4B)
);

assign Y[0] = ~g_n & P[0][select];
assign Y[1] = ~g_n & P[1][select];
assign Y[2] = ~g_n & P[2][select];
assign Y[3] = ~g_n & P[3][select];

endmodule

// Purpose: Dual 4 to 1 line selector/multiplexer
// Western: SN74LS253
// USSR: K555KP12/К555КП12
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
// USSR: K555KP16/К555КП16
module multiplexer_74157
(
	input [3:0] a,
	input [3:0] b,
	input select,
	input strobe_n,

	output [3:0] y
);
// Simulation delay
localparam multiplexer_74157_delay = 9; // 9ns typical average propagation delay

genvar i;
logic [3:0] output_values;

generate
	for (i = 0; i <= 3; i++)
	begin
		// Set output values based on select signal (A for select = 'b0, B for select = 'b1)
		assign output_values[i] = (select) ? b[i] : a[i];

		// React on strobe_n signal. Allow output values only on strobe_n = 'b0 (active). Make outputs low (zero) otherwise.
		assign #multiplexer_74157_delay y[i] = (strobe_n) ? 1'b0 : output_values[i];
	end
endgenerate


endmodule

// Purpose: D flip-flop
// Western: SN74LS74
// USSR: K555TM2/К555ТМ2
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
localparam dff_7474_delay = 1;

//assign nQ = ~Q;

always_ff @(posedge C or negedge nR or negedge nS) begin
	if (nR == 0 && nS == 0) // Special handling for SN7474 series behavior
	begin
		Q <= #dff_7474_delay 1'b1;
		nQ <= #dff_7474_delay 1'b1;
	end
	else if (nR == 0)
	begin
		Q <= #dff_7474_delay 1'b0;
		nQ <= #dff_7474_delay 1'b1;
	end
	else if (nS == 0)
	begin
		Q <= #dff_7474_delay 1'b1;
		nQ <= #dff_7474_delay 1'b0;
	end
	else
	begin
		Q <= #dff_7474_delay D;
		nQ <= #dff_7474_delay ~D;
	end
end

endmodule

// Purpose: Presettable 4-bit binary up/down counter
// Western: SN74LS193
// USSR: 555IE7/555ИЕ7
module counter_74193
(
  input clr,
  input up,
  input down,
  input load_n,    // Initial counter value load strobe
  input [3:0] P,   // 4-bit parallel input

  output co_n,      // Carry-out
  output bo_n,     // Borrow-our
  output [3:0] Q
);

localparam counter_74193_delay = 20; // Data setup time

reg co;
reg bo;
reg [3:0] count;

always_ff @(posedge clr or negedge load_n or posedge up or posedge down)
begin
  if (clr)
  begin
    count <= 4'b0000;
    co <= 1'b0;
    bo <= 1'b0;
  end
  else if (~load_n)
    count <= P;
  else if (up)
  begin
    count <= count + 1;
    co <= ~count[0] & count[1] & count[2] & count[3] & up; // Set carry-out flag when counted till 14 ('b1110) and up is active (high)
    bo <= 1'b0;
  end
  else if (down)
  begin
    count <= count - 1;
    co <= 1'b0;
    bo <= ~(~count[0] | count[1] | count[2] | count[3]) & down; // Set borrow out flag when counted till 1 ('b0001) and down is active (high)
  end
end

assign Q = count;
assign co_n = ~co;
assign bo_n = ~bo;

endmodule

// Purpose: Synchronous 4-bit up/down binary counter
// Western: 74sn169
// USSR: 555IE17/555ИЕ17
module counter_74169
(
  input clk,
  input direction, // 1 = Up, 0 = Down
  input load_n,    // 1 = Count, 0 = Load
  input ent_n,
  input enp_n,
  input [3:0] P,

  output rco_n,    // Ripple Carry-out (RCO)
  output [3:0] Q   // 4-bit output
);

localparam counter_74169_delay = 20; // Min propagation delay from datasheet

reg rco;
reg [3:0] count;

always_ff @(posedge clk) begin
  if (~load_n)
  begin
    count <= P;
    rco <= 1'b1;
  end
  else if (~ent_n & ~enp_n) // Count only if both enable signals are active (low)
  begin
    if (direction)
    begin
      // Counting up
      count <= count + 1;
      rco <= ~count[0] & count[1] & count[2] & count[3] & ~ent_n;    // Counted till 14 ('b1110) and active (low) ent_n
    end
    else
    begin
      // Counting down
      count <= count - 1;
      rco <= ~(~count[0] | count[1] | count[2] | count[3]) & ~ent_n; // Counted till 1 ('b0001) and active (low) ent_n
    end
  end
end

assign Q = count;
assign rco_n = ~rco;

endmodule

// Purpose: 4 bit fully synchronous binary counter
// Western: 74LS163
// USSR: K555IE18/К555ИЕ18
module counter_74163
(
  input clk,
  input clr_n,
  input enp,
  input ent,
  input load_n,
  input [3:0] P,   // 4-bit parallel input

  output [3:0] Q,  // Parallel outputs
  output rco
);

localparam counter_74163 = 20; // Propagation delay from datasheet

reg overflow;
reg [3:0] count;

always_ff @(posedge clk or negedge clr_n)
begin
  if (~clr_n)
  begin
    count <= 4'b0000;
    overflow <= 1'b0;
  end
  else if (~load_n)
  begin
    count <= P;
    overflow <= 1'b0;
  end
  else if (enp & ent)
  begin
    count <= count + 1;
    overflow <= count[3] & count[2] & count[1] & ~count[0] & ent; // Counted till 14 ('b1110) and ent is active (high)
  end
end

assign Q = count;
assign rco = overflow;

endmodule