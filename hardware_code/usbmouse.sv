module  usbmouse (input         Clk,                // 50 MHz clock
                    Reset,              // Active-high reset signal
                    frame_clk,          // The clock indicating a new frame (~60Hz)
                    input [9:0]   DrawX, DrawY,       // Current pixel coordinates
                    input logic [7:0] keycode,
                    input logic STOREBEGIN,STOREEND,
                    output logic  is_usbmouse,          // Whether current pixel belongs to ball or background
                    output logic [9:0] Ball_X_OUT, Ball_Y_OUT
                   );

  parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
  parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
  parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
  parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
  parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
  parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
  parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
  parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
  parameter [9:0] Ball_Size = 10'd10;        // Ball size

  logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
  logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
  logic [7:0] w,a,s,d,space;

  logic [9:0] BEGINX,BEGINY,ENDX,ENDY;

  logic flip, flip_in, data_cursor;

  assign w=8'b00011010;
  assign a=8'b00000100;
  assign s=8'b00010110;
  assign d=8'b00000111;
  assign space=8'h2c;

  assign Ball_X_OUT=Ball_X_Pos;
  assign Ball_Y_OUT=Ball_Y_Pos;

  //////// Do not modify the always_ff blocks. ////////
  // Detect rising edge of frame_clk
  logic frame_clk_delayed, frame_clk_rising_edge;
  always_ff @ (posedge Clk)
  begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
  end
  // Update registers
  always_ff @ (STOREBEGIN)
  begin
    BEGINX<=Ball_X_Pos;
    BEGINY<=Ball_Y_Pos;
  end

  always_ff @ (STOREEND)
  begin
    ENDX<=Ball_X_Pos;
    ENDY<=Ball_Y_Pos;
  end

  always_ff @ (posedge Clk)
  begin
    if (Reset)
    begin
      Ball_X_Pos <= 10'd0;
      Ball_Y_Pos <= 10'd0;
      Ball_X_Motion <= 10'd0;
      Ball_Y_Motion <= 10'd0;
      flip <= 1'b0;
    end
    else
    begin
      Ball_X_Pos <= Ball_X_Pos_in;
      Ball_Y_Pos <= Ball_Y_Pos_in;
      Ball_X_Motion <= Ball_X_Motion_in;
      Ball_Y_Motion <= Ball_Y_Motion_in;
      flip <= flip_in;
    end
  end
  //////// Do not modify the always_ff blocks. ////////

  // You need to modify always_comb block.
  always_comb
  begin
    // By default, keep Motion, position, and flip status unchanged
    Ball_X_Pos_in = Ball_X_Pos;
    Ball_Y_Pos_in = Ball_Y_Pos;
    Ball_X_Motion_in = Ball_X_Motion;
    Ball_Y_Motion_in = Ball_Y_Motion;
    flip_in = flip;

    // Update position and Motion only at rising edge of frame clock
    if (frame_clk_rising_edge)
    begin
      if (keycode==w)
      begin
        Ball_Y_Motion_in=(~(Ball_Y_Step)+1'b1);
        Ball_X_Motion_in=10'd0;
      end
      else if (keycode==a)
      begin
        Ball_X_Motion_in=(~(Ball_X_Step)+1'b1);
        Ball_Y_Motion_in=10'd0;
        flip_in = 1'b1;
      end
      else if (keycode==s)
      begin
        Ball_Y_Motion_in=Ball_Y_Step;
        Ball_X_Motion_in=10'd0;
      end
      else if (keycode==d)
      begin
        Ball_X_Motion_in=Ball_X_Step;
        Ball_Y_Motion_in=10'd0;
        flip_in = 1'b0;
      end
      else if (keycode==8'd0)
      begin
        Ball_X_Motion_in=10'd0;
        Ball_Y_Motion_in=10'd0;
      end

      // Update the ball's position with its Motion
      Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
      Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
    end

  end

  // Compute whether the pixel corresponds to ball or background
  int DistX, DistY, Size;
  assign DistX = DrawX - Ball_X_Pos;
  assign DistY = DrawY - Ball_Y_Pos;
  assign Size = Ball_Size;


  // bug: the cursor does not move. should debug below.
  ramstore_cursor store_cursor(
                    .CLK_50(Clk), // clock must be 50MHz
                    .RESET(Reset),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .BallX(Ball_X_Pos),
                    .BallY(Ball_Y_Pos),
                    .flip(flip), // 1'b1 if flip
                    .data_cursor(data_cursor)
                  );


  // this decides the shape of the cursor to be a ball
  always_comb
  begin
    // the data should be decided by the cursor and the size should be inside the the range.
    if ( data_cursor == 1'b1 && ( DistX*DistX + DistY*DistY) <= (Size*Size) )
      is_usbmouse = 1'b1;
    else
      is_usbmouse = 1'b0;

  end

endmodule
