`timescale 1ns / 1ps


module decoder_74138_tb();
reg [2:0] x;
reg g1, g2a_n, g2b_n;
wire [7:0] y;

reg [2:0] g;
reg g2;
integer i;
integer j;

decoder_74138 DUT
(
  .g1(g1),
  .g2a_n(g2a_n),
  .g2b_n(g2b_n),
  .x(x),
  .y(y)
);

initial begin
  #1;
  for (j = 0; j < 8; j++)
  begin
    g = j;
    g1 = g[0];
    g2a_n = g[1];
    g2b_n = g[2];

    g2 = g2a_n | g2b_n;

    for (i = 0; i < 8; i++) // Try all combination of SELECT inputs [2:0]
    begin
      x = i; #1;

      casex( { g1, g2, x[2], x[1], x[0] } )
        'bx1_xxx: assert (y == 'b1111_1111) else $error("Expected y[] = 'b1111_1111 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b0x_xxx: assert (y == 'b1111_1111) else $error("Expected y[] = 'b1111_1111 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_000: assert (y == 'b1111_1110) else $error("Expected y[] = 'b1111_1110 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_001: assert (y == 'b1111_1101) else $error("Expected y[] = 'b1111_1101 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_010: assert (y == 'b1111_1011) else $error("Expected y[] = 'b1111_1011 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_011: assert (y == 'b1111_0111) else $error("Expected y[] = 'b1111_0111 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_100: assert (y == 'b1110_1111) else $error("Expected y[] = 'b1110_1111 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_101: assert (y == 'b1101_1111) else $error("Expected y[] = 'b1101_1111 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_110: assert (y == 'b1011_1111) else $error("Expected y[] = 'b1011_1111 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
        'b10_111: assert (y == 'b0111_1111) else $error("Expected y[] = 'b0111_1111 for g1=%b g2a_n=%b g2b_n=%b g2=%b C=%b B=%b A=%b. Found y[]=%b", g1, g2a_n, g2b_n, g2, x[2], x[1], x[0], y[7:0]);
      endcase
    end
  end

  // Just test end marker
  x = 'bxxx;
  g = 'x;
  g1 = 'bx;
  g2 = 'bx;
  g2a_n = 'bx;
  g2b_n = 'bx;
  i = 'x;
  j = 'x;

  #1;
end

/*
integer k;

initial begin
  x = 0; g1 = 0; g2a_n = 1; g2b_n = 1;
  for (k=0; k < 8; k=k+1)
    #5 x=k;
  
  #10;

  x = 0; g1 = 1; g2a_n = 0; g2b_n = 1;
  for (k=0; k < 8; k=k+1)
    #5 x=k;

  #10;

  x = 0; g1 = 0; g2a_n = 1; g2b_n = 0;
  for (k=0; k < 8; k=k+1)
    #5 x=k;

  #10;

  x = 0; g1 = 1; g2a_n = 0; g2b_n = 0;
  for (k=0; k < 8; k=k+1)
    #5 x=k;
  
  #10;
end
*/

endmodule

module selector_74257_tb();
logic [1:0] P [3:0];
logic select;
logic g_n;
logic [3:0] Y;

selector_74257 DUT
(
  .P(P),
  .select(select),
  .g_n(g_n),
  .Y(Y)
);

initial begin
  $display("----------------------------------------------------------");
  $display("| MODULE |               INPUTS               | OUTPUT Y |");
  $display("----------------------------------------------------------");
  $display("|        | OUTPUT CONTROL | SELECT |  A    B  |    Y     |");
  $display("----------------------------------------------------------");

  // For all 4 submodules
  for (int i = 0; i <= 3; i++)
  begin
  g_n = 1'b1;
  #1;
  $display("|   %0d    |        %b       |    x   |  x    x  |    z     |", i, g_n);

  g_n = 1'b0;
  select = 1'b0;
  P[i][0] = 1'b0;
  P[i][1] = 1'b1;
  #1;
  assert (Y[i] == 1'b0) else $error("y[%0d]=%b should reflect input A=%b when select=%b. B=%b", i, Y[i], P[i][0], select, P[i][1]);
  $display("|   %0d    |        %b       |    %b   |  %b    x  |    %b     |", i, g_n, select, P[i][0], Y[i]);
  P[i][0] = 1'b1;
  P[i][1] = 1'b0;
  #1;
  assert (Y[i] == 1'b1) else $error("y[%0d]=%b should reflect input A=%b when select=%b. B=%b", i, Y[i], P[i][0], select, P[i][1]);
  $display("|   %0d    |        %b       |    %b   |  %b    x  |    %b     |", i, g_n, select, P[i][0], Y[i]);

  select = 1'b1;
  P[i][0] = 1'b1;
  P[i][1] = 1'b0;
  #1;
  assert (Y[i] == 1'b0) else $error("y[%0d]=%b should reflect input B=%b when select=%b. A=%b", i, Y[i], P[i][1], select, P[i][0]);
  $display("|   %0d    |        %b       |    %b   |  x    %b  |    %b     |", i, g_n, select, P[i][1], Y[i]);
  P[i][0] = 1'b0;
  P[i][1] = 1'b1;
  #1;
  assert (Y[i] == 1'b1) else $error("y[%0d]=%b should reflect input B=%b when select=%b. A=%b", i, Y[i], P[i][1], select, P[i][0]);
  $display("|   %0d    |        %b       |    %b   |  x    %b  |    %b     |", i, g_n, select, P[i][1], Y[i]);

  $display("----------------------------------------------------------");
  end
end

endmodule

module selector_74253_tb();
logic [3:0] input_1c;
logic [3:0] input_2c;
logic [1:0] select;
logic output_control_1g_n;
logic output_control_2g_n;
logic [1:0] y;

integer i;
integer j;

selector_74253 DUT
(
  .input_1c(input_1c),
  .input_2c(input_2c),
  .select(select),
  .output_control_1g_n(output_control_1g_n),
  .output_control_2g_n(output_control_2g_n),
  .y(y)
);

initial begin

  // Test sub-module 1
  $display("SUB-MODULE 1");
  $display("-------------------------------------------------------------");
  $display("| SELECT INPUTS |   DATA INPUTS   | OUTPUT CONTROL | OUTPUT |");
  $display("-------------------------------------------------------------");
  $display("|   B       A   |  C0  C1  C2  C3 |       G        |    Y   |");
  $display("-------------------------------------------------------------");

  output_control_1g_n = 1'b1; #1;
  for (j = 0; j < 4; j++)
  begin
    select = j; #1;
    for (i = 0; i < 16; i++)
    begin
      input_1c = i; #1;

      assert (y[0] == 1'b0) else $error("y[0] should be always low (0) when output_control_1g_n is high (1)");
    end
  end

  $display("|   x       x   |  x   x   x   x  |       %b       |     %b   |", output_control_1g_n, y[0]);

  output_control_1g_n = 1'b0; #1;
  for (j = 0; j < 4; j++)
  begin
    select = j; #1;
    for (i = 0; i < 16; i++)
    begin
      input_1c = i; #1;

      $display("|   %b       %b   |  %b   %b   %b   %b  |       %b       |     %b   |",
                select[1], select[0],
                input_1c[0], input_1c[1], input_1c[2], input_1c[3],
                output_control_1g_n,
                y[0]
              );
    end
  end

  $display("-------------------------------------------------------------");
  $display("");

  // Test sub-module 2
  $display("SUB-MODULE 2");
  $display("-------------------------------------------------------------");
  $display("| SELECT INPUTS |   DATA INPUTS   | OUTPUT CONTROL | OUTPUT |");
  $display("-------------------------------------------------------------");
  $display("|   B       A   |  C0  C1  C2  C3 |       G        |    Y   |");
  $display("-------------------------------------------------------------");

  output_control_2g_n = 1'b1; #1;
  for (j = 0; j < 4; j++)
  begin
    select = j; #1;
    for (i = 0; i < 16; i++)
    begin
      input_2c = i; #1;

      assert (y[1] == 1'b0) else $error("y[1] should be always low (0) when output_control_2g_n is high (1)");
    end
  end

  $display("|   x       x   |  x   x   x   x  |       %b       |     %b   |", output_control_2g_n, y[1]);

  output_control_2g_n = 1'b0; #1;
  for (j = 0; j < 4; j++)
  begin
    select = j; #1;
    for (i = 0; i < 16; i++)
    begin
      input_2c = i; #1;

        $display("|   %b       %b   |  %b   %b   %b   %b  |       %b       |     %b   |",
              select[1], select[0],
              input_2c[0], input_2c[1], input_2c[2], input_2c[3],
              output_control_2g_n,
              y[1]
            );
    end
  end

  $display("-------------------------------------------------------------");

end

endmodule

module selector_4_to_1_tb();

reg [3:0] c;
reg [1:0] select;
reg output_control_n;
wire y;

integer i;
integer j;

selector_4_to_1 DUT
(
  .c(c),
  .select(select),
  .output_control_n(output_control_n),
  .y(y)
);

initial begin
  $display("-------------------------------------------------------------");
  $display("| SELECT INPUTS |   DATA INPUTS   | OUTPUT CONTROL | OUTPUT |");
  $display("-------------------------------------------------------------");
  $display("|   B       A   |  C0  C1  C2  C3 |       G        |    Y   |");
  $display("-------------------------------------------------------------");

  output_control_n = 1'b1; #1;
  for (j = 0; j < 4; j++)
  begin
    select = j; #1;
    for (i = 0; i < 16; i++)
    begin
      c = i; #1;

      assert (y == 1'b0) else $error("y should be always low (0) when output_control_n is high (1)");
    end
  end

  $display("|   x       x   |  x   x   x   x  |       %b       |     %b   |", output_control_n, y);

  output_control_n = 1'b0; #1;
  for (j = 0; j < 4; j++)
  begin
    select = j; #1;

    for (i = 0; i < 16; i++)
    begin
      c = i; #1;

      casex( { select[1], select[0], c[0], c[1], c[2], c[3], output_control_n } )
        'bxx_xxxx_1: assert(y == 1'b0) else $error("y should be always low (0) when output_control_n is high (1)");
        'b00_0xxx_0: assert(y == 1'b0) else $error("y should be low(0) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
        'b00_1xxx_0: assert(y == 1'b1) else $error("y should be high(1) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
        'b01_x0xx_0: assert(y == 1'b0) else $error("y should be low(0) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
        'b01_x1xx_0: assert(y == 1'b1) else $error("y should be high(1) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
        'b10_xx0x_0: assert(y == 1'b0) else $error("y should be low(0) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
        'b10_xx1x_0: assert(y == 1'b1) else $error("y should be high(0) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
        'b11_xxx0_0: assert(y == 1'b0) else $error("y should be low(0) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
        'b11_xxx1_0: assert(y == 1'b1) else $error("y should be high(1) for B=%b, A=%b, C0=%b, C1=%b, C2=%b, C3=%b, OUTPUT_CONTROL=%b, y=%b", select[1], select[0], c[0], c[1], c[2], c[3], output_control_n, y);
      endcase

      $display("|   %b       %b   |  %b   %b   %b   %b  |       %b       |     %b   |",
                select[1], select[0],
                c[0], c[1], c[2], c[3],
                output_control_n,
                y
              );
    end
  end

  $display("-------------------------------------------------------------");
end

endmodule

module multiplexer_74157_tb();
logic [3:0] a;
logic [3:0] b;
logic select;
logic strobe_n;
logic [3:0] y;

integer i;
integer j;
integer k;
reg [2:0] stimulus;

multiplexer_74157 DUT
(
	.a(a),
	.b(b),
	.select(select),
	.strobe_n(strobe_n),
	.y(y)
);

initial begin
  // Set up time printing format to nanoseconds with no decimal precision digits
  // $timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
  $timeformat(-9, 0, " ns", 3);

  // Set initial state
  select = 1'b0;
  strobe_n = 1'b1;
  for (i = 0; i <= 3; i++)
  begin
  	a[i] = 1'b0;
 	b[i] = 1'b0;
  end
  #10

  // Bruteforce all possible combinations (within valid timings)
  for (j = 0; j <= 3; j++)
  begin
  	  stimulus = j;
  	  strobe_n = stimulus[0];
  	  select = stimulus[1];

	  for (i = 0; i <= 31; i++)
	  begin
	  	a = i[3:0];
	  	b = i[7:4];
	  	#10;

	  	for (k = 0; k <= 3; k++)
	  	begin
	  	  test_single_multiplexer(strobe_n, select, a[k], b[k], y[k]);
	  	end
  	  end
  end

  // Corner cases
  a = 4'b0101;
  b = 4'b1010;
  
end

task test_single_multiplexer
(
	input strobe_n,
	input select,
	input A,
	input B,
	input Y
);

// Verification over truth table from datasheet
casex ( { strobe_n, select, A, B })
	'b1xxx: assert (Y == 0) else $display("[%t]: Expected Y=0, found Y=%b for strobe_n=%b, select=%b, A=%b, B=%b", $time, Y, strobe_n, select, A, B);
	'b000x: assert (Y == 0) else $display("[%t]: Expected Y=0, found Y=%b for strobe_n=%b, select=%b, A=%b, B=%b", $time, Y, strobe_n, select, A, B);
	'b001x: assert (Y == 1) else $display("[%t]: Expected Y=1, found Y=%b for strobe_n=%b, select=%b, A=%b, B=%b", $time, Y, strobe_n, select, A, B);
	'b01x0: assert (Y == 0) else $display("[%t]: Expected Y=0, found Y=%b for strobe_n=%b, select=%b, A=%b, B=%b", $time, Y, strobe_n, select, A, B);
	'b01x1: assert (Y == 1) else $display("[%t]: Expected Y=1, found Y=%b for strobe_n=%b, select=%b, A=%b, B=%b", $time, Y, strobe_n, select, A, B);
endcase

endtask

endmodule

module dff_7474_tb();
logic nR;
logic D;
logic C;
logic nS;
logic Q;
logic nQ;

logic [3:0] stimulus;
logic prevQ;
logic prevnQ;
integer seed;

dff_7474 DUT
(
  .nR(nR),
  .D(D),
  .C(C),
  .nS(nS),
  .Q(Q),
  .nQ(nQ)
);

initial begin
  // Set up time printing format to nanoseconds with no decimal precision digits
  // $timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
  $timeformat(-9, 0, " ns", 3);

  C = 1'b0;   // Initial clock state is low
  nR = 1'b0;  // Reset is active (low)
  prevQ = 1'b1;
  prevnQ = 1'b0;
  #10;

repeat(10)
begin
for (int i = 0; i < (2**3 - 1); i++)
begin
  stimulus = i;

  prevQ = Q;
  prevnQ = nQ;

  nR = stimulus[0];
  D = stimulus[1];
  nS = stimulus[2];

  #3;

  // Verification over truth table from datasheet
  casex ( { nS, nR, C, D } )
    'b01xx: assert(Q == 1 && nQ == 0) else $display("[%t]: Expected Q=1, nQ=0; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
    'b10xx: assert(Q == 0 && nQ == 1) else $display("[%t]: Expected Q=0, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
    'b00xx: assert(Q == 1 && nQ == 1) else $display("[%t]: Special handling required. Expected Q=1, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
    'b1111: assert(Q == 1 && nQ == 0) else $display("[%t]: Expected Q=0, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
    'b1110: assert(Q == 0 && nQ == 1) else $display("[%t]: Expected Q=0, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
    'b110x: assert(Q == prevQ && nQ == prevnQ) else $display("[%t]: Expected Q=%b (prevQ), nQ=%b (prevnQ); Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, prevQ, prevnQ, Q, nQ, nS, nR, C, D);
  endcase

  // Test validity on raising clock edge
  @(posedge C)
  begin
    casex ( { nS, nR, C, D } )
      'b1111: assert(Q == 1 && nQ == 0) else $display("[%t]: Clock rising. Expected Q=1, nQ=0; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
      'b1110: assert(Q == 0 && nQ == 1) else $display("[%t]: Clock rising. Expected Q=0, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
    endcase
  end
end
end

// End test phase
nR = 'x;
nS = 'x;
D = 'x;
prevQ = 'x;
prevnQ = 'x;

#10;

  // Exploratory testing
  /*
  nR = 1'b0;  // Reset is active (low)
  prevQ = 1'b1;
  prevnQ = 1'b0;
  nS = 1'b1;

  #10

  repeat(100)
  begin
    // ModelSim does not support randomize due it's greediness. Need Questa for that.
    //randomize(nR) with { nR inside {[0:1]}; };
    //randomize(D) with { D inside {[0:1]}; };
    //randomize(nS) with { D inside {[0:1]}; };

    // Poor's man randomize()
    nR = $dist_uniform(seed, 0, 1);
    D = $dist_uniform(seed, 0, 1);
    nS = $dist_uniform(seed, 0, 1);

    #10;

    repeat(10)
    begin
      prevQ = Q;
      prevnQ = nQ;
      
      D = ~D;
      #9;

      // Verification over truth table from datasheet
      casex ( { nS, nR, C, D } )
        'b01xx: assert(Q == 1 && nQ == 0) else $display("[%t]: Expected Q=1, nQ=0; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
        'b10xx: assert(Q == 0 && nQ == 1) else $display("[%t]: Expected Q=0, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
        'b00xx: assert(Q == 0 && nQ == 1) else $display("[%t]: Expected Q=0, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
        'b110x: assert(Q == prevQ && nQ == prevnQ) else $display("[%t]: Expected Q=%b (prevQ), nQ=%b (prevnQ); Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, prevQ, prevnQ, Q, nQ, nS, nR, C, D);
      endcase

      // Test validity on raising clock edge
      @(posedge C)
      begin
        casex  ( { nS, nR, C, D } )
          'b1111: assert(Q == 1 && nQ == 0) else $display("[%t]: Expected Q=1, nQ=0; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
          'b1110: assert(Q == 0 && nQ == 1) else $display("[%t]: Expected Q=0, nQ=1; Found Q=%b, nQ=%b for nS=%b, nR=%b, C=%b, D=%b", $time, Q, nQ, nS, nR, C, D);
        endcase
      end
    end
  end
  */

end

// 100MHz clock
always #5 C = ~C;

initial begin
  #1000 $stop;
end

endmodule

module dff_74174_tb();
logic clr_n;
logic clk;
logic [5:0] D;
logic [5:0] Q;

dff_74174 DUT
(
  .clr_n(clr_n),
  .clk(clk),
  .D(D),
  .Q(Q)
);

initial begin
  // Set up time printing format to nanoseconds with no decimal precision digits
  // $timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
  $timeformat(-9, 0, " ns", 3);

  clk = 1'b0;
  clr_n = 1'b0;
  D = 0;
  #50;
  clr_n = 1'b1;
  #50;

  for (int i = 0; i <= 63; i++)
  begin
    D = i;
    clk = 1'b1;
    #25;
    clk = 1'b0;
    #25;
  end

  #100;
  D = 6'b101010;
  #20;
  clk = 1'b1;
  D = 6'b010101;
  #20;
end


// 20MHz clock
//always #25 clk = ~clk;

initial begin
  #3500 $stop;
end

endmodule

module counter_74193_tb();
logic clr;
logic up;
logic down;
logic load_n;
logic [3:0] P;
logic co_n;
logic bo_n;
logic [3:0] Q;

counter_74193 DUT
(
  .clr(clr),
  .up(up),
  .down(down),
  .load_n(load_n),
  .P(P),

  .co_n(co_n),
  .bo_n(bo_n),
  .Q(Q)
);

initial begin
  clr = 1'b0;
  up = 1'b1;
  down = 1'b1;
  load_n = 1'b1;
  P = 4'b1111;
  #10;
  clr = 1'b1;
  #10;
  clr = 1'b0;
  #10;

  // Test 1: counting up through 15 and ripple count overflow flag set
  P = 4'b0000;
  load_n = 1'b0;
  #10;
  load_n = 1'b1;
  #10;

  for (int i = 0; i <= 20; i++)
  begin
    up = 1'b0;
    #5;
    up = 1'b1;
    #5;
  end

  // Delimiter between tests
  P = 4'bxxxx;
  up = 1'bx;
  down = 1'bx;
  clr = 1'bx;
  #10;
  clr = 1'b0;
  up = 1'b0;
  down = 1'b0;
  // End of delimiter between tests

  // Test 2: counding down through zero and borrow flag set
  P = 4'b1111;
  up = 1'b0;
  load_n = 1'b0;
  #10;
  load_n = 1'b1;
  #10;

  for (int i = 20; i >= 0; i--)
  begin
    down = 1'b0;
    #5;
    down = 1'b1;
    #5;
  end
end

endmodule

module counter_74169_tb();
logic clk;
logic direction;
logic load_n;
logic ent_n;
logic enp_n;
logic [3:0] P;
logic rco_n;
logic [3:0] Q;

counter_74169 DUT
(
  .clk(clk),
  .direction(direction),
  .load_n(load_n),
  .ent_n(ent_n),
  .enp_n(enp_n),
  .P(P),
  .rco_n(rco_n),
  .Q(Q)
);

initial begin
  // Set up time printing format to nanoseconds with no decimal precision digits
  // $timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
  $timeformat(-9, 0, " ns", 3);

  clk = 1'b0;
  enp_n = 1'b1;
  ent_n = 1'b1;
  load_n = 1'b1;
  P = 4'b1111;
  #5;
  load_n = 1'b0;
  #10;
  load_n = 1'b1;
  #5;

  // Test 1: Count up from 0 to 15 through ripple count set and overflow
  direction = 1'b1;
  P = 4'b0000;
  load_n = 1'b0;
  #10;
  load_n = 1'b1;
  #10;

  for (int i = 0; i <= 20; i++)
  begin
    enp_n = 1'b0;
    ent_n = 1'b0;
    #10;
    enp_n = 1'b1;
    ent_n = 1'b1;
  end

  // Delimiter between tests
  P = 4'bxxxx;
  direction = 1'bx;
  enp_n = 1'bx;
  ent_n = 1'bx;
  load_n = 1'bx;
  #10;
  // End of delimiter between tests

  // Test 2: Count down from 15 to 0 through ripple count set and overflow
  direction = 1'b0;
  P = 4'b1111;
  load_n = 1'b0;
  #10;
  load_n = 1'b1;
  #10;

  for (int i = 20; i >= 0; i--)
  begin
    enp_n = 1'b0;
    ent_n = 1'b0;
    #10;
    enp_n = 1'b1;
    ent_n = 1'b1;
  end

  // Delimiter between tests
  P = 4'bxxxx;
  direction = 1'bx;
  enp_n = 1'bx;
  ent_n = 1'bx;
  load_n = 1'bx;
  #10;
  // End of delimiter between tests
end

// 100MHz clock
always #5 clk = ~clk;

// Force stop after 1000ns
initial begin
  #1000 $stop;
end

endmodule

module counter_74163_tb();
logic clk;
logic clr_n;
logic enp;
logic ent;
logic load_n;
logic [3:0] P;
logic [3:0] Q;

counter_74163 DUT
(
  .clk(clk),
  .clr_n(clr_n),
  .enp(enp),
  .ent(ent),
  .load_n(load_n),
  .P(P),

  .Q(Q),
  .rco(rco)
);

initial begin
  // Set up time printing format to nanoseconds with no decimal precision digits
  // $timeformat [ ( units_number , precision_number , suffix_string , minimum_field_width ) ] ;
  $timeformat(-9, 0, " ns", 3);

  clk = 1'b0;
  enp = 1'b0;
  ent = 1'b0;
  load_n = 1'b1;
  P = 4'b1111;
  clr_n = 1'b0;
  #10;

  // Release reset state
  clr_n = 1'b1;
  #10;

  // Load zero as initial counter state
  $display("[%t]: Load 0 as initial value", $time);
  P = 4'b0000;
  #10
  load_n = 1'b0;
  #10
  load_n = 1'b1;
  #10;

  $display("[%t]: Regular count test", $time);
  enp = 1'b1;
  ent = 1'b1;
  for (int i = 0; i <= 20; i++)
  begin
    #10;
  end

  // Test inhibition (both enp and ent have to be raised to continue counting)
  $display("[%t]: Inhibition started", $time);
  enp = 1'b0;
  ent = 1'b1;
  #50;
  enp = 1'b1;
  ent = 1'b0;
  #50;
  $display("[%t]: Inhibition ended", $time);

  for (int i = 0; i <= 10; i++)
  begin
    if (i <= 5)
    begin
      enp = i % 2;
      ent = 1'b1;
    end
    else
    begin
      enp = 1'b1;
      ent = i % 2;
    end
    #10;
  end

  // Delimiter between tests
  P = 4'bxxxx;
  enp = 1'bx;
  ent = 1'bx;
  load_n = 1'bx;
  #10;
  // End of delimiter between tests

  #50
  $stop;
end

// 100MHz clock
always #5 clk = ~clk;

endmodule