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

module selector_74253_tb();
reg [3:0] input_1c;
reg [3:0] input_2c;
reg [1:0] select;
reg output_control_1g_n;
reg output_control_2g_n;
wire [1:0] y;

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

module dff_7474_tb();
reg nR;
reg D;
reg C;
reg nS;
wire Q;
wire nQ;

reg [3:0] stimulus;
reg prevQ;
reg prevnQ;
integer i;
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

  repeat(5)
  begin
    for (i = 0; i < 15; i++)
    begin
      stimulus = i;

      prevQ = Q;
      prevnQ = nQ;

      nR = stimulus[0];
      D = stimulus[1];
      nS = stimulus[2];

      #8;

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
        casex  ( { nS, nR, C, D } )
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