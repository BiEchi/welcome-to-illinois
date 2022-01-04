module  cursor_click (input         Clk,                // 50 MHz clock
                      Reset,              // Active-high reset signal
                      frame_clk,          // The clock indicating a new frame (~60Hz)
                      input [9:0]   DrawX, DrawY,       // Current pixel coordinates
                      input logic [9:0] XMOV_MOUSE,YMOV_MOUSE, //position of our mouse
                      //					input logic STOREBEGIN,STOREEND,
                      //					input logic [7:0] X_CHANGE,Y_CHANGE,
                      output logic  is_mouse,          // Whether current pixel belongs to ball or background
                      output logic  [9:0] Ball_X_OUT,Ball_Y_OUT
                     );

  parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
  parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
  parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
  parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
  parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
  parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
  parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
  parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
  parameter [9:0] Ball_Size = 10'd3;        // Ball size

  logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
  logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
  logic [7:0] w,a,s,d,space;



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

  always_ff @ (posedge Clk)
  begin
    if (Reset)
    begin
      Ball_X_Pos <= Ball_X_Center;
      Ball_Y_Pos <= Ball_Y_Center;
    end
    else
    begin
      Ball_X_Pos <= Ball_X_Pos_in;
      Ball_Y_Pos <= Ball_Y_Pos_in;
    end
  end

  always_comb
  begin
    // By default, keep Motion and position unchanged
    Ball_X_Pos_in = Ball_X_Pos;
    Ball_Y_Pos_in = Ball_Y_Pos;
    //        Ball_X_Motion_in = Ball_X_Motion;
    //        Ball_Y_Motion_in = Ball_Y_Motion;

    // Update position and Motion only at rising edge of frame clock
    if (frame_clk_rising_edge)
    begin
      Ball_X_Pos_in=XMOV_MOUSE;
      Ball_Y_Pos_in=YMOV_MOUSE;
    end

  end

  int DistX, DistY, Size;
  assign DistX = DrawX - Ball_X_Pos;
  assign DistY = DrawY - Ball_Y_Pos;
  assign Size = Ball_Size;
  always_comb
  begin
    if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) )
      is_mouse = 1'b1;
    else
      is_mouse = 1'b0;
  end

endmodule
