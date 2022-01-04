//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,PS2_CLK,
               input        [3:0]  KEY,          //bit 0 is set up as Reset
               input [15:0] SW,
               input [9:0] XMOV_MOUSE,YMOV_MOUSE,// the position data of PS2 mouse
               input LEFT,RIGHT,					//Left button and right button active signal of PS2 mouse
               output logic [7:0]  VGA_R,        //VGA Red
               VGA_G,        //VGA Green
               VGA_B,        //VGA Blue
               output logic        VGA_CLK,      //VGA Clock
               VGA_SYNC_N,   //VGA Sync signal
               VGA_BLANK_N,  //VGA Blank signal
               VGA_VS,       //VGA virtical sync signal
               VGA_HS,       //VGA horizontal sync signal

               // CY7C67200 Interface
               inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
               output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
               output logic        OTG_CS_N,     //CY7C67200 Chip Select
               OTG_RD_N,     //CY7C67200 Write
               OTG_WR_N,     //CY7C67200 Read
               OTG_RST_N,    //CY7C67200 Reset
               input               OTG_INT,      //CY7C67200 Interrupt

               // SDRAM Interface for Nios II Software
               output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
               inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
               output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
               output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
               output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
               
               DRAM_CAS_N,   //SDRAM Column Address Strobe
               DRAM_CKE,     //SDRAM Clock Enable
               DRAM_WE_N,    //SDRAM Write Enable
               DRAM_CS_N,    //SDRAM Chip Select
               DRAM_CLK,      //SDRAM Clock

               output logic [7:0] keycode,
               output logic [7:0] HEX0, HEX1
             );

  logic Reset_h,Reset_s, Clk, SetColor,is_mouse,is_usbmouse,numbercode1,numbercode2,data5,controlsignal,data_km;
  logic [7:0] led;
  logic [31:0] path1_export,path2_export,path3_export,path4_export;
  logic [31:0] distancehigh;
  logic [31:0] distancelow;

  assign Clk = CLOCK_50;
  always_ff @ (posedge Clk)
  begin
    Reset_h <= ~(KEY[0]);        // The push buttons are active low
    Reset_s <= ~(KEY[1]);
    SetColor <= ~(SW[0]);
  end


  logic CLOCK_25;
  always_ff @(posedge CLOCK_50)
  begin
    if(Reset_h)
      CLOCK_25 <= 1'b0;
    else
      CLOCK_25 <= ~CLOCK_25;
  end

  logic [31:0] beginpoint,endpoint;
  logic [1:0] hpi_addr;
  logic [15:0] hpi_data_in, hpi_data_out;
  logic hpi_r, hpi_w, hpi_cs, hpi_reset;

  //Using for color_mapper input
  logic [9:0] DrawX, DrawY,Ball_X_OUT, Ball_Y_OUT,Ball_X_OUT1, Ball_Y_OUT1;
  logic [9:0] pos_x_out, pos_y_out;
  logic [7:0] start_pos,seed;
  logic [1:0] data,data4;

  logic is_ball;

  logic STOREBEGIN,STOREEND;

  logic cityname;
  logic [31:0] storedata;

  ramstore store(.*);
  ramstore2 store2(.*);
  ramstore3 store3(.*);
  ramstore4 store4(.*);
  ramstore5 store5(.*);

  ramstore_km store_km(
                .DrawX(DrawX),
                .DrawY(DrawY),
                .data_km(data_km)
              ); // output km

// Interface between NIOS II and EZ-OTG chip
hpi_io_intf hpi_io_inst(
              .Clk(Clk),
              .Reset(Reset_h),
              // signals connected to NIOS II
              .from_sw_address(hpi_addr),
              .from_sw_data_in(hpi_data_in),
              .from_sw_data_out(hpi_data_out),
              .from_sw_r(hpi_r),
              .from_sw_w(hpi_w),
              .from_sw_cs(hpi_cs),
              .from_sw_reset(hpi_reset),
              // signals connected to EZ-OTG chip
              .OTG_DATA(OTG_DATA),
              .OTG_ADDR(OTG_ADDR),
              .OTG_RD_N(OTG_RD_N),
              .OTG_WR_N(OTG_WR_N),
              .OTG_CS_N(OTG_CS_N),
              .OTG_RST_N(OTG_RST_N)
            );

// You need to make sure that the port names here match the ports in Qsys-generated codes.
lab8_soc nios_system(
           .clk_clk(Clk),
           .reset_reset_n(1'b1),    // Never reset NIOS
           .sdram_wire_addr(DRAM_ADDR),
           .sdram_wire_ba(DRAM_BA),
           .sdram_wire_cas_n(DRAM_CAS_N),
           .sdram_wire_cke(DRAM_CKE),
           .sdram_wire_cs_n(DRAM_CS_N),
           .sdram_wire_dq(DRAM_DQ),
           .sdram_wire_dqm(DRAM_DQM),
           .sdram_wire_ras_n(DRAM_RAS_N),
           .sdram_wire_we_n(DRAM_WE_N),
           .sdram_clk_clk(DRAM_CLK),
           .keycode_export(keycode),
           .otg_hpi_address_export(hpi_addr),
           .otg_hpi_data_in_port(hpi_data_in),
           .otg_hpi_data_out_port(hpi_data_out),
           .otg_hpi_cs_export(hpi_cs),
           .otg_hpi_r_export(hpi_r),
           .otg_hpi_w_export(hpi_w),
           .otg_hpi_reset_export(hpi_reset),
           .path1_export(path1_export),
           .path2_export(path2_export),
           .path3_export(path3_export),
           .path4_export(path4_export),
           .pos_x_export(pos_x_out),
           .pos_y_export(pos_y_out),
           .beginpoint_export(beginpoint),
           .endpoint_export(endpoint),
           .distancehigh_export(distancehigh),
           .distancelow_export(distancelow),

           .finish_acc_export(FINISH),
           .start_acc_export(START),
           .source_index_acc_export(SOURCE_INDEX),
           .target_index_acc_export(TARGET_INDEX),
           .min_path_length_acc_export(MIN_PATH_LENGTH),
           .debug_min_index_export(DEBUG_MIN_INDEX),
           .debug_min_num_export(DEBUG_MIN_NUM),
           .debug_state_export(DEBUG_STATE)
         );


logic START;
logic [7:0] SOURCE_INDEX, TARGET_INDEX;
logic FINISH;
logic [15:0] MIN_PATH_LENGTH;
logic [2:0] DEBUG_STATE;
logic [6:0] DEBUG_MIN_INDEX;
logic [15:0] DEBUG_MIN_NUM;

accelerator accelerator_inst (.CLK(CLOCK_25), 
                              .RESET(Reset_h),
                              .START(START),
                              .SOURCE_INDEX(SOURCE_INDEX),
                              .TARGET_INDEX(TARGET_INDEX),
                              .FINISH(FINISH),
                              .MIN_PATH_LENGTH(MIN_PATH_LENGTH),
                              .DEBUG_STATE(DEBUG_STATE),
                              .DEBUG_MIN_INDEX(DEBUG_MIN_INDEX),
                              .DEBUG_MIN_NUM(DEBUG_MIN_NUM));

// state machine
INPUTCONTROL(.Reset(Reset_h),.*);

// display controller
vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
VGA_controller vga_controller_instance(.Reset(Reset_h), .*);

// keyboard input
mouseclick mouse(.Reset(Reset_h),.YMOV_MOUSE(10'd479-YMOV_MOUSE), .frame_clk(VGA_VS), .*);
color_mapper_mouse color_instance(.*);
detect_mouse detectmouse_input(.*);
usbmouse usbmouseclick(.Reset(Reset_h), .frame_clk(VGA_VS), .Ball_X_OUT(Ball_X_OUT1),.Ball_Y_OUT(Ball_Y_OUT1), .*);

// display the keycode onto the FPGA Hex board
HexDriver hex_inst_0 (keycode[3:0], HEX0);
HexDriver hex_inst_1 (keycode[7:4], HEX1);

endmodule
