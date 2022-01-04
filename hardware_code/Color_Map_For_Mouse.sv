//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper_mouse (   input [1:0]  data,data4,     // Whether current pixel belongs to ball or background (computed in ball.sv)
                                 input        is_mouse,is_usbmouse, data5, controlsignal,
                                 input [31:0] path1_export,path2_export,path3_export,path4_export,beginpoint,endpoint,
                                 input [15:0] SW,
                                 input [7:0]  keycode,
                                 input logic [9:0] Ball_X_OUT,Ball_Y_OUT,Ball_X_OUT1,Ball_Y_OUT1,
                                 input        LEFT,RIGHT,
                                 input [9:0]  DrawX, DrawY,
                                 input        cityname,numbercode1,numbercode2,data_km,
                                 output logic [7:0] VGA_R, VGA_G, VGA_B,
                                 output logic [31:0] storedata
                             );

  logic [7:0] Red, Green, Blue, Q,E; //Q means start, E means End.
  logic [31:0] Center_X_begin, Center_Y_begin, Center_X_end, Center_Y_end;
  //position of different cities
  parameter [97:0][1:0][31:0] IndexArray=
            {{ 32'd24, 32'd128 },
             { 32'd45, 32'd168 },
             { 32'd51, 32'd216 },
             { 32'd72, 32'd440 },
             { 32'd83, 32'd430 },
             { 32'd95, 32'd414 },
             { 32'd112, 32'd406 },
             { 32'd96, 32'd392 },
             { 32'd72, 32'd373 },
             { 32'd85, 32'd286 },
             { 32'd86, 32'd222 },
             { 32'd85, 32'd194 },
             { 32'd79, 32'd176 },
             { 32'd50, 32'd127 },
             { 32'd105, 32'd87 },
             { 32'd102, 32'd135 },
             { 32'd111, 32'd232 },
             { 32'd121, 32'd139 },
             { 32'd142, 32'd124 },
             { 32'd180, 32'd117 },
             { 32'd240, 32'd112 },
             { 32'd159, 32'd305 },
             { 32'd173, 32'd354 },
             { 32'd184, 32'd405 },
             { 32'd222, 32'd405 },
             { 32'd259, 32'd406 },
             { 32'd230, 32'd378 },
             { 32'd225, 32'd325 },
             { 32'd252, 32'd306 },
             { 32'd253, 32'd254 },
             { 32'd188, 32'd270 },
             { 32'd245, 32'd198 },
             { 32'd209, 32'd163 },
             { 32'd138, 32'd147 },
             { 32'd299, 32'd144 },
             { 32'd314, 32'd110 },
             { 32'd248, 32'd447 },
             { 32'd214, 32'd458 },
             { 32'd239, 32'd428 },
             { 32'd282, 32'd434 },
             { 32'd284, 32'd416 },
             { 32'd380, 32'd421 },
             { 32'd377, 32'd449 },
             { 32'd426, 32'd419 },
             { 32'd422, 32'd453 },
             { 32'd476, 32'd419 },
             { 32'd500, 32'd418 },
             { 32'd548, 32'd416 },
             { 32'd577, 32'd416 },
             { 32'd620, 32'd414 },
             { 32'd582, 32'd384 },
             { 32'd588, 32'd343 },
             { 32'd586, 32'd318 },
             { 32'd591, 32'd307 },
             { 32'd544, 32'd274 },
             { 32'd570, 32'd249 },
             { 32'd577, 32'd224 },
             { 32'd576, 32'd196 },
             { 32'd568, 32'd140 },
             { 32'd561, 32'd121 },
             { 32'd557, 32'd92 },
             { 32'd590, 32'd95 },
             { 32'd493, 32'd97 },
             { 32'd490, 32'd117 },
             { 32'd471, 32'd200 },
             { 32'd455, 32'd249 },
             { 32'd476, 32'd247 },
             { 32'd410, 32'd247 },
             { 32'd449, 32'd269 },
             { 32'd443, 32'd316 },
             { 32'd394, 32'd318 },
             { 32'd435, 32'd339 },
             { 32'd430, 32'd357 },
             { 32'd480, 32'd343 },
             { 32'd504, 32'd339 },
             { 32'd493, 32'd316 },
             { 32'd547, 32'd164 },
             { 32'd520, 32'd165 },
             { 32'd461, 32'd396 },
             { 32'd497, 32'd381 },
             { 32'd352, 32'd380 },
             { 32'd311, 32'd391 },
             { 32'd314, 32'd351 },
             { 32'd351, 32'd343 },
             { 32'd357, 32'd318 },
             { 32'd369, 32'd284 },
             { 32'd378, 32'd248 },
             { 32'd400, 32'd200 },
             { 32'd431, 32'd166 },
             { 32'd304, 32'd240 },
             { 32'd342, 32'd206 },
             { 32'd389, 32'd136 },
             { 32'd339, 32'd168 },
             { 32'd419, 32'd103 },
             { 32'd392, 32'd104 },
             { 32'd360, 32'd108 },
             { 32'd335, 32'd273 },
            };
  // Output colors to VGA
  assign VGA_R = Red;
  assign VGA_G = Green;
  assign VGA_B = Blue;
  logic flagsee;
  logic flagnosee;

  always_comb
  begin
    storedata=32'd0;
    if (Ball_X_OUT <= 10'd28 && Ball_X_OUT >= 10'd20 && Ball_Y_OUT <= 10'd132 && Ball_Y_OUT >= 10'd124)
      storedata = 32'd1;  // Elm
    if (Ball_X_OUT <= 10'd49 && Ball_X_OUT >= 10'd41 && Ball_Y_OUT <= 10'd172 && Ball_Y_OUT >= 10'd164)
      storedata = 32'd2;  // Glasford
    if (Ball_X_OUT <= 10'd55 && Ball_X_OUT >= 10'd47 && Ball_Y_OUT <= 10'd220 && Ball_Y_OUT >= 10'd212)
      storedata = 32'd3;  // Manito
    if (Ball_X_OUT <= 10'd76 && Ball_X_OUT >= 10'd68 && Ball_Y_OUT <= 10'd444 && Ball_Y_OUT >= 10'd436)
      storedata = 32'd4;  // Jct
    if (Ball_X_OUT <= 10'd87 && Ball_X_OUT >= 10'd79 && Ball_Y_OUT <= 10'd434 && Ball_Y_OUT >= 10'd426)
      storedata = 32'd5;  // lles
    if (Ball_X_OUT <= 10'd99 && Ball_X_OUT >= 10'd91 && Ball_Y_OUT <= 10'd418 && Ball_Y_OUT >= 10'd410)
      storedata = 32'd6;  // Starnes
    if (Ball_X_OUT <= 10'd116 && Ball_X_OUT >= 10'd108 && Ball_Y_OUT <= 10'd410 && Ball_Y_OUT >= 10'd402)
      storedata = 32'd7;  // Riverton
    if (Ball_X_OUT <= 10'd100 && Ball_X_OUT >= 10'd92 && Ball_Y_OUT <= 10'd396 && Ball_Y_OUT >= 10'd388)
      storedata = 32'd8;  // Sherman
    if (Ball_X_OUT <= 10'd76 && Ball_X_OUT >= 10'd68 && Ball_Y_OUT <= 10'd377 && Ball_Y_OUT >= 10'd369)
      storedata = 32'd9;  // BarrStation
    if (Ball_X_OUT <= 10'd89 && Ball_X_OUT >= 10'd81 && Ball_Y_OUT <= 10'd290 && Ball_Y_OUT >= 10'd282)
      storedata = 32'd10;  // Luther
    if (Ball_X_OUT <= 10'd90 && Ball_X_OUT >= 10'd82 && Ball_Y_OUT <= 10'd226 && Ball_Y_OUT >= 10'd218)
      storedata = 32'd11;  // GreenValley
    if (Ball_X_OUT <= 10'd89 && Ball_X_OUT >= 10'd81 && Ball_Y_OUT <= 10'd198 && Ball_Y_OUT >= 10'd190)
      storedata = 32'd12;  // SouthPekin
    if (Ball_X_OUT <= 10'd83 && Ball_X_OUT >= 10'd75 && Ball_Y_OUT <= 10'd180 && Ball_Y_OUT >= 10'd172)
      storedata = 32'd13;  // Powerton
    if (Ball_X_OUT <= 10'd54 && Ball_X_OUT >= 10'd46 && Ball_Y_OUT <= 10'd131 && Ball_Y_OUT >= 10'd123)
      storedata = 32'd14;  // HannaCity
    if (Ball_X_OUT <= 10'd109 && Ball_X_OUT >= 10'd101 && Ball_Y_OUT <= 10'd91 && Ball_Y_OUT >= 10'd83)
      storedata = 32'd15;  // Mossville
    if (Ball_X_OUT <= 10'd106 && Ball_X_OUT >= 10'd98 && Ball_Y_OUT <= 10'd139 && Ball_Y_OUT >= 10'd131)
      storedata = 32'd16;  // EastPeoria
    if (Ball_X_OUT <= 10'd115 && Ball_X_OUT >= 10'd107 && Ball_Y_OUT <= 10'd236 && Ball_Y_OUT >= 10'd228)
      storedata = 32'd17;  // Delavan
    if (Ball_X_OUT <= 10'd125 && Ball_X_OUT >= 10'd117 && Ball_Y_OUT <= 10'd143 && Ball_Y_OUT >= 10'd135)
      storedata = 32'd18;  // Farmdale
    if (Ball_X_OUT <= 10'd146 && Ball_X_OUT >= 10'd138 && Ball_Y_OUT <= 10'd128 && Ball_Y_OUT >= 10'd120)
      storedata = 32'd19;  // Washington
    if (Ball_X_OUT <= 10'd184 && Ball_X_OUT >= 10'd176 && Ball_Y_OUT <= 10'd121 && Ball_Y_OUT >= 10'd113)
      storedata = 32'd20;  // Eureka
    if (Ball_X_OUT <= 10'd244 && Ball_X_OUT >= 10'd236 && Ball_Y_OUT <= 10'd116 && Ball_Y_OUT >= 10'd108)
      storedata = 32'd21;  // ElPaso
    if (Ball_X_OUT <= 10'd163 && Ball_X_OUT >= 10'd155 && Ball_Y_OUT <= 10'd309 && Ball_Y_OUT >= 10'd301)
      storedata = 32'd22;  // Lincoin
    if (Ball_X_OUT <= 10'd177 && Ball_X_OUT >= 10'd169 && Ball_Y_OUT <= 10'd358 && Ball_Y_OUT >= 10'd350)
      storedata = 32'd23;  // Mt.Pulaski
    if (Ball_X_OUT <= 10'd188 && Ball_X_OUT >= 10'd180 && Ball_Y_OUT <= 10'd409 && Ball_Y_OUT >= 10'd401)
      storedata = 32'd24;  // Illiopoils
    if (Ball_X_OUT <= 10'd226 && Ball_X_OUT >= 10'd218 && Ball_Y_OUT <= 10'd409 && Ball_Y_OUT >= 10'd401)
      storedata = 32'd25;  // Harristown
    if (Ball_X_OUT <= 10'd263 && Ball_X_OUT >= 10'd255 && Ball_Y_OUT <= 10'd410 && Ball_Y_OUT >= 10'd402)
      storedata = 32'd26;  // Decatur
    if (Ball_X_OUT <= 10'd234 && Ball_X_OUT >= 10'd226 && Ball_Y_OUT <= 10'd382 && Ball_Y_OUT >= 10'd374)
      storedata = 32'd27;  // Warrensburg
    if (Ball_X_OUT <= 10'd229 && Ball_X_OUT >= 10'd221 && Ball_Y_OUT <= 10'd329 && Ball_Y_OUT >= 10'd321)
      storedata = 32'd28;  // Kenney
    if (Ball_X_OUT <= 10'd256 && Ball_X_OUT >= 10'd248 && Ball_Y_OUT <= 10'd310 && Ball_Y_OUT >= 10'd302)
      storedata = 32'd29;  // Clinton
    if (Ball_X_OUT <= 10'd257 && Ball_X_OUT >= 10'd249 && Ball_Y_OUT <= 10'd258 && Ball_Y_OUT >= 10'd250)
      storedata = 32'd30;  // Heyworth
    if (Ball_X_OUT <= 10'd192 && Ball_X_OUT >= 10'd184 && Ball_Y_OUT <= 10'd274 && Ball_Y_OUT >= 10'd266)
      storedata = 32'd31;  // Atlanta
    if (Ball_X_OUT <= 10'd249 && Ball_X_OUT >= 10'd241 && Ball_Y_OUT <= 10'd202 && Ball_Y_OUT >= 10'd194)
      storedata = 32'd32;  // Bloomington
    if (Ball_X_OUT <= 10'd213 && Ball_X_OUT >= 10'd205 && Ball_Y_OUT <= 10'd167 && Ball_Y_OUT >= 10'd159)
      storedata = 32'd33;  // Carlock
    if (Ball_X_OUT <= 10'd142 && Ball_X_OUT >= 10'd134 && Ball_Y_OUT <= 10'd151 && Ball_Y_OUT >= 10'd143)
      storedata = 32'd34;  // Crandall
    if (Ball_X_OUT <= 10'd303 && Ball_X_OUT >= 10'd295 && Ball_Y_OUT <= 10'd148 && Ball_Y_OUT >= 10'd140)
      storedata = 32'd35;  // Lexington
    if (Ball_X_OUT <= 10'd318 && Ball_X_OUT >= 10'd310 && Ball_Y_OUT <= 10'd114 && Ball_Y_OUT >= 10'd106)
      storedata = 32'd36;  // Chenoa
    if (Ball_X_OUT <= 10'd252 && Ball_X_OUT >= 10'd244 && Ball_Y_OUT <= 10'd451 && Ball_Y_OUT >= 10'd443)
      storedata = 32'd37;  // Macon
    if (Ball_X_OUT <= 10'd218 && Ball_X_OUT >= 10'd210 && Ball_Y_OUT <= 10'd462 && Ball_Y_OUT >= 10'd454)
      storedata = 32'd38;  // BlueMound
    if (Ball_X_OUT <= 10'd243 && Ball_X_OUT >= 10'd235 && Ball_Y_OUT <= 10'd432 && Ball_Y_OUT >= 10'd424)
      storedata = 32'd39;  // Boody
    if (Ball_X_OUT <= 10'd286 && Ball_X_OUT >= 10'd278 && Ball_Y_OUT <= 10'd438 && Ball_Y_OUT >= 10'd430)
      storedata = 32'd40;  // HerveyCity
    if (Ball_X_OUT <= 10'd288 && Ball_X_OUT >= 10'd280 && Ball_Y_OUT <= 10'd420 && Ball_Y_OUT >= 10'd412)
      storedata = 32'd41;  // LongCreek
    if (Ball_X_OUT <= 10'd384 && Ball_X_OUT >= 10'd376 && Ball_Y_OUT <= 10'd425 && Ball_Y_OUT >= 10'd417)
      storedata = 32'd42;  // Atwood
    if (Ball_X_OUT <= 10'd381 && Ball_X_OUT >= 10'd373 && Ball_Y_OUT <= 10'd453 && Ball_Y_OUT >= 10'd445)
      storedata = 32'd43;  // Arthur
    if (Ball_X_OUT <= 10'd430 && Ball_X_OUT >= 10'd422 && Ball_Y_OUT <= 10'd423 && Ball_Y_OUT >= 10'd415)
      storedata = 32'd44;  // Tuscola
    if (Ball_X_OUT <= 10'd426 && Ball_X_OUT >= 10'd418 && Ball_Y_OUT <= 10'd457 && Ball_Y_OUT >= 10'd449)
      storedata = 32'd45;  // Arcola
    if (Ball_X_OUT <= 10'd480 && Ball_X_OUT >= 10'd472 && Ball_Y_OUT <= 10'd423 && Ball_Y_OUT >= 10'd415)
      storedata = 32'd46;  // Murdock
    if (Ball_X_OUT <= 10'd504 && Ball_X_OUT >= 10'd496 && Ball_Y_OUT <= 10'd422 && Ball_Y_OUT >= 10'd414)
      storedata = 32'd47;  // Newman
    if (Ball_X_OUT <= 10'd552 && Ball_X_OUT >= 10'd544 && Ball_Y_OUT <= 10'd420 && Ball_Y_OUT >= 10'd412)
      storedata = 32'd48;  // Metcalf
    if (Ball_X_OUT <= 10'd581 && Ball_X_OUT >= 10'd573 && Ball_Y_OUT <= 10'd420 && Ball_Y_OUT >= 10'd412)
      storedata = 32'd49;  // Chrisman
    if (Ball_X_OUT <= 10'd624 && Ball_X_OUT >= 10'd616 && Ball_Y_OUT <= 10'd418 && Ball_Y_OUT >= 10'd410)
      storedata = 32'd50;  // WestDana
    if (Ball_X_OUT <= 10'd586 && Ball_X_OUT >= 10'd578 && Ball_Y_OUT <= 10'd388 && Ball_Y_OUT >= 10'd380)
      storedata = 32'd51;  // RidgeFarm
    if (Ball_X_OUT <= 10'd592 && Ball_X_OUT >= 10'd584 && Ball_Y_OUT <= 10'd347 && Ball_Y_OUT >= 10'd339)
      storedata = 32'd52;  // Westville
    if (Ball_X_OUT <= 10'd590 && Ball_X_OUT >= 10'd582 && Ball_Y_OUT <= 10'd322 && Ball_Y_OUT >= 10'd314)
      storedata = 32'd53;  // Tilton
    if (Ball_X_OUT <= 10'd595 && Ball_X_OUT >= 10'd587 && Ball_Y_OUT <= 10'd311 && Ball_Y_OUT >= 10'd303)
      storedata = 32'd54;  // Danville
    if (Ball_X_OUT <= 10'd548 && Ball_X_OUT >= 10'd540 && Ball_Y_OUT <= 10'd278 && Ball_Y_OUT >= 10'd270)
      storedata = 32'd55;  // Collison
    if (Ball_X_OUT <= 10'd574 && Ball_X_OUT >= 10'd566 && Ball_Y_OUT <= 10'd253 && Ball_Y_OUT >= 10'd245)
      storedata = 32'd56;  // Henning
    if (Ball_X_OUT <= 10'd581 && Ball_X_OUT >= 10'd573 && Ball_Y_OUT <= 10'd228 && Ball_Y_OUT >= 10'd220)
      storedata = 32'd57;  // Rossville
    if (Ball_X_OUT <= 10'd580 && Ball_X_OUT >= 10'd572 && Ball_Y_OUT <= 10'd200 && Ball_Y_OUT >= 10'd192)
      storedata = 32'd58;  // Hoopston
    if (Ball_X_OUT <= 10'd572 && Ball_X_OUT >= 10'd564 && Ball_Y_OUT <= 10'd144 && Ball_Y_OUT >= 10'd136)
      storedata = 32'd59;  // Milford
    if (Ball_X_OUT <= 10'd565 && Ball_X_OUT >= 10'd557 && Ball_Y_OUT <= 10'd125 && Ball_Y_OUT >= 10'd117)
      storedata = 32'd60;  // WoodlandJct.
    if (Ball_X_OUT <= 10'd561 && Ball_X_OUT >= 10'd553 && Ball_Y_OUT <= 10'd96 && Ball_Y_OUT >= 10'd88)
      storedata = 32'd61;  // Watseka
    if (Ball_X_OUT <= 10'd594 && Ball_X_OUT >= 10'd586 && Ball_Y_OUT <= 10'd99 && Ball_Y_OUT >= 10'd91)
      storedata = 32'd62;  // Webster
    if (Ball_X_OUT <= 10'd497 && Ball_X_OUT >= 10'd489 && Ball_Y_OUT <= 10'd101 && Ball_Y_OUT >= 10'd93)
      storedata = 32'd63;  // Gilman
    if (Ball_X_OUT <= 10'd494 && Ball_X_OUT >= 10'd486 && Ball_Y_OUT <= 10'd121 && Ball_Y_OUT >= 10'd113)
      storedata = 32'd64;  // Onarga
    if (Ball_X_OUT <= 10'd475 && Ball_X_OUT >= 10'd467 && Ball_Y_OUT <= 10'd204 && Ball_Y_OUT >= 10'd196)
      storedata = 32'd65;  // Paxton
    if (Ball_X_OUT <= 10'd459 && Ball_X_OUT >= 10'd451 && Ball_Y_OUT <= 10'd253 && Ball_Y_OUT >= 10'd245)
      storedata = 32'd66;  // Rantoul
    if (Ball_X_OUT <= 10'd480 && Ball_X_OUT >= 10'd472 && Ball_Y_OUT <= 10'd251 && Ball_Y_OUT >= 10'd243)
      storedata = 32'd67;  // Dillsburg
    if (Ball_X_OUT <= 10'd414 && Ball_X_OUT >= 10'd406 && Ball_Y_OUT <= 10'd251 && Ball_Y_OUT >= 10'd243)
      storedata = 32'd68;  // Fisher
    if (Ball_X_OUT <= 10'd453 && Ball_X_OUT >= 10'd445 && Ball_Y_OUT <= 10'd273 && Ball_Y_OUT >= 10'd265)
      storedata = 32'd69;  // Thomasboro
    if (Ball_X_OUT <= 10'd447 && Ball_X_OUT >= 10'd439 && Ball_Y_OUT <= 10'd320 && Ball_Y_OUT >= 10'd312)
      storedata = 32'd70;  // Urbana
    if (Ball_X_OUT <= 10'd398 && Ball_X_OUT >= 10'd390 && Ball_Y_OUT <= 10'd322 && Ball_Y_OUT >= 10'd314)
      storedata = 32'd71;  // Champaign
    if (Ball_X_OUT <= 10'd439 && Ball_X_OUT >= 10'd431 && Ball_Y_OUT <= 10'd343 && Ball_Y_OUT >= 10'd335)
      storedata = 32'd72;  // Savoy
    if (Ball_X_OUT <= 10'd434 && Ball_X_OUT >= 10'd426 && Ball_Y_OUT <= 10'd361 && Ball_Y_OUT >= 10'd353)
      storedata = 32'd73;  // Tolono
    if (Ball_X_OUT <= 10'd484 && Ball_X_OUT >= 10'd476 && Ball_Y_OUT <= 10'd347 && Ball_Y_OUT >= 10'd339)
      storedata = 32'd74;  // Sidney
    if (Ball_X_OUT <= 10'd508 && Ball_X_OUT >= 10'd500 && Ball_Y_OUT <= 10'd343 && Ball_Y_OUT >= 10'd335)
      storedata = 32'd75;  // Homer
    if (Ball_X_OUT <= 10'd497 && Ball_X_OUT >= 10'd489 && Ball_Y_OUT <= 10'd320 && Ball_Y_OUT >= 10'd312)
      storedata = 32'd76;  // Glover
    if (Ball_X_OUT <= 10'd551 && Ball_X_OUT >= 10'd543 && Ball_Y_OUT <= 10'd168 && Ball_Y_OUT >= 10'd160)
      storedata = 32'd77;  // Goodwine
    if (Ball_X_OUT <= 10'd524 && Ball_X_OUT >= 10'd516 && Ball_Y_OUT <= 10'd169 && Ball_Y_OUT >= 10'd161)
      storedata = 32'd78;  // CissnaPark
    if (Ball_X_OUT <= 10'd465 && Ball_X_OUT >= 10'd457 && Ball_Y_OUT <= 10'd400 && Ball_Y_OUT >= 10'd392)
      storedata = 32'd79;  // VillaGrove
    if (Ball_X_OUT <= 10'd501 && Ball_X_OUT >= 10'd493 && Ball_Y_OUT <= 10'd385 && Ball_Y_OUT >= 10'd377)
      storedata = 32'd80;  // Boradland
    if (Ball_X_OUT <= 10'd356 && Ball_X_OUT >= 10'd348 && Ball_Y_OUT <= 10'd384 && Ball_Y_OUT >= 10'd376)
      storedata = 32'd81;  // Bement
    if (Ball_X_OUT <= 10'd315 && Ball_X_OUT >= 10'd307 && Ball_Y_OUT <= 10'd395 && Ball_Y_OUT >= 10'd387)
      storedata = 32'd82;  // CerroGordo
    if (Ball_X_OUT <= 10'd318 && Ball_X_OUT >= 10'd310 && Ball_Y_OUT <= 10'd355 && Ball_Y_OUT >= 10'd347)
      storedata = 32'd83;  // Cisco
    if (Ball_X_OUT <= 10'd355 && Ball_X_OUT >= 10'd347 && Ball_Y_OUT <= 10'd347 && Ball_Y_OUT >= 10'd339)
      storedata = 32'd84;  // Monticello
    if (Ball_X_OUT <= 10'd361 && Ball_X_OUT >= 10'd353 && Ball_Y_OUT <= 10'd322 && Ball_Y_OUT >= 10'd314)
      storedata = 32'd85;  // Lodge
    if (Ball_X_OUT <= 10'd373 && Ball_X_OUT >= 10'd365 && Ball_Y_OUT <= 10'd288 && Ball_Y_OUT >= 10'd280)
      storedata = 32'd86;  // Mansfield
    if (Ball_X_OUT <= 10'd382 && Ball_X_OUT >= 10'd374 && Ball_Y_OUT <= 10'd252 && Ball_Y_OUT >= 10'd244)
      storedata = 32'd87;  // Lotus
    if (Ball_X_OUT <= 10'd404 && Ball_X_OUT >= 10'd396 && Ball_Y_OUT <= 10'd204 && Ball_Y_OUT >= 10'd196)
      storedata = 32'd88;  // GibsonCity
    if (Ball_X_OUT <= 10'd435 && Ball_X_OUT >= 10'd427 && Ball_Y_OUT <= 10'd170 && Ball_Y_OUT >= 10'd162)
      storedata = 32'd89;  // Melvin
    if (Ball_X_OUT <= 10'd308 && Ball_X_OUT >= 10'd300 && Ball_Y_OUT <= 10'd244 && Ball_Y_OUT >= 10'd236)
      storedata = 32'd90;  // LeRoy
    if (Ball_X_OUT <= 10'd346 && Ball_X_OUT >= 10'd338 && Ball_Y_OUT <= 10'd210 && Ball_Y_OUT >= 10'd202)
      storedata = 32'd91;  // Arrowsmith
    if (Ball_X_OUT <= 10'd393 && Ball_X_OUT >= 10'd385 && Ball_Y_OUT <= 10'd140 && Ball_Y_OUT >= 10'd132)
      storedata = 32'd92;  // Risk
    if (Ball_X_OUT <= 10'd343 && Ball_X_OUT >= 10'd335 && Ball_Y_OUT <= 10'd172 && Ball_Y_OUT >= 10'd164)
      storedata = 32'd93;  // Colfax
    if (Ball_X_OUT <= 10'd423 && Ball_X_OUT >= 10'd415 && Ball_Y_OUT <= 10'd107 && Ball_Y_OUT >= 10'd99)
      storedata = 32'd94;  // Chatsworth
    if (Ball_X_OUT <= 10'd396 && Ball_X_OUT >= 10'd388 && Ball_Y_OUT <= 10'd108 && Ball_Y_OUT >= 10'd100)
      storedata = 32'd95;  // Forrest
    if (Ball_X_OUT <= 10'd364 && Ball_X_OUT >= 10'd356 && Ball_Y_OUT <= 10'd112 && Ball_Y_OUT >= 10'd104)
      storedata = 32'd96;  // Fairbury
    if (Ball_X_OUT <= 10'd339 && Ball_X_OUT >= 10'd331 && Ball_Y_OUT <= 10'd277 && Ball_Y_OUT >= 10'd269)
      storedata = 32'd97;  // FarmerCity





    //usb part
    if (Ball_X_OUT1 <= 10'd28 && Ball_X_OUT1 >= 10'd20 && Ball_Y_OUT1 <= 10'd132 && Ball_Y_OUT1 >= 10'd124)
      storedata = 32'd1;  // Elm
    if (Ball_X_OUT1 <= 10'd49 && Ball_X_OUT1 >= 10'd41 && Ball_Y_OUT1 <= 10'd172 && Ball_Y_OUT1 >= 10'd164)
      storedata = 32'd2;  // Glasford
    if (Ball_X_OUT1 <= 10'd55 && Ball_X_OUT1 >= 10'd47 && Ball_Y_OUT1 <= 10'd220 && Ball_Y_OUT1 >= 10'd212)
      storedata = 32'd3;  // Manito
    if (Ball_X_OUT1 <= 10'd76 && Ball_X_OUT1 >= 10'd68 && Ball_Y_OUT1 <= 10'd444 && Ball_Y_OUT1 >= 10'd436)
      storedata = 32'd4;  // Jct
    if (Ball_X_OUT1 <= 10'd87 && Ball_X_OUT1 >= 10'd79 && Ball_Y_OUT1 <= 10'd434 && Ball_Y_OUT1 >= 10'd426)
      storedata = 32'd5;  // lles
    if (Ball_X_OUT1 <= 10'd99 && Ball_X_OUT1 >= 10'd91 && Ball_Y_OUT1 <= 10'd418 && Ball_Y_OUT1 >= 10'd410)
      storedata = 32'd6;  // Starnes
    if (Ball_X_OUT1 <= 10'd116 && Ball_X_OUT1 >= 10'd108 && Ball_Y_OUT1 <= 10'd410 && Ball_Y_OUT1 >= 10'd402)
      storedata = 32'd7;  // Riverton
    if (Ball_X_OUT1 <= 10'd100 && Ball_X_OUT1 >= 10'd92 && Ball_Y_OUT1 <= 10'd396 && Ball_Y_OUT1 >= 10'd388)
      storedata = 32'd8;  // Sherman
    if (Ball_X_OUT1 <= 10'd76 && Ball_X_OUT1 >= 10'd68 && Ball_Y_OUT1 <= 10'd377 && Ball_Y_OUT1 >= 10'd369)
      storedata = 32'd9;  // BarrStation
    if (Ball_X_OUT1 <= 10'd89 && Ball_X_OUT1 >= 10'd81 && Ball_Y_OUT1 <= 10'd290 && Ball_Y_OUT1 >= 10'd282)
      storedata = 32'd10;  // Luther
    if (Ball_X_OUT1 <= 10'd90 && Ball_X_OUT1 >= 10'd82 && Ball_Y_OUT1 <= 10'd226 && Ball_Y_OUT1 >= 10'd218)
      storedata = 32'd11;  // GreenValley
    if (Ball_X_OUT1 <= 10'd89 && Ball_X_OUT1 >= 10'd81 && Ball_Y_OUT1 <= 10'd198 && Ball_Y_OUT1 >= 10'd190)
      storedata = 32'd12;  // SouthPekin
    if (Ball_X_OUT1 <= 10'd83 && Ball_X_OUT1 >= 10'd75 && Ball_Y_OUT1 <= 10'd180 && Ball_Y_OUT1 >= 10'd172)
      storedata = 32'd13;  // Powerton
    if (Ball_X_OUT1 <= 10'd54 && Ball_X_OUT1 >= 10'd46 && Ball_Y_OUT1 <= 10'd131 && Ball_Y_OUT1 >= 10'd123)
      storedata = 32'd14;  // HannaCity
    if (Ball_X_OUT1 <= 10'd109 && Ball_X_OUT1 >= 10'd101 && Ball_Y_OUT1 <= 10'd91 && Ball_Y_OUT1 >= 10'd83)
      storedata = 32'd15;  // Mossville
    if (Ball_X_OUT1 <= 10'd106 && Ball_X_OUT1 >= 10'd98 && Ball_Y_OUT1 <= 10'd139 && Ball_Y_OUT1 >= 10'd131)
      storedata = 32'd16;  // EastPeoria
    if (Ball_X_OUT1 <= 10'd115 && Ball_X_OUT1 >= 10'd107 && Ball_Y_OUT1 <= 10'd236 && Ball_Y_OUT1 >= 10'd228)
      storedata = 32'd17;  // Delavan
    if (Ball_X_OUT1 <= 10'd125 && Ball_X_OUT1 >= 10'd117 && Ball_Y_OUT1 <= 10'd143 && Ball_Y_OUT1 >= 10'd135)
      storedata = 32'd18;  // Farmdale
    if (Ball_X_OUT1 <= 10'd146 && Ball_X_OUT1 >= 10'd138 && Ball_Y_OUT1 <= 10'd128 && Ball_Y_OUT1 >= 10'd120)
      storedata = 32'd19;  // Washington
    if (Ball_X_OUT1 <= 10'd184 && Ball_X_OUT1 >= 10'd176 && Ball_Y_OUT1 <= 10'd121 && Ball_Y_OUT1 >= 10'd113)
      storedata = 32'd20;  // Eureka
    if (Ball_X_OUT1 <= 10'd244 && Ball_X_OUT1 >= 10'd236 && Ball_Y_OUT1 <= 10'd116 && Ball_Y_OUT1 >= 10'd108)
      storedata = 32'd21;  // ElPaso
    if (Ball_X_OUT1 <= 10'd163 && Ball_X_OUT1 >= 10'd155 && Ball_Y_OUT1 <= 10'd309 && Ball_Y_OUT1 >= 10'd301)
      storedata = 32'd22;  // Lincoin
    if (Ball_X_OUT1 <= 10'd177 && Ball_X_OUT1 >= 10'd169 && Ball_Y_OUT1 <= 10'd358 && Ball_Y_OUT1 >= 10'd350)
      storedata = 32'd23;  // Mt.Pulaski
    if (Ball_X_OUT1 <= 10'd188 && Ball_X_OUT1 >= 10'd180 && Ball_Y_OUT1 <= 10'd409 && Ball_Y_OUT1 >= 10'd401)
      storedata = 32'd24;  // Illiopoils
    if (Ball_X_OUT1 <= 10'd226 && Ball_X_OUT1 >= 10'd218 && Ball_Y_OUT1 <= 10'd409 && Ball_Y_OUT1 >= 10'd401)
      storedata = 32'd25;  // Harristown
    if (Ball_X_OUT1 <= 10'd263 && Ball_X_OUT1 >= 10'd255 && Ball_Y_OUT1 <= 10'd410 && Ball_Y_OUT1 >= 10'd402)
      storedata = 32'd26;  // Decatur
    if (Ball_X_OUT1 <= 10'd234 && Ball_X_OUT1 >= 10'd226 && Ball_Y_OUT1 <= 10'd382 && Ball_Y_OUT1 >= 10'd374)
      storedata = 32'd27;  // Warrensburg
    if (Ball_X_OUT1 <= 10'd229 && Ball_X_OUT1 >= 10'd221 && Ball_Y_OUT1 <= 10'd329 && Ball_Y_OUT1 >= 10'd321)
      storedata = 32'd28;  // Kenney
    if (Ball_X_OUT1 <= 10'd256 && Ball_X_OUT1 >= 10'd248 && Ball_Y_OUT1 <= 10'd310 && Ball_Y_OUT1 >= 10'd302)
      storedata = 32'd29;  // Clinton
    if (Ball_X_OUT1 <= 10'd257 && Ball_X_OUT1 >= 10'd249 && Ball_Y_OUT1 <= 10'd258 && Ball_Y_OUT1 >= 10'd250)
      storedata = 32'd30;  // Heyworth
    if (Ball_X_OUT1 <= 10'd192 && Ball_X_OUT1 >= 10'd184 && Ball_Y_OUT1 <= 10'd274 && Ball_Y_OUT1 >= 10'd266)
      storedata = 32'd31;  // Atlanta
    if (Ball_X_OUT1 <= 10'd249 && Ball_X_OUT1 >= 10'd241 && Ball_Y_OUT1 <= 10'd202 && Ball_Y_OUT1 >= 10'd194)
      storedata = 32'd32;  // Bloomington
    if (Ball_X_OUT1 <= 10'd213 && Ball_X_OUT1 >= 10'd205 && Ball_Y_OUT1 <= 10'd167 && Ball_Y_OUT1 >= 10'd159)
      storedata = 32'd33;  // Carlock
    if (Ball_X_OUT1 <= 10'd142 && Ball_X_OUT1 >= 10'd134 && Ball_Y_OUT1 <= 10'd151 && Ball_Y_OUT1 >= 10'd143)
      storedata = 32'd34;  // Crandall
    if (Ball_X_OUT1 <= 10'd303 && Ball_X_OUT1 >= 10'd295 && Ball_Y_OUT1 <= 10'd148 && Ball_Y_OUT1 >= 10'd140)
      storedata = 32'd35;  // Lexington
    if (Ball_X_OUT1 <= 10'd318 && Ball_X_OUT1 >= 10'd310 && Ball_Y_OUT1 <= 10'd114 && Ball_Y_OUT1 >= 10'd106)
      storedata = 32'd36;  // Chenoa
    if (Ball_X_OUT1 <= 10'd252 && Ball_X_OUT1 >= 10'd244 && Ball_Y_OUT1 <= 10'd451 && Ball_Y_OUT1 >= 10'd443)
      storedata = 32'd37;  // Macon
    if (Ball_X_OUT1 <= 10'd218 && Ball_X_OUT1 >= 10'd210 && Ball_Y_OUT1 <= 10'd462 && Ball_Y_OUT1 >= 10'd454)
      storedata = 32'd38;  // BlueMound
    if (Ball_X_OUT1 <= 10'd243 && Ball_X_OUT1 >= 10'd235 && Ball_Y_OUT1 <= 10'd432 && Ball_Y_OUT1 >= 10'd424)
      storedata = 32'd39;  // Boody
    if (Ball_X_OUT1 <= 10'd286 && Ball_X_OUT1 >= 10'd278 && Ball_Y_OUT1 <= 10'd438 && Ball_Y_OUT1 >= 10'd430)
      storedata = 32'd40;  // HerveyCity
    if (Ball_X_OUT1 <= 10'd288 && Ball_X_OUT1 >= 10'd280 && Ball_Y_OUT1 <= 10'd420 && Ball_Y_OUT1 >= 10'd412)
      storedata = 32'd41;  // LongCreek
    if (Ball_X_OUT1 <= 10'd384 && Ball_X_OUT1 >= 10'd376 && Ball_Y_OUT1 <= 10'd425 && Ball_Y_OUT1 >= 10'd417)
      storedata = 32'd42;  // Atwood
    if (Ball_X_OUT1 <= 10'd381 && Ball_X_OUT1 >= 10'd373 && Ball_Y_OUT1 <= 10'd453 && Ball_Y_OUT1 >= 10'd445)
      storedata = 32'd43;  // Arthur
    if (Ball_X_OUT1 <= 10'd430 && Ball_X_OUT1 >= 10'd422 && Ball_Y_OUT1 <= 10'd423 && Ball_Y_OUT1 >= 10'd415)
      storedata = 32'd44;  // Tuscola
    if (Ball_X_OUT1 <= 10'd426 && Ball_X_OUT1 >= 10'd418 && Ball_Y_OUT1 <= 10'd457 && Ball_Y_OUT1 >= 10'd449)
      storedata = 32'd45;  // Arcola
    if (Ball_X_OUT1 <= 10'd480 && Ball_X_OUT1 >= 10'd472 && Ball_Y_OUT1 <= 10'd423 && Ball_Y_OUT1 >= 10'd415)
      storedata = 32'd46;  // Murdock
    if (Ball_X_OUT1 <= 10'd504 && Ball_X_OUT1 >= 10'd496 && Ball_Y_OUT1 <= 10'd422 && Ball_Y_OUT1 >= 10'd414)
      storedata = 32'd47;  // Newman
    if (Ball_X_OUT1 <= 10'd552 && Ball_X_OUT1 >= 10'd544 && Ball_Y_OUT1 <= 10'd420 && Ball_Y_OUT1 >= 10'd412)
      storedata = 32'd48;  // Metcalf
    if (Ball_X_OUT1 <= 10'd581 && Ball_X_OUT1 >= 10'd573 && Ball_Y_OUT1 <= 10'd420 && Ball_Y_OUT1 >= 10'd412)
      storedata = 32'd49;  // Chrisman
    if (Ball_X_OUT1 <= 10'd624 && Ball_X_OUT1 >= 10'd616 && Ball_Y_OUT1 <= 10'd418 && Ball_Y_OUT1 >= 10'd410)
      storedata = 32'd50;  // WestDana
    if (Ball_X_OUT1 <= 10'd586 && Ball_X_OUT1 >= 10'd578 && Ball_Y_OUT1 <= 10'd388 && Ball_Y_OUT1 >= 10'd380)
      storedata = 32'd51;  // RidgeFarm
    if (Ball_X_OUT1 <= 10'd592 && Ball_X_OUT1 >= 10'd584 && Ball_Y_OUT1 <= 10'd347 && Ball_Y_OUT1 >= 10'd339)
      storedata = 32'd52;  // Westville
    if (Ball_X_OUT1 <= 10'd590 && Ball_X_OUT1 >= 10'd582 && Ball_Y_OUT1 <= 10'd322 && Ball_Y_OUT1 >= 10'd314)
      storedata = 32'd53;  // Tilton
    if (Ball_X_OUT1 <= 10'd595 && Ball_X_OUT1 >= 10'd587 && Ball_Y_OUT1 <= 10'd311 && Ball_Y_OUT1 >= 10'd303)
      storedata = 32'd54;  // Danville
    if (Ball_X_OUT1 <= 10'd548 && Ball_X_OUT1 >= 10'd540 && Ball_Y_OUT1 <= 10'd278 && Ball_Y_OUT1 >= 10'd270)
      storedata = 32'd55;  // Collison
    if (Ball_X_OUT1 <= 10'd574 && Ball_X_OUT1 >= 10'd566 && Ball_Y_OUT1 <= 10'd253 && Ball_Y_OUT1 >= 10'd245)
      storedata = 32'd56;  // Henning
    if (Ball_X_OUT1 <= 10'd581 && Ball_X_OUT1 >= 10'd573 && Ball_Y_OUT1 <= 10'd228 && Ball_Y_OUT1 >= 10'd220)
      storedata = 32'd57;  // Rossville
    if (Ball_X_OUT1 <= 10'd580 && Ball_X_OUT1 >= 10'd572 && Ball_Y_OUT1 <= 10'd200 && Ball_Y_OUT1 >= 10'd192)
      storedata = 32'd58;  // Hoopston
    if (Ball_X_OUT1 <= 10'd572 && Ball_X_OUT1 >= 10'd564 && Ball_Y_OUT1 <= 10'd144 && Ball_Y_OUT1 >= 10'd136)
      storedata = 32'd59;  // Milford
    if (Ball_X_OUT1 <= 10'd565 && Ball_X_OUT1 >= 10'd557 && Ball_Y_OUT1 <= 10'd125 && Ball_Y_OUT1 >= 10'd117)
      storedata = 32'd60;  // WoodlandJct.
    if (Ball_X_OUT1 <= 10'd561 && Ball_X_OUT1 >= 10'd553 && Ball_Y_OUT1 <= 10'd96 && Ball_Y_OUT1 >= 10'd88)
      storedata = 32'd61;  // Watseka
    if (Ball_X_OUT1 <= 10'd594 && Ball_X_OUT1 >= 10'd586 && Ball_Y_OUT1 <= 10'd99 && Ball_Y_OUT1 >= 10'd91)
      storedata = 32'd62;  // Webster
    if (Ball_X_OUT1 <= 10'd497 && Ball_X_OUT1 >= 10'd489 && Ball_Y_OUT1 <= 10'd101 && Ball_Y_OUT1 >= 10'd93)
      storedata = 32'd63;  // Gilman
    if (Ball_X_OUT1 <= 10'd494 && Ball_X_OUT1 >= 10'd486 && Ball_Y_OUT1 <= 10'd121 && Ball_Y_OUT1 >= 10'd113)
      storedata = 32'd64;  // Onarga
    if (Ball_X_OUT1 <= 10'd475 && Ball_X_OUT1 >= 10'd467 && Ball_Y_OUT1 <= 10'd204 && Ball_Y_OUT1 >= 10'd196)
      storedata = 32'd65;  // Paxton
    if (Ball_X_OUT1 <= 10'd459 && Ball_X_OUT1 >= 10'd451 && Ball_Y_OUT1 <= 10'd253 && Ball_Y_OUT1 >= 10'd245)
      storedata = 32'd66;  // Rantoul
    if (Ball_X_OUT1 <= 10'd480 && Ball_X_OUT1 >= 10'd472 && Ball_Y_OUT1 <= 10'd251 && Ball_Y_OUT1 >= 10'd243)
      storedata = 32'd67;  // Dillsburg
    if (Ball_X_OUT1 <= 10'd414 && Ball_X_OUT1 >= 10'd406 && Ball_Y_OUT1 <= 10'd251 && Ball_Y_OUT1 >= 10'd243)
      storedata = 32'd68;  // Fisher
    if (Ball_X_OUT1 <= 10'd453 && Ball_X_OUT1 >= 10'd445 && Ball_Y_OUT1 <= 10'd273 && Ball_Y_OUT1 >= 10'd265)
      storedata = 32'd69;  // Thomasboro
    if (Ball_X_OUT1 <= 10'd447 && Ball_X_OUT1 >= 10'd439 && Ball_Y_OUT1 <= 10'd320 && Ball_Y_OUT1 >= 10'd312)
      storedata = 32'd70;  // Urbana
    if (Ball_X_OUT1 <= 10'd398 && Ball_X_OUT1 >= 10'd390 && Ball_Y_OUT1 <= 10'd322 && Ball_Y_OUT1 >= 10'd314)
      storedata = 32'd71;  // Champaign
    if (Ball_X_OUT1 <= 10'd439 && Ball_X_OUT1 >= 10'd431 && Ball_Y_OUT1 <= 10'd343 && Ball_Y_OUT1 >= 10'd335)
      storedata = 32'd72;  // Savoy
    if (Ball_X_OUT1 <= 10'd434 && Ball_X_OUT1 >= 10'd426 && Ball_Y_OUT1 <= 10'd361 && Ball_Y_OUT1 >= 10'd353)
      storedata = 32'd73;  // Tolono
    if (Ball_X_OUT1 <= 10'd484 && Ball_X_OUT1 >= 10'd476 && Ball_Y_OUT1 <= 10'd347 && Ball_Y_OUT1 >= 10'd339)
      storedata = 32'd74;  // Sidney
    if (Ball_X_OUT1 <= 10'd508 && Ball_X_OUT1 >= 10'd500 && Ball_Y_OUT1 <= 10'd343 && Ball_Y_OUT1 >= 10'd335)
      storedata = 32'd75;  // Homer
    if (Ball_X_OUT1 <= 10'd497 && Ball_X_OUT1 >= 10'd489 && Ball_Y_OUT1 <= 10'd320 && Ball_Y_OUT1 >= 10'd312)
      storedata = 32'd76;  // Glover
    if (Ball_X_OUT1 <= 10'd551 && Ball_X_OUT1 >= 10'd543 && Ball_Y_OUT1 <= 10'd168 && Ball_Y_OUT1 >= 10'd160)
      storedata = 32'd77;  // Goodwine
    if (Ball_X_OUT1 <= 10'd524 && Ball_X_OUT1 >= 10'd516 && Ball_Y_OUT1 <= 10'd169 && Ball_Y_OUT1 >= 10'd161)
      storedata = 32'd78;  // CissnaPark
    if (Ball_X_OUT1 <= 10'd465 && Ball_X_OUT1 >= 10'd457 && Ball_Y_OUT1 <= 10'd400 && Ball_Y_OUT1 >= 10'd392)
      storedata = 32'd79;  // VillaGrove
    if (Ball_X_OUT1 <= 10'd501 && Ball_X_OUT1 >= 10'd493 && Ball_Y_OUT1 <= 10'd385 && Ball_Y_OUT1 >= 10'd377)
      storedata = 32'd80;  // Boradland
    if (Ball_X_OUT1 <= 10'd356 && Ball_X_OUT1 >= 10'd348 && Ball_Y_OUT1 <= 10'd384 && Ball_Y_OUT1 >= 10'd376)
      storedata = 32'd81;  // Bement
    if (Ball_X_OUT1 <= 10'd315 && Ball_X_OUT1 >= 10'd307 && Ball_Y_OUT1 <= 10'd395 && Ball_Y_OUT1 >= 10'd387)
      storedata = 32'd82;  // CerroGordo
    if (Ball_X_OUT1 <= 10'd318 && Ball_X_OUT1 >= 10'd310 && Ball_Y_OUT1 <= 10'd355 && Ball_Y_OUT1 >= 10'd347)
      storedata = 32'd83;  // Cisco
    if (Ball_X_OUT1 <= 10'd355 && Ball_X_OUT1 >= 10'd347 && Ball_Y_OUT1 <= 10'd347 && Ball_Y_OUT1 >= 10'd339)
      storedata = 32'd84;  // Monticello
    if (Ball_X_OUT1 <= 10'd361 && Ball_X_OUT1 >= 10'd353 && Ball_Y_OUT1 <= 10'd322 && Ball_Y_OUT1 >= 10'd314)
      storedata = 32'd85;  // Lodge
    if (Ball_X_OUT1 <= 10'd373 && Ball_X_OUT1 >= 10'd365 && Ball_Y_OUT1 <= 10'd288 && Ball_Y_OUT1 >= 10'd280)
      storedata = 32'd86;  // Mansfield
    if (Ball_X_OUT1 <= 10'd382 && Ball_X_OUT1 >= 10'd374 && Ball_Y_OUT1 <= 10'd252 && Ball_Y_OUT1 >= 10'd244)
      storedata = 32'd87;  // Lotus
    if (Ball_X_OUT1 <= 10'd404 && Ball_X_OUT1 >= 10'd396 && Ball_Y_OUT1 <= 10'd204 && Ball_Y_OUT1 >= 10'd196)
      storedata = 32'd88;  // GibsonCity
    if (Ball_X_OUT1 <= 10'd435 && Ball_X_OUT1 >= 10'd427 && Ball_Y_OUT1 <= 10'd170 && Ball_Y_OUT1 >= 10'd162)
      storedata = 32'd89;  // Melvin
    if (Ball_X_OUT1 <= 10'd308 && Ball_X_OUT1 >= 10'd300 && Ball_Y_OUT1 <= 10'd244 && Ball_Y_OUT1 >= 10'd236)
      storedata = 32'd90;  // LeRoy
    if (Ball_X_OUT1 <= 10'd346 && Ball_X_OUT1 >= 10'd338 && Ball_Y_OUT1 <= 10'd210 && Ball_Y_OUT1 >= 10'd202)
      storedata = 32'd91;  // Arrowsmith
    if (Ball_X_OUT1 <= 10'd393 && Ball_X_OUT1 >= 10'd385 && Ball_Y_OUT1 <= 10'd140 && Ball_Y_OUT1 >= 10'd132)
      storedata = 32'd92;  // Risk
    if (Ball_X_OUT1 <= 10'd343 && Ball_X_OUT1 >= 10'd335 && Ball_Y_OUT1 <= 10'd172 && Ball_Y_OUT1 >= 10'd164)
      storedata = 32'd93;  // Colfax
    if (Ball_X_OUT1 <= 10'd423 && Ball_X_OUT1 >= 10'd415 && Ball_Y_OUT1 <= 10'd107 && Ball_Y_OUT1 >= 10'd99)
      storedata = 32'd94;  // Chatsworth
    if (Ball_X_OUT1 <= 10'd396 && Ball_X_OUT1 >= 10'd388 && Ball_Y_OUT1 <= 10'd108 && Ball_Y_OUT1 >= 10'd100)
      storedata = 32'd95;  // Forrest
    if (Ball_X_OUT1 <= 10'd364 && Ball_X_OUT1 >= 10'd356 && Ball_Y_OUT1 <= 10'd112 && Ball_Y_OUT1 >= 10'd104)
      storedata = 32'd96;  // Fairbury
    if (Ball_X_OUT1 <= 10'd339 && Ball_X_OUT1 >= 10'd331 && Ball_Y_OUT1 <= 10'd277 && Ball_Y_OUT1 >= 10'd269)
      storedata = 32'd97;  // FarmerCity

    //Get the position of stations.
    Center_X_begin=IndexArray[32'd97-beginpoint][1];
    Center_Y_begin=IndexArray[32'd97-beginpoint][0];

    Center_X_end=IndexArray[32'd97-endpoint][1];
    Center_Y_end=IndexArray[32'd97-endpoint][0];

    // dark green for the cursor
    if ((is_mouse==1) || (is_usbmouse==1))
    begin
      Red=8'd28;
      Green=8'd158;
      Blue=8'd115;
    end

    //Start page, only a train is on the page
    else if((SW[1]==0) /*|| (controlsignal==1'd0)*/) // if we comment the second 'or' part, then the switch can fully determine the interface we want to go
    begin
      unique case(data4)

               // black for color blocks
               2'd0:
               begin
                 Red=8'd0;
                 Green=8'd0;
                 Blue=8'd0;
               end

               // gray for border lines
               2'd1:
               begin
                 Red=8'd152;
                 Green=8'd128;
                 Blue=8'd122;
               end

               // black for unknown lines
               2'd2:
               begin
                 Red=8'd0;
                 Green=8'd12;
                 Blue=8'd174;
               end

               // white for background
               2'd3:
               begin
                 Red=8'd255;
                 Green=8'd255;
                 Blue=8'd255;
               end

               // black for undefined, like those outside range of screen
               default:
               begin
                 Red=8'd0;
                 Green=8'd0;
                 Blue=8'd0;
               end
             endcase

             // dark purple for the title on the first page
             if(DrawX <= 460 && DrawX >= 201 && DrawY <= 80 && DrawY >= 0)
             begin
               if(data5==1'b1)
               begin
                 Red=8'd19;
                 Green=8'd104;
                 Blue=8'd221;
               end
             end

           end

           // page 2
           else
             unique case(data)

                    // light green for vertices on the map
                    2'd0:
                    begin

                      Red=8'd11;
                      Green=8'd223;
                      Blue=8'd153;

                      // red for start point
                      if (beginpoint != 0)
                      begin
                        if(DrawX<=Center_X_begin+1 &&DrawX>=Center_X_begin-1 &&DrawY>=Center_Y_begin-1 &&DrawY<=Center_Y_begin+1)
                        begin
                          Red=8'd255;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      // light green for end point
                      if (endpoint != 0)
                      begin
                        if(DrawX<=Center_X_end+1 &&DrawX>=Center_X_end-1 &&DrawY>=Center_Y_end-1 &&DrawY<=Center_Y_end+1 )
                        begin
                          Red=8'd0;
                          Green=8'd255;
                          Blue=8'd255;
                        end
                      end

                    end

                    2'd1:
                    begin
                      // dark purple (for Illinois) for name of the cities
                      Red=8'd76;
                      Green=8'd0;
                      Blue=8'd153;
                    end

                    2'd2:
                    begin
                      // gray for path before the seeking algorithm
                      Red=8'd154;
                      Green=8'd154;
                      Blue=8'd154;

                      // black color for path after seeking algorithm
                      if (path1_export[0] == 1)
                      begin
                        if (DrawX >= 24 && DrawX <= 32 && DrawY >= 127 && DrawY <= 128) // Elm->HannaCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 32 && DrawX <= 41 && DrawY >= 127 && DrawY <= 127) // Elm->HannaCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 41 && DrawX <= 50 && DrawY >= 127 && DrawY <= 127) // Elm->HannaCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[1] == 1)
                      begin
                        if (DrawX >= 45 && DrawX <= 50 && DrawY >= 164 && DrawY <= 168) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 50 && DrawX <= 56 && DrawY >= 161 && DrawY <= 164) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 56 && DrawX <= 62 && DrawY >= 158 && DrawY <= 161) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 62 && DrawX <= 67 && DrawY >= 154 && DrawY <= 158) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 67 && DrawX <= 73 && DrawY >= 151 && DrawY <= 154) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 73 && DrawX <= 79 && DrawY >= 148 && DrawY <= 151) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 79 && DrawX <= 84 && DrawY >= 144 && DrawY <= 148) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 84 && DrawX <= 90 && DrawY >= 141 && DrawY <= 144) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 90 && DrawX <= 96 && DrawY >= 138 && DrawY <= 141) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 96 && DrawX <= 102 && DrawY >= 135 && DrawY <= 138) // Glasford->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[2] == 1)
                      begin
                        if (DrawX >= 51 && DrawX <= 55 && DrawY >= 210 && DrawY <= 216) // Manito->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 55 && DrawX <= 59 && DrawY >= 204 && DrawY <= 210) // Manito->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 59 && DrawX <= 63 && DrawY >= 198 && DrawY <= 204) // Manito->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 63 && DrawX <= 67 && DrawY >= 193 && DrawY <= 198) // Manito->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 67 && DrawX <= 71 && DrawY >= 187 && DrawY <= 193) // Manito->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 71 && DrawX <= 75 && DrawY >= 181 && DrawY <= 187) // Manito->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 75 && DrawX <= 79 && DrawY >= 176 && DrawY <= 181) // Manito->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[3] == 1)
                      begin
                        if (DrawX >= 72 && DrawX <= 83 && DrawY >= 430 && DrawY <= 440) // Jct->lles
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[4] == 1)
                      begin
                        if (DrawX >= 83 && DrawX <= 89 && DrawY >= 422 && DrawY <= 430) // lles->Starnes
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 89 && DrawX <= 95 && DrawY >= 414 && DrawY <= 422) // lles->Starnes
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[5] == 1)
                      begin
                        if (DrawX >= 95 && DrawX <= 103 && DrawY >= 410 && DrawY <= 414) // Starnes->Riverton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 103 && DrawX <= 112 && DrawY >= 406 && DrawY <= 410) // Starnes->Riverton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[6] == 1)
                      begin
                        if (DrawX >= 96 && DrawX <= 104 && DrawY >= 392 && DrawY <= 399) // Riverton->Sherman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 104 && DrawX <= 112 && DrawY >= 399 && DrawY <= 406) // Riverton->Sherman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[7] == 1)
                      begin
                        if (DrawX >= 112 && DrawX <= 118 && DrawY >= 405 && DrawY <= 406) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 118 && DrawX <= 125 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 125 && DrawX <= 131 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 131 && DrawX <= 138 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 138 && DrawX <= 144 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 144 && DrawX <= 151 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 151 && DrawX <= 157 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 157 && DrawX <= 164 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 164 && DrawX <= 170 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 170 && DrawX <= 177 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 177 && DrawX <= 184 && DrawY >= 405 && DrawY <= 405) // Riverton->Illiopoils
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[8] == 1)
                      begin
                        if (DrawX >= 72 && DrawX <= 78 && DrawY >= 373 && DrawY <= 377) // Sherman->BarrStation
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 78 && DrawX <= 84 && DrawY >= 377 && DrawY <= 382) // Sherman->BarrStation
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 84 && DrawX <= 90 && DrawY >= 382 && DrawY <= 387) // Sherman->BarrStation
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 90 && DrawX <= 96 && DrawY >= 387 && DrawY <= 392) // Sherman->BarrStation
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[9] == 1)
                      begin
                        if (DrawX >= 96 && DrawX <= 99 && DrawY >= 386 && DrawY <= 392) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 99 && DrawX <= 103 && DrawY >= 381 && DrawY <= 386) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 103 && DrawX <= 107 && DrawY >= 375 && DrawY <= 381) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 107 && DrawX <= 111 && DrawY >= 370 && DrawY <= 375) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 111 && DrawX <= 115 && DrawY >= 364 && DrawY <= 370) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 115 && DrawX <= 119 && DrawY >= 359 && DrawY <= 364) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 119 && DrawX <= 123 && DrawY >= 353 && DrawY <= 359) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 123 && DrawX <= 127 && DrawY >= 348 && DrawY <= 353) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 127 && DrawX <= 131 && DrawY >= 343 && DrawY <= 348) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 131 && DrawX <= 135 && DrawY >= 337 && DrawY <= 343) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 135 && DrawX <= 139 && DrawY >= 332 && DrawY <= 337) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 139 && DrawX <= 143 && DrawY >= 326 && DrawY <= 332) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 143 && DrawX <= 147 && DrawY >= 321 && DrawY <= 326) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 147 && DrawX <= 151 && DrawY >= 315 && DrawY <= 321) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 151 && DrawX <= 155 && DrawY >= 310 && DrawY <= 315) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 155 && DrawX <= 159 && DrawY >= 305 && DrawY <= 310) // Sherman->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[10] == 1)
                      begin
                        if (DrawX >= 72 && DrawX <= 73 && DrawY >= 366 && DrawY <= 373) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 73 && DrawX <= 74 && DrawY >= 359 && DrawY <= 366) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 74 && DrawX <= 75 && DrawY >= 352 && DrawY <= 359) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 75 && DrawX <= 76 && DrawY >= 346 && DrawY <= 352) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 76 && DrawX <= 77 && DrawY >= 339 && DrawY <= 346) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 77 && DrawX <= 78 && DrawY >= 332 && DrawY <= 339) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 78 && DrawX <= 79 && DrawY >= 326 && DrawY <= 332) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 79 && DrawX <= 80 && DrawY >= 319 && DrawY <= 326) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 80 && DrawX <= 81 && DrawY >= 312 && DrawY <= 319) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 81 && DrawX <= 82 && DrawY >= 306 && DrawY <= 312) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 82 && DrawX <= 83 && DrawY >= 299 && DrawY <= 306) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 83 && DrawX <= 84 && DrawY >= 292 && DrawY <= 299) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 84 && DrawX <= 85 && DrawY >= 286 && DrawY <= 292) // BarrStation->Luther
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[11] == 1)
                      begin
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 278 && DrawY <= 286) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 271 && DrawY <= 278) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 264 && DrawY <= 271) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 257 && DrawY <= 264) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 250 && DrawY <= 257) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 243 && DrawY <= 250) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 236 && DrawY <= 243) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 229 && DrawY <= 236) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 86 && DrawY >= 222 && DrawY <= 229) // Luther->GreenValley
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[12] == 1)
                      begin
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 194 && DrawY <= 203) // GreenValley->SouthPekin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 85 && DrawY >= 203 && DrawY <= 212) // GreenValley->SouthPekin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 85 && DrawX <= 86 && DrawY >= 212 && DrawY <= 222) // GreenValley->SouthPekin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[13] == 1)
                      begin
                        if (DrawX >= 86 && DrawX <= 94 && DrawY >= 222 && DrawY <= 225) // GreenValley->Delavan
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 94 && DrawX <= 102 && DrawY >= 225 && DrawY <= 228) // GreenValley->Delavan
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 102 && DrawX <= 111 && DrawY >= 228 && DrawY <= 232) // GreenValley->Delavan
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[14] == 1)
                      begin
                        if (DrawX >= 79 && DrawX <= 82 && DrawY >= 176 && DrawY <= 185) // SouthPekin->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 82 && DrawX <= 85 && DrawY >= 185 && DrawY <= 194) // SouthPekin->Powerton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[15] == 1)
                      begin
                        if (DrawX >= 79 && DrawX <= 82 && DrawY >= 169 && DrawY <= 176) // Powerton->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 82 && DrawX <= 86 && DrawY >= 162 && DrawY <= 169) // Powerton->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 86 && DrawX <= 90 && DrawY >= 155 && DrawY <= 162) // Powerton->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 90 && DrawX <= 94 && DrawY >= 148 && DrawY <= 155) // Powerton->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 94 && DrawX <= 98 && DrawY >= 141 && DrawY <= 148) // Powerton->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 98 && DrawX <= 102 && DrawY >= 135 && DrawY <= 141) // Powerton->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[16] == 1)
                      begin
                        if (DrawX >= 50 && DrawX <= 57 && DrawY >= 127 && DrawY <= 128) // HannaCity->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 57 && DrawX <= 64 && DrawY >= 128 && DrawY <= 129) // HannaCity->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 64 && DrawX <= 72 && DrawY >= 129 && DrawY <= 130) // HannaCity->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 72 && DrawX <= 79 && DrawY >= 130 && DrawY <= 131) // HannaCity->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 79 && DrawX <= 87 && DrawY >= 131 && DrawY <= 132) // HannaCity->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 87 && DrawX <= 94 && DrawY >= 132 && DrawY <= 133) // HannaCity->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 94 && DrawX <= 102 && DrawY >= 133 && DrawY <= 135) // HannaCity->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[17] == 1)
                      begin
                        if (DrawX >= 102 && DrawX <= 102 && DrawY >= 128 && DrawY <= 135) // Mossville->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 102 && DrawX <= 102 && DrawY >= 121 && DrawY <= 128) // Mossville->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 102 && DrawX <= 103 && DrawY >= 114 && DrawY <= 121) // Mossville->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 103 && DrawX <= 103 && DrawY >= 107 && DrawY <= 114) // Mossville->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 103 && DrawX <= 104 && DrawY >= 100 && DrawY <= 107) // Mossville->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 104 && DrawX <= 104 && DrawY >= 93 && DrawY <= 100) // Mossville->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 104 && DrawX <= 105 && DrawY >= 87 && DrawY <= 93) // Mossville->EastPeoria
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[18] == 1)
                      begin
                        if (DrawX >= 102 && DrawX <= 111 && DrawY >= 135 && DrawY <= 137) // EastPeoria->Farmdale
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 111 && DrawX <= 121 && DrawY >= 137 && DrawY <= 139) // EastPeoria->Farmdale
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[19] == 1)
                      begin
                        if (DrawX >= 111 && DrawX <= 114 && DrawY >= 232 && DrawY <= 237) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 114 && DrawX <= 118 && DrawY >= 237 && DrawY <= 243) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 118 && DrawX <= 122 && DrawY >= 243 && DrawY <= 248) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 122 && DrawX <= 125 && DrawY >= 248 && DrawY <= 254) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 125 && DrawX <= 129 && DrawY >= 254 && DrawY <= 260) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 129 && DrawX <= 133 && DrawY >= 260 && DrawY <= 265) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 133 && DrawX <= 136 && DrawY >= 265 && DrawY <= 271) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 136 && DrawX <= 140 && DrawY >= 271 && DrawY <= 276) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 140 && DrawX <= 144 && DrawY >= 276 && DrawY <= 282) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 144 && DrawX <= 147 && DrawY >= 282 && DrawY <= 288) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 147 && DrawX <= 151 && DrawY >= 288 && DrawY <= 293) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 151 && DrawX <= 155 && DrawY >= 293 && DrawY <= 299) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 155 && DrawX <= 159 && DrawY >= 299 && DrawY <= 305) // Delavan->Lincoin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[20] == 1)
                      begin
                        if (DrawX >= 121 && DrawX <= 128 && DrawY >= 134 && DrawY <= 139) // Farmdale->Washington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 128 && DrawX <= 135 && DrawY >= 129 && DrawY <= 134) // Farmdale->Washington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 135 && DrawX <= 142 && DrawY >= 124 && DrawY <= 129) // Farmdale->Washington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[21] == 1)
                      begin
                        if (DrawX >= 121 && DrawX <= 129 && DrawY >= 139 && DrawY <= 143) // Farmdale->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 129 && DrawX <= 138 && DrawY >= 143 && DrawY <= 147) // Farmdale->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[22] == 1)
                      begin
                        if (DrawX >= 142 && DrawX <= 149 && DrawY >= 122 && DrawY <= 124) // Washington->Eureka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 149 && DrawX <= 157 && DrawY >= 121 && DrawY <= 122) // Washington->Eureka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 157 && DrawX <= 164 && DrawY >= 119 && DrawY <= 121) // Washington->Eureka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 164 && DrawX <= 172 && DrawY >= 118 && DrawY <= 119) // Washington->Eureka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 172 && DrawX <= 180 && DrawY >= 117 && DrawY <= 118) // Washington->Eureka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[23] == 1)
                      begin
                        if (DrawX >= 180 && DrawX <= 186 && DrawY >= 116 && DrawY <= 117) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 186 && DrawX <= 193 && DrawY >= 115 && DrawY <= 116) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 193 && DrawX <= 200 && DrawY >= 115 && DrawY <= 115) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 200 && DrawX <= 206 && DrawY >= 114 && DrawY <= 115) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 206 && DrawX <= 213 && DrawY >= 114 && DrawY <= 114) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 213 && DrawX <= 220 && DrawY >= 113 && DrawY <= 114) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 220 && DrawX <= 226 && DrawY >= 113 && DrawY <= 113) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 226 && DrawX <= 233 && DrawY >= 112 && DrawY <= 113) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 233 && DrawX <= 240 && DrawY >= 112 && DrawY <= 112) // Eureka->ElPaso
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[24] == 1)
                      begin
                        if (DrawX >= 240 && DrawX <= 246 && DrawY >= 111 && DrawY <= 112) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 246 && DrawX <= 253 && DrawY >= 111 && DrawY <= 111) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 253 && DrawX <= 260 && DrawY >= 111 && DrawY <= 111) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 260 && DrawX <= 266 && DrawY >= 111 && DrawY <= 111) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 266 && DrawX <= 273 && DrawY >= 111 && DrawY <= 111) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 273 && DrawX <= 280 && DrawY >= 110 && DrawY <= 111) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 280 && DrawX <= 287 && DrawY >= 110 && DrawY <= 110) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 287 && DrawX <= 293 && DrawY >= 110 && DrawY <= 110) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 293 && DrawX <= 300 && DrawY >= 110 && DrawY <= 110) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 300 && DrawX <= 307 && DrawY >= 110 && DrawY <= 110) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 307 && DrawX <= 314 && DrawY >= 110 && DrawY <= 110) // ElPaso->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[25] == 1)
                      begin
                        if (DrawX >= 159 && DrawX <= 161 && DrawY >= 305 && DrawY <= 312) // Lincoin->Mt.Pulaski
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 161 && DrawX <= 163 && DrawY >= 312 && DrawY <= 319) // Lincoin->Mt.Pulaski
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 163 && DrawX <= 165 && DrawY >= 319 && DrawY <= 326) // Lincoin->Mt.Pulaski
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 165 && DrawX <= 167 && DrawY >= 326 && DrawY <= 333) // Lincoin->Mt.Pulaski
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 167 && DrawX <= 169 && DrawY >= 333 && DrawY <= 340) // Lincoin->Mt.Pulaski
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 169 && DrawX <= 171 && DrawY >= 340 && DrawY <= 347) // Lincoin->Mt.Pulaski
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 171 && DrawX <= 173 && DrawY >= 347 && DrawY <= 354) // Lincoin->Mt.Pulaski
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[26] == 1)
                      begin
                        if (DrawX >= 159 && DrawX <= 163 && DrawY >= 299 && DrawY <= 305) // Lincoin->Atlanta
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 163 && DrawX <= 168 && DrawY >= 293 && DrawY <= 299) // Lincoin->Atlanta
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 168 && DrawX <= 173 && DrawY >= 287 && DrawY <= 293) // Lincoin->Atlanta
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 173 && DrawX <= 178 && DrawY >= 281 && DrawY <= 287) // Lincoin->Atlanta
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 178 && DrawX <= 183 && DrawY >= 275 && DrawY <= 281) // Lincoin->Atlanta
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 183 && DrawX <= 188 && DrawY >= 270 && DrawY <= 275) // Lincoin->Atlanta
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[27] == 1)
                      begin
                        if (DrawX >= 173 && DrawX <= 179 && DrawY >= 354 && DrawY <= 356) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 179 && DrawX <= 185 && DrawY >= 356 && DrawY <= 359) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 185 && DrawX <= 192 && DrawY >= 359 && DrawY <= 362) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 192 && DrawX <= 198 && DrawY >= 362 && DrawY <= 364) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 198 && DrawX <= 204 && DrawY >= 364 && DrawY <= 367) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 204 && DrawX <= 211 && DrawY >= 367 && DrawY <= 370) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 211 && DrawX <= 217 && DrawY >= 370 && DrawY <= 372) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 217 && DrawX <= 223 && DrawY >= 372 && DrawY <= 375) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 223 && DrawX <= 230 && DrawY >= 375 && DrawY <= 378) // Mt.Pulaski->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[28] == 1)
                      begin
                        if (DrawX >= 173 && DrawX <= 178 && DrawY >= 350 && DrawY <= 354) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 178 && DrawX <= 184 && DrawY >= 347 && DrawY <= 350) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 184 && DrawX <= 190 && DrawY >= 344 && DrawY <= 347) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 190 && DrawX <= 196 && DrawY >= 341 && DrawY <= 344) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 196 && DrawX <= 201 && DrawY >= 337 && DrawY <= 341) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 201 && DrawX <= 207 && DrawY >= 334 && DrawY <= 337) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 207 && DrawX <= 213 && DrawY >= 331 && DrawY <= 334) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 213 && DrawX <= 219 && DrawY >= 328 && DrawY <= 331) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 219 && DrawX <= 225 && DrawY >= 325 && DrawY <= 328) // Mt.Pulaski->Kenney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[29] == 1)
                      begin
                        if (DrawX >= 184 && DrawX <= 191 && DrawY >= 405 && DrawY <= 405) // Illiopoils->Harristown
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 191 && DrawX <= 199 && DrawY >= 405 && DrawY <= 405) // Illiopoils->Harristown
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 199 && DrawX <= 206 && DrawY >= 405 && DrawY <= 405) // Illiopoils->Harristown
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 206 && DrawX <= 214 && DrawY >= 405 && DrawY <= 405) // Illiopoils->Harristown
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 214 && DrawX <= 222 && DrawY >= 405 && DrawY <= 405) // Illiopoils->Harristown
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[30] == 1)
                      begin
                        if (DrawX >= 222 && DrawX <= 229 && DrawY >= 405 && DrawY <= 405) // Harristown->Decatur
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 229 && DrawX <= 236 && DrawY >= 405 && DrawY <= 405) // Harristown->Decatur
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 236 && DrawX <= 244 && DrawY >= 405 && DrawY <= 405) // Harristown->Decatur
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 244 && DrawX <= 251 && DrawY >= 405 && DrawY <= 405) // Harristown->Decatur
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 251 && DrawX <= 259 && DrawY >= 405 && DrawY <= 406) // Harristown->Decatur
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path1_export[31] == 1)
                      begin
                        if (DrawX >= 230 && DrawX <= 235 && DrawY >= 378 && DrawY <= 383) // Decatur->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 235 && DrawX <= 241 && DrawY >= 383 && DrawY <= 389) // Decatur->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 241 && DrawX <= 247 && DrawY >= 389 && DrawY <= 394) // Decatur->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 247 && DrawX <= 253 && DrawY >= 394 && DrawY <= 400) // Decatur->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 253 && DrawX <= 259 && DrawY >= 400 && DrawY <= 406) // Decatur->Warrensburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[0] == 1)
                      begin
                        if (DrawX >= 248 && DrawX <= 249 && DrawY >= 440 && DrawY <= 447) // Decatur->Macon
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 249 && DrawX <= 251 && DrawY >= 433 && DrawY <= 440) // Decatur->Macon
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 251 && DrawX <= 253 && DrawY >= 426 && DrawY <= 433) // Decatur->Macon
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 253 && DrawX <= 255 && DrawY >= 419 && DrawY <= 426) // Decatur->Macon
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 255 && DrawX <= 257 && DrawY >= 412 && DrawY <= 419) // Decatur->Macon
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 257 && DrawX <= 259 && DrawY >= 406 && DrawY <= 412) // Decatur->Macon
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[1] == 1)
                      begin
                        if (DrawX >= 239 && DrawX <= 244 && DrawY >= 422 && DrawY <= 428) // Decatur->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 244 && DrawX <= 249 && DrawY >= 417 && DrawY <= 422) // Decatur->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 249 && DrawX <= 254 && DrawY >= 411 && DrawY <= 417) // Decatur->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 254 && DrawX <= 259 && DrawY >= 406 && DrawY <= 411) // Decatur->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[2] == 1)
                      begin
                        if (DrawX >= 259 && DrawX <= 263 && DrawY >= 406 && DrawY <= 411) // Decatur->HerveyCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 263 && DrawX <= 268 && DrawY >= 411 && DrawY <= 417) // Decatur->HerveyCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 268 && DrawX <= 272 && DrawY >= 417 && DrawY <= 422) // Decatur->HerveyCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 272 && DrawX <= 277 && DrawY >= 422 && DrawY <= 428) // Decatur->HerveyCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 277 && DrawX <= 282 && DrawY >= 428 && DrawY <= 434) // Decatur->HerveyCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[3] == 1)
                      begin
                        if (DrawX >= 259 && DrawX <= 267 && DrawY >= 406 && DrawY <= 409) // Decatur->LongCreek
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 267 && DrawX <= 275 && DrawY >= 409 && DrawY <= 412) // Decatur->LongCreek
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 275 && DrawX <= 284 && DrawY >= 412 && DrawY <= 416) // Decatur->LongCreek
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[4] == 1)
                      begin
                        if (DrawX >= 259 && DrawX <= 265 && DrawY >= 404 && DrawY <= 406) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 265 && DrawX <= 272 && DrawY >= 402 && DrawY <= 404) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 272 && DrawX <= 278 && DrawY >= 400 && DrawY <= 402) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 278 && DrawX <= 285 && DrawY >= 398 && DrawY <= 400) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 285 && DrawX <= 291 && DrawY >= 396 && DrawY <= 398) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 291 && DrawX <= 298 && DrawY >= 394 && DrawY <= 396) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 298 && DrawX <= 304 && DrawY >= 392 && DrawY <= 394) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 304 && DrawX <= 311 && DrawY >= 391 && DrawY <= 392) // Decatur->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[5] == 1)
                      begin
                        if (DrawX >= 259 && DrawX <= 263 && DrawY >= 401 && DrawY <= 406) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 263 && DrawX <= 268 && DrawY >= 396 && DrawY <= 401) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 268 && DrawX <= 272 && DrawY >= 392 && DrawY <= 396) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 272 && DrawX <= 277 && DrawY >= 387 && DrawY <= 392) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 277 && DrawX <= 281 && DrawY >= 383 && DrawY <= 387) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 281 && DrawX <= 286 && DrawY >= 378 && DrawY <= 383) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 286 && DrawX <= 291 && DrawY >= 373 && DrawY <= 378) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 291 && DrawX <= 295 && DrawY >= 369 && DrawY <= 373) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 295 && DrawX <= 300 && DrawY >= 364 && DrawY <= 369) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 300 && DrawX <= 304 && DrawY >= 360 && DrawY <= 364) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 304 && DrawX <= 309 && DrawY >= 355 && DrawY <= 360) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 309 && DrawX <= 314 && DrawY >= 351 && DrawY <= 355) // Decatur->Cisco
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[6] == 1)
                      begin
                        if (DrawX >= 225 && DrawX <= 231 && DrawY >= 320 && DrawY <= 325) // Kenney->Clinton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 231 && DrawX <= 238 && DrawY >= 315 && DrawY <= 320) // Kenney->Clinton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 238 && DrawX <= 245 && DrawY >= 310 && DrawY <= 315) // Kenney->Clinton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 245 && DrawX <= 252 && DrawY >= 306 && DrawY <= 310) // Kenney->Clinton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[7] == 1)
                      begin
                        if (DrawX >= 252 && DrawX <= 252 && DrawY >= 298 && DrawY <= 306) // Clinton->Heyworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 252 && DrawX <= 252 && DrawY >= 291 && DrawY <= 298) // Clinton->Heyworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 252 && DrawX <= 252 && DrawY >= 283 && DrawY <= 291) // Clinton->Heyworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 252 && DrawX <= 252 && DrawY >= 276 && DrawY <= 283) // Clinton->Heyworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 252 && DrawX <= 252 && DrawY >= 268 && DrawY <= 276) // Clinton->Heyworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 252 && DrawX <= 252 && DrawY >= 261 && DrawY <= 268) // Clinton->Heyworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 252 && DrawX <= 253 && DrawY >= 254 && DrawY <= 261) // Clinton->Heyworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[8] == 1)
                      begin
                        if (DrawX >= 252 && DrawX <= 258 && DrawY >= 303 && DrawY <= 306) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 258 && DrawX <= 264 && DrawY >= 300 && DrawY <= 303) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 264 && DrawX <= 271 && DrawY >= 298 && DrawY <= 300) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 271 && DrawX <= 277 && DrawY >= 295 && DrawY <= 298) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 277 && DrawX <= 283 && DrawY >= 293 && DrawY <= 295) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 283 && DrawX <= 290 && DrawY >= 290 && DrawY <= 293) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 290 && DrawX <= 296 && DrawY >= 288 && DrawY <= 290) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 296 && DrawX <= 303 && DrawY >= 285 && DrawY <= 288) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 303 && DrawX <= 309 && DrawY >= 283 && DrawY <= 285) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 309 && DrawX <= 315 && DrawY >= 280 && DrawY <= 283) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 315 && DrawX <= 322 && DrawY >= 278 && DrawY <= 280) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 322 && DrawX <= 328 && DrawY >= 275 && DrawY <= 278) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 328 && DrawX <= 335 && DrawY >= 273 && DrawY <= 275) // Clinton->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[9] == 1)
                      begin
                        if (DrawX >= 188 && DrawX <= 192 && DrawY >= 264 && DrawY <= 270) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 192 && DrawX <= 196 && DrawY >= 259 && DrawY <= 264) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 196 && DrawX <= 200 && DrawY >= 254 && DrawY <= 259) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 200 && DrawX <= 204 && DrawY >= 249 && DrawY <= 254) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 204 && DrawX <= 208 && DrawY >= 244 && DrawY <= 249) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 208 && DrawX <= 212 && DrawY >= 239 && DrawY <= 244) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 212 && DrawX <= 216 && DrawY >= 234 && DrawY <= 239) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 216 && DrawX <= 220 && DrawY >= 228 && DrawY <= 234) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 220 && DrawX <= 224 && DrawY >= 223 && DrawY <= 228) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 224 && DrawX <= 228 && DrawY >= 218 && DrawY <= 223) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 228 && DrawX <= 232 && DrawY >= 213 && DrawY <= 218) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 232 && DrawX <= 236 && DrawY >= 208 && DrawY <= 213) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 236 && DrawX <= 240 && DrawY >= 203 && DrawY <= 208) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 240 && DrawX <= 245 && DrawY >= 198 && DrawY <= 203) // Atlanta->Bloomington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[10] == 1)
                      begin
                        if (DrawX >= 209 && DrawX <= 214 && DrawY >= 163 && DrawY <= 168) // Bloomington->Carlock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 214 && DrawX <= 219 && DrawY >= 168 && DrawY <= 173) // Bloomington->Carlock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 219 && DrawX <= 224 && DrawY >= 173 && DrawY <= 178) // Bloomington->Carlock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 224 && DrawX <= 229 && DrawY >= 178 && DrawY <= 183) // Bloomington->Carlock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 229 && DrawX <= 234 && DrawY >= 183 && DrawY <= 188) // Bloomington->Carlock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 234 && DrawX <= 239 && DrawY >= 188 && DrawY <= 193) // Bloomington->Carlock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 239 && DrawX <= 245 && DrawY >= 193 && DrawY <= 198) // Bloomington->Carlock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[11] == 1)
                      begin
                        if (DrawX >= 245 && DrawX <= 249 && DrawY >= 193 && DrawY <= 198) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 249 && DrawX <= 254 && DrawY >= 188 && DrawY <= 193) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 254 && DrawX <= 259 && DrawY >= 183 && DrawY <= 188) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 259 && DrawX <= 264 && DrawY >= 178 && DrawY <= 183) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 264 && DrawX <= 269 && DrawY >= 173 && DrawY <= 178) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 269 && DrawX <= 274 && DrawY >= 168 && DrawY <= 173) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 274 && DrawX <= 279 && DrawY >= 163 && DrawY <= 168) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 279 && DrawX <= 284 && DrawY >= 158 && DrawY <= 163) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 284 && DrawX <= 289 && DrawY >= 153 && DrawY <= 158) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 289 && DrawX <= 294 && DrawY >= 148 && DrawY <= 153) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 294 && DrawX <= 299 && DrawY >= 144 && DrawY <= 148) // Bloomington->Lexington
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[12] == 1)
                      begin
                        if (DrawX >= 245 && DrawX <= 250 && DrawY >= 198 && DrawY <= 201) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 250 && DrawX <= 255 && DrawY >= 201 && DrawY <= 205) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 255 && DrawX <= 261 && DrawY >= 205 && DrawY <= 209) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 261 && DrawX <= 266 && DrawY >= 209 && DrawY <= 213) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 266 && DrawX <= 271 && DrawY >= 213 && DrawY <= 217) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 271 && DrawX <= 277 && DrawY >= 217 && DrawY <= 220) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 277 && DrawX <= 282 && DrawY >= 220 && DrawY <= 224) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 282 && DrawX <= 287 && DrawY >= 224 && DrawY <= 228) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 287 && DrawX <= 293 && DrawY >= 228 && DrawY <= 232) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 293 && DrawX <= 298 && DrawY >= 232 && DrawY <= 236) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 298 && DrawX <= 304 && DrawY >= 236 && DrawY <= 240) // Bloomington->LeRoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[13] == 1)
                      begin
                        if (DrawX >= 138 && DrawX <= 144 && DrawY >= 147 && DrawY <= 148) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 144 && DrawX <= 150 && DrawY >= 148 && DrawY <= 149) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 150 && DrawX <= 157 && DrawY >= 149 && DrawY <= 151) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 157 && DrawX <= 163 && DrawY >= 151 && DrawY <= 152) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 163 && DrawX <= 170 && DrawY >= 152 && DrawY <= 154) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 170 && DrawX <= 176 && DrawY >= 154 && DrawY <= 155) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 176 && DrawX <= 183 && DrawY >= 155 && DrawY <= 157) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 183 && DrawX <= 189 && DrawY >= 157 && DrawY <= 158) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 189 && DrawX <= 196 && DrawY >= 158 && DrawY <= 160) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 196 && DrawX <= 202 && DrawY >= 160 && DrawY <= 161) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 202 && DrawX <= 209 && DrawY >= 161 && DrawY <= 163) // Carlock->Crandall
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[14] == 1)
                      begin
                        if (DrawX >= 299 && DrawX <= 302 && DrawY >= 137 && DrawY <= 144) // Lexington->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 302 && DrawX <= 305 && DrawY >= 130 && DrawY <= 137) // Lexington->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 305 && DrawX <= 308 && DrawY >= 123 && DrawY <= 130) // Lexington->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 308 && DrawX <= 311 && DrawY >= 116 && DrawY <= 123) // Lexington->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 311 && DrawX <= 314 && DrawY >= 110 && DrawY <= 116) // Lexington->Chenoa
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[15] == 1)
                      begin
                        if (DrawX >= 314 && DrawX <= 321 && DrawY >= 109 && DrawY <= 110) // Chenoa->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 321 && DrawX <= 329 && DrawY >= 109 && DrawY <= 109) // Chenoa->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 329 && DrawX <= 337 && DrawY >= 109 && DrawY <= 109) // Chenoa->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 337 && DrawX <= 344 && DrawY >= 108 && DrawY <= 109) // Chenoa->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 344 && DrawX <= 352 && DrawY >= 108 && DrawY <= 108) // Chenoa->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 352 && DrawX <= 360 && DrawY >= 108 && DrawY <= 108) // Chenoa->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[16] == 1)
                      begin
                        if (DrawX >= 214 && DrawX <= 219 && DrawY >= 452 && DrawY <= 458) // BlueMound->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 219 && DrawX <= 224 && DrawY >= 446 && DrawY <= 452) // BlueMound->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 224 && DrawX <= 229 && DrawY >= 440 && DrawY <= 446) // BlueMound->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 229 && DrawX <= 234 && DrawY >= 434 && DrawY <= 440) // BlueMound->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 234 && DrawX <= 239 && DrawY >= 428 && DrawY <= 434) // BlueMound->Boody
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[17] == 1)
                      begin
                        if (DrawX >= 284 && DrawX <= 290 && DrawY >= 416 && DrawY <= 416) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 290 && DrawX <= 296 && DrawY >= 416 && DrawY <= 416) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 296 && DrawX <= 303 && DrawY >= 416 && DrawY <= 417) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 303 && DrawX <= 309 && DrawY >= 417 && DrawY <= 417) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 309 && DrawX <= 316 && DrawY >= 417 && DrawY <= 417) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 316 && DrawX <= 322 && DrawY >= 417 && DrawY <= 418) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 322 && DrawX <= 328 && DrawY >= 418 && DrawY <= 418) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 328 && DrawX <= 335 && DrawY >= 418 && DrawY <= 418) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 335 && DrawX <= 341 && DrawY >= 418 && DrawY <= 419) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 341 && DrawX <= 348 && DrawY >= 419 && DrawY <= 419) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 348 && DrawX <= 354 && DrawY >= 419 && DrawY <= 419) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 354 && DrawX <= 360 && DrawY >= 419 && DrawY <= 420) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 360 && DrawX <= 367 && DrawY >= 420 && DrawY <= 420) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 367 && DrawX <= 373 && DrawY >= 420 && DrawY <= 420) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 373 && DrawX <= 380 && DrawY >= 420 && DrawY <= 421) // LongCreek->Atwood
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[18] == 1)
                      begin
                        if (DrawX >= 380 && DrawX <= 387 && DrawY >= 420 && DrawY <= 421) // Atwood->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 387 && DrawX <= 395 && DrawY >= 420 && DrawY <= 420) // Atwood->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 395 && DrawX <= 403 && DrawY >= 420 && DrawY <= 420) // Atwood->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 403 && DrawX <= 410 && DrawY >= 419 && DrawY <= 420) // Atwood->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 410 && DrawX <= 418 && DrawY >= 419 && DrawY <= 419) // Atwood->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 418 && DrawX <= 426 && DrawY >= 419 && DrawY <= 419) // Atwood->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[19] == 1)
                      begin
                        if (DrawX >= 377 && DrawX <= 383 && DrawY >= 445 && DrawY <= 449) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 383 && DrawX <= 389 && DrawY >= 441 && DrawY <= 445) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 389 && DrawX <= 395 && DrawY >= 437 && DrawY <= 441) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 395 && DrawX <= 401 && DrawY >= 434 && DrawY <= 437) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 401 && DrawX <= 407 && DrawY >= 430 && DrawY <= 434) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 407 && DrawX <= 413 && DrawY >= 426 && DrawY <= 430) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 413 && DrawX <= 419 && DrawY >= 422 && DrawY <= 426) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 419 && DrawX <= 426 && DrawY >= 419 && DrawY <= 422) // Arthur->Tuscola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[20] == 1)
                      begin
                        if (DrawX >= 422 && DrawX <= 423 && DrawY >= 444 && DrawY <= 453) // Tuscola->Arcola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 423 && DrawX <= 424 && DrawY >= 436 && DrawY <= 444) // Tuscola->Arcola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 424 && DrawX <= 425 && DrawY >= 427 && DrawY <= 436) // Tuscola->Arcola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 425 && DrawX <= 426 && DrawY >= 419 && DrawY <= 427) // Tuscola->Arcola
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[21] == 1)
                      begin
                        if (DrawX >= 426 && DrawX <= 433 && DrawY >= 419 && DrawY <= 419) // Tuscola->Murdock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 433 && DrawX <= 440 && DrawY >= 419 && DrawY <= 419) // Tuscola->Murdock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 440 && DrawX <= 447 && DrawY >= 419 && DrawY <= 419) // Tuscola->Murdock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 447 && DrawX <= 454 && DrawY >= 419 && DrawY <= 419) // Tuscola->Murdock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 454 && DrawX <= 461 && DrawY >= 419 && DrawY <= 419) // Tuscola->Murdock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 461 && DrawX <= 468 && DrawY >= 419 && DrawY <= 419) // Tuscola->Murdock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 468 && DrawX <= 476 && DrawY >= 419 && DrawY <= 419) // Tuscola->Murdock
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[22] == 1)
                      begin
                        if (DrawX >= 426 && DrawX <= 431 && DrawY >= 415 && DrawY <= 419) // Tuscola->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 431 && DrawX <= 437 && DrawY >= 411 && DrawY <= 415) // Tuscola->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 437 && DrawX <= 443 && DrawY >= 407 && DrawY <= 411) // Tuscola->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 443 && DrawX <= 449 && DrawY >= 403 && DrawY <= 407) // Tuscola->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 449 && DrawX <= 455 && DrawY >= 399 && DrawY <= 403) // Tuscola->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 455 && DrawX <= 461 && DrawY >= 396 && DrawY <= 399) // Tuscola->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[23] == 1)
                      begin
                        if (DrawX >= 476 && DrawX <= 484 && DrawY >= 418 && DrawY <= 419) // Murdock->Newman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 484 && DrawX <= 492 && DrawY >= 418 && DrawY <= 418) // Murdock->Newman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 492 && DrawX <= 500 && DrawY >= 418 && DrawY <= 418) // Murdock->Newman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[24] == 1)
                      begin
                        if (DrawX >= 500 && DrawX <= 506 && DrawY >= 417 && DrawY <= 418) // Newman->Metcalf
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 506 && DrawX <= 513 && DrawY >= 417 && DrawY <= 417) // Newman->Metcalf
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 513 && DrawX <= 520 && DrawY >= 417 && DrawY <= 417) // Newman->Metcalf
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 520 && DrawX <= 527 && DrawY >= 416 && DrawY <= 417) // Newman->Metcalf
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 527 && DrawX <= 534 && DrawY >= 416 && DrawY <= 416) // Newman->Metcalf
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 534 && DrawX <= 541 && DrawY >= 416 && DrawY <= 416) // Newman->Metcalf
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 541 && DrawX <= 548 && DrawY >= 416 && DrawY <= 416) // Newman->Metcalf
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[25] == 1)
                      begin
                        if (DrawX >= 548 && DrawX <= 557 && DrawY >= 416 && DrawY <= 416) // Metcalf->Chrisman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 557 && DrawX <= 567 && DrawY >= 416 && DrawY <= 416) // Metcalf->Chrisman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 567 && DrawX <= 577 && DrawY >= 416 && DrawY <= 416) // Metcalf->Chrisman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[26] == 1)
                      begin
                        if (DrawX >= 577 && DrawX <= 584 && DrawY >= 415 && DrawY <= 416) // Chrisman->WestDana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 584 && DrawX <= 591 && DrawY >= 415 && DrawY <= 415) // Chrisman->WestDana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 591 && DrawX <= 598 && DrawY >= 415 && DrawY <= 415) // Chrisman->WestDana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 598 && DrawX <= 605 && DrawY >= 414 && DrawY <= 415) // Chrisman->WestDana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 605 && DrawX <= 612 && DrawY >= 414 && DrawY <= 414) // Chrisman->WestDana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 612 && DrawX <= 620 && DrawY >= 414 && DrawY <= 414) // Chrisman->WestDana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[27] == 1)
                      begin
                        if (DrawX >= 577 && DrawX <= 578 && DrawY >= 408 && DrawY <= 416) // Chrisman->RidgeFarm
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 578 && DrawX <= 579 && DrawY >= 400 && DrawY <= 408) // Chrisman->RidgeFarm
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 579 && DrawX <= 580 && DrawY >= 392 && DrawY <= 400) // Chrisman->RidgeFarm
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 580 && DrawX <= 582 && DrawY >= 384 && DrawY <= 392) // Chrisman->RidgeFarm
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[28] == 1)
                      begin
                        if (DrawX >= 582 && DrawX <= 583 && DrawY >= 375 && DrawY <= 384) // RidgeFarm->Westville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 583 && DrawX <= 584 && DrawY >= 367 && DrawY <= 375) // RidgeFarm->Westville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 584 && DrawX <= 585 && DrawY >= 359 && DrawY <= 367) // RidgeFarm->Westville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 585 && DrawX <= 586 && DrawY >= 351 && DrawY <= 359) // RidgeFarm->Westville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 586 && DrawX <= 588 && DrawY >= 343 && DrawY <= 351) // RidgeFarm->Westville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[29] == 1)
                      begin
                        if (DrawX >= 586 && DrawX <= 586 && DrawY >= 318 && DrawY <= 326) // Westville->Tilton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 586 && DrawX <= 587 && DrawY >= 326 && DrawY <= 334) // Westville->Tilton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 587 && DrawX <= 588 && DrawY >= 334 && DrawY <= 343) // Westville->Tilton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[30] == 1)
                      begin
                        if (DrawX >= 586 && DrawX <= 591 && DrawY >= 307 && DrawY <= 318) // Tilton->Danville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path2_export[31] == 1)
                      begin
                        if (DrawX >= 504 && DrawX <= 510 && DrawY >= 337 && DrawY <= 339) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 510 && DrawX <= 516 && DrawY >= 335 && DrawY <= 337) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 516 && DrawX <= 522 && DrawY >= 334 && DrawY <= 335) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 522 && DrawX <= 529 && DrawY >= 332 && DrawY <= 334) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 529 && DrawX <= 535 && DrawY >= 330 && DrawY <= 332) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 535 && DrawX <= 541 && DrawY >= 329 && DrawY <= 330) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 541 && DrawX <= 548 && DrawY >= 327 && DrawY <= 329) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 548 && DrawX <= 554 && DrawY >= 326 && DrawY <= 327) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 554 && DrawX <= 560 && DrawY >= 324 && DrawY <= 326) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 560 && DrawX <= 567 && DrawY >= 322 && DrawY <= 324) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 567 && DrawX <= 573 && DrawY >= 321 && DrawY <= 322) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 573 && DrawX <= 579 && DrawY >= 319 && DrawY <= 321) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 579 && DrawX <= 586 && DrawY >= 318 && DrawY <= 319) // Tilton->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[0] == 1)
                      begin
                        if (DrawX >= 577 && DrawX <= 578 && DrawY >= 224 && DrawY <= 230) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 578 && DrawX <= 579 && DrawY >= 230 && DrawY <= 236) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 579 && DrawX <= 580 && DrawY >= 236 && DrawY <= 243) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 580 && DrawX <= 581 && DrawY >= 243 && DrawY <= 249) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 581 && DrawX <= 582 && DrawY >= 249 && DrawY <= 255) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 582 && DrawX <= 583 && DrawY >= 255 && DrawY <= 262) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 583 && DrawX <= 584 && DrawY >= 262 && DrawY <= 268) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 584 && DrawX <= 585 && DrawY >= 268 && DrawY <= 275) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 585 && DrawX <= 586 && DrawY >= 275 && DrawY <= 281) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 586 && DrawX <= 587 && DrawY >= 281 && DrawY <= 287) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 587 && DrawX <= 588 && DrawY >= 287 && DrawY <= 294) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 588 && DrawX <= 589 && DrawY >= 294 && DrawY <= 300) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 589 && DrawX <= 591 && DrawY >= 300 && DrawY <= 307) // Danville->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[1] == 1)
                      begin
                        if (DrawX >= 544 && DrawX <= 549 && DrawY >= 269 && DrawY <= 274) // Collison->Henning
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 549 && DrawX <= 554 && DrawY >= 264 && DrawY <= 269) // Collison->Henning
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 554 && DrawX <= 559 && DrawY >= 259 && DrawY <= 264) // Collison->Henning
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 559 && DrawX <= 564 && DrawY >= 254 && DrawY <= 259) // Collison->Henning
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 564 && DrawX <= 570 && DrawY >= 249 && DrawY <= 254) // Collison->Henning
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[2] == 1)
                      begin
                        if (DrawX >= 570 && DrawX <= 572 && DrawY >= 240 && DrawY <= 249) // Henning->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 572 && DrawX <= 574 && DrawY >= 232 && DrawY <= 240) // Henning->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 574 && DrawX <= 577 && DrawY >= 224 && DrawY <= 232) // Henning->Rossville
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[3] == 1)
                      begin
                        if (DrawX >= 576 && DrawX <= 576 && DrawY >= 196 && DrawY <= 205) // Rossville->Hoopston
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 576 && DrawX <= 576 && DrawY >= 205 && DrawY <= 214) // Rossville->Hoopston
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 576 && DrawX <= 577 && DrawY >= 214 && DrawY <= 224) // Rossville->Hoopston
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[4] == 1)
                      begin
                        if (DrawX >= 568 && DrawX <= 569 && DrawY >= 140 && DrawY <= 147) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 569 && DrawX <= 570 && DrawY >= 147 && DrawY <= 154) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 570 && DrawX <= 571 && DrawY >= 154 && DrawY <= 161) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 571 && DrawX <= 572 && DrawY >= 161 && DrawY <= 168) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 572 && DrawX <= 573 && DrawY >= 168 && DrawY <= 175) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 573 && DrawX <= 574 && DrawY >= 175 && DrawY <= 182) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 574 && DrawX <= 575 && DrawY >= 182 && DrawY <= 189) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 575 && DrawX <= 576 && DrawY >= 189 && DrawY <= 196) // Hoopston->Milford
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[5] == 1)
                      begin
                        if (DrawX >= 561 && DrawX <= 564 && DrawY >= 121 && DrawY <= 130) // Milford->WoodlandJct.
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 564 && DrawX <= 568 && DrawY >= 130 && DrawY <= 140) // Milford->WoodlandJct.
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[6] == 1)
                      begin
                        if (DrawX >= 557 && DrawX <= 558 && DrawY >= 92 && DrawY <= 101) // WoodlandJct.->Watseka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 558 && DrawX <= 559 && DrawY >= 101 && DrawY <= 111) // WoodlandJct.->Watseka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 559 && DrawX <= 561 && DrawY >= 111 && DrawY <= 121) // WoodlandJct.->Watseka
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[7] == 1)
                      begin
                        if (DrawX >= 547 && DrawX <= 549 && DrawY >= 156 && DrawY <= 164) // WoodlandJct.->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 549 && DrawX <= 551 && DrawY >= 149 && DrawY <= 156) // WoodlandJct.->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 551 && DrawX <= 554 && DrawY >= 142 && DrawY <= 149) // WoodlandJct.->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 554 && DrawX <= 556 && DrawY >= 135 && DrawY <= 142) // WoodlandJct.->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 556 && DrawX <= 558 && DrawY >= 128 && DrawY <= 135) // WoodlandJct.->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 558 && DrawX <= 561 && DrawY >= 121 && DrawY <= 128) // WoodlandJct.->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[8] == 1)
                      begin
                        if (DrawX >= 557 && DrawX <= 565 && DrawY >= 92 && DrawY <= 92) // Watseka->Webster
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 565 && DrawX <= 573 && DrawY >= 92 && DrawY <= 93) // Watseka->Webster
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 573 && DrawX <= 581 && DrawY >= 93 && DrawY <= 94) // Watseka->Webster
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 581 && DrawX <= 590 && DrawY >= 94 && DrawY <= 95) // Watseka->Webster
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[9] == 1)
                      begin
                        if (DrawX >= 493 && DrawX <= 500 && DrawY >= 96 && DrawY <= 97) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 500 && DrawX <= 507 && DrawY >= 95 && DrawY <= 96) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 507 && DrawX <= 514 && DrawY >= 95 && DrawY <= 95) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 514 && DrawX <= 521 && DrawY >= 94 && DrawY <= 95) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 521 && DrawX <= 528 && DrawY >= 94 && DrawY <= 94) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 528 && DrawX <= 535 && DrawY >= 93 && DrawY <= 94) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 535 && DrawX <= 542 && DrawY >= 93 && DrawY <= 93) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 542 && DrawX <= 549 && DrawY >= 92 && DrawY <= 93) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 549 && DrawX <= 557 && DrawY >= 92 && DrawY <= 92) // Watseka->Gilman
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[10] == 1)
                      begin
                        if (DrawX >= 490 && DrawX <= 491 && DrawY >= 107 && DrawY <= 117) // Gilman->Onarga
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 491 && DrawX <= 493 && DrawY >= 97 && DrawY <= 107) // Gilman->Onarga
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[11] == 1)
                      begin
                        if (DrawX >= 431 && DrawX <= 435 && DrawY >= 161 && DrawY <= 166) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 435 && DrawX <= 439 && DrawY >= 156 && DrawY <= 161) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 439 && DrawX <= 444 && DrawY >= 151 && DrawY <= 156) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 444 && DrawX <= 448 && DrawY >= 146 && DrawY <= 151) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 448 && DrawX <= 453 && DrawY >= 141 && DrawY <= 146) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 453 && DrawX <= 457 && DrawY >= 136 && DrawY <= 141) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 457 && DrawX <= 462 && DrawY >= 131 && DrawY <= 136) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 462 && DrawX <= 466 && DrawY >= 126 && DrawY <= 131) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 466 && DrawX <= 470 && DrawY >= 121 && DrawY <= 126) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 470 && DrawX <= 475 && DrawY >= 116 && DrawY <= 121) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 475 && DrawX <= 479 && DrawY >= 111 && DrawY <= 116) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 479 && DrawX <= 484 && DrawY >= 106 && DrawY <= 111) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 484 && DrawX <= 488 && DrawY >= 101 && DrawY <= 106) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 488 && DrawX <= 493 && DrawY >= 97 && DrawY <= 101) // Gilman->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[12] == 1)
                      begin
                        if (DrawX >= 419 && DrawX <= 425 && DrawY >= 102 && DrawY <= 103) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 425 && DrawX <= 432 && DrawY >= 101 && DrawY <= 102) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 432 && DrawX <= 439 && DrawY >= 101 && DrawY <= 101) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 439 && DrawX <= 445 && DrawY >= 100 && DrawY <= 101) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 445 && DrawX <= 452 && DrawY >= 100 && DrawY <= 100) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 452 && DrawX <= 459 && DrawY >= 99 && DrawY <= 100) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 459 && DrawX <= 466 && DrawY >= 99 && DrawY <= 99) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 466 && DrawX <= 472 && DrawY >= 98 && DrawY <= 99) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 472 && DrawX <= 479 && DrawY >= 98 && DrawY <= 98) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 479 && DrawX <= 486 && DrawY >= 97 && DrawY <= 98) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 486 && DrawX <= 493 && DrawY >= 97 && DrawY <= 97) // Gilman->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[13] == 1)
                      begin
                        if (DrawX >= 471 && DrawX <= 472 && DrawY >= 193 && DrawY <= 200) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 472 && DrawX <= 473 && DrawY >= 187 && DrawY <= 193) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 473 && DrawX <= 475 && DrawY >= 180 && DrawY <= 187) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 475 && DrawX <= 476 && DrawY >= 174 && DrawY <= 180) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 476 && DrawX <= 478 && DrawY >= 168 && DrawY <= 174) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 478 && DrawX <= 479 && DrawY >= 161 && DrawY <= 168) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 479 && DrawX <= 481 && DrawY >= 155 && DrawY <= 161) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 481 && DrawX <= 482 && DrawY >= 148 && DrawY <= 155) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 482 && DrawX <= 484 && DrawY >= 142 && DrawY <= 148) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 484 && DrawX <= 485 && DrawY >= 136 && DrawY <= 142) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 485 && DrawX <= 487 && DrawY >= 129 && DrawY <= 136) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 487 && DrawX <= 488 && DrawY >= 123 && DrawY <= 129) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 488 && DrawX <= 490 && DrawY >= 117 && DrawY <= 123) // Onarga->Paxton
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[14] == 1)
                      begin
                        if (DrawX >= 455 && DrawX <= 457 && DrawY >= 242 && DrawY <= 249) // Paxton->Rantoul
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 457 && DrawX <= 459 && DrawY >= 235 && DrawY <= 242) // Paxton->Rantoul
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 459 && DrawX <= 461 && DrawY >= 228 && DrawY <= 235) // Paxton->Rantoul
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 461 && DrawX <= 464 && DrawY >= 221 && DrawY <= 228) // Paxton->Rantoul
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 464 && DrawX <= 466 && DrawY >= 214 && DrawY <= 221) // Paxton->Rantoul
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 466 && DrawX <= 468 && DrawY >= 207 && DrawY <= 214) // Paxton->Rantoul
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 468 && DrawX <= 471 && DrawY >= 200 && DrawY <= 207) // Paxton->Rantoul
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[15] == 1)
                      begin
                        if (DrawX >= 455 && DrawX <= 465 && DrawY >= 248 && DrawY <= 249) // Rantoul->Dillsburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 465 && DrawX <= 476 && DrawY >= 247 && DrawY <= 248) // Rantoul->Dillsburg
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[16] == 1)
                      begin
                        if (DrawX >= 410 && DrawX <= 417 && DrawY >= 247 && DrawY <= 247) // Rantoul->Fisher
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 417 && DrawX <= 425 && DrawY >= 247 && DrawY <= 247) // Rantoul->Fisher
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 425 && DrawX <= 432 && DrawY >= 247 && DrawY <= 248) // Rantoul->Fisher
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 432 && DrawX <= 440 && DrawY >= 248 && DrawY <= 248) // Rantoul->Fisher
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 440 && DrawX <= 447 && DrawY >= 248 && DrawY <= 248) // Rantoul->Fisher
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 447 && DrawX <= 455 && DrawY >= 248 && DrawY <= 249) // Rantoul->Fisher
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[17] == 1)
                      begin
                        if (DrawX >= 449 && DrawX <= 452 && DrawY >= 259 && DrawY <= 269) // Rantoul->Thomasboro
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 452 && DrawX <= 455 && DrawY >= 249 && DrawY <= 259) // Rantoul->Thomasboro
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[18] == 1)
                      begin
                        if (DrawX >= 443 && DrawX <= 444 && DrawY >= 308 && DrawY <= 316) // Thomasboro->Urbana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 444 && DrawX <= 445 && DrawY >= 300 && DrawY <= 308) // Thomasboro->Urbana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 445 && DrawX <= 446 && DrawY >= 292 && DrawY <= 300) // Thomasboro->Urbana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 446 && DrawX <= 447 && DrawY >= 284 && DrawY <= 292) // Thomasboro->Urbana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 447 && DrawX <= 448 && DrawY >= 276 && DrawY <= 284) // Thomasboro->Urbana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 448 && DrawX <= 449 && DrawY >= 269 && DrawY <= 276) // Thomasboro->Urbana
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[19] == 1)
                      begin
                        if (DrawX >= 394 && DrawX <= 401 && DrawY >= 317 && DrawY <= 318) // Urbana->Champaign
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 401 && DrawX <= 408 && DrawY >= 317 && DrawY <= 317) // Urbana->Champaign
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 408 && DrawX <= 415 && DrawY >= 317 && DrawY <= 317) // Urbana->Champaign
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 415 && DrawX <= 422 && DrawY >= 316 && DrawY <= 317) // Urbana->Champaign
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 422 && DrawX <= 429 && DrawY >= 316 && DrawY <= 316) // Urbana->Champaign
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 429 && DrawX <= 436 && DrawY >= 316 && DrawY <= 316) // Urbana->Champaign
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 436 && DrawX <= 443 && DrawY >= 316 && DrawY <= 316) // Urbana->Champaign
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[20] == 1)
                      begin
                        if (DrawX >= 435 && DrawX <= 437 && DrawY >= 331 && DrawY <= 339) // Urbana->Savoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 437 && DrawX <= 440 && DrawY >= 323 && DrawY <= 331) // Urbana->Savoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 440 && DrawX <= 443 && DrawY >= 316 && DrawY <= 323) // Urbana->Savoy
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[21] == 1)
                      begin
                        if (DrawX >= 369 && DrawX <= 375 && DrawY >= 284 && DrawY <= 286) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 375 && DrawX <= 381 && DrawY >= 286 && DrawY <= 289) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 381 && DrawX <= 387 && DrawY >= 289 && DrawY <= 292) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 387 && DrawX <= 393 && DrawY >= 292 && DrawY <= 294) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 393 && DrawX <= 399 && DrawY >= 294 && DrawY <= 297) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 399 && DrawX <= 406 && DrawY >= 297 && DrawY <= 300) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 406 && DrawX <= 412 && DrawY >= 300 && DrawY <= 302) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 412 && DrawX <= 418 && DrawY >= 302 && DrawY <= 305) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 418 && DrawX <= 424 && DrawY >= 305 && DrawY <= 308) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 424 && DrawX <= 430 && DrawY >= 308 && DrawY <= 310) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 430 && DrawX <= 436 && DrawY >= 310 && DrawY <= 313) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 436 && DrawX <= 443 && DrawY >= 313 && DrawY <= 316) // Urbana->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[22] == 1)
                      begin
                        if (DrawX >= 430 && DrawX <= 432 && DrawY >= 348 && DrawY <= 357) // Savoy->Tolono
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 432 && DrawX <= 435 && DrawY >= 339 && DrawY <= 348) // Savoy->Tolono
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[23] == 1)
                      begin
                        if (DrawX >= 430 && DrawX <= 437 && DrawY >= 355 && DrawY <= 357) // Tolono->Sidney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 437 && DrawX <= 444 && DrawY >= 353 && DrawY <= 355) // Tolono->Sidney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 444 && DrawX <= 451 && DrawY >= 351 && DrawY <= 353) // Tolono->Sidney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 451 && DrawX <= 458 && DrawY >= 349 && DrawY <= 351) // Tolono->Sidney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 458 && DrawX <= 465 && DrawY >= 347 && DrawY <= 349) // Tolono->Sidney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 465 && DrawX <= 472 && DrawY >= 345 && DrawY <= 347) // Tolono->Sidney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 472 && DrawX <= 480 && DrawY >= 343 && DrawY <= 345) // Tolono->Sidney
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[24] == 1)
                      begin
                        if (DrawX >= 352 && DrawX <= 358 && DrawY >= 378 && DrawY <= 380) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 358 && DrawX <= 365 && DrawY >= 376 && DrawY <= 378) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 365 && DrawX <= 371 && DrawY >= 374 && DrawY <= 376) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 371 && DrawX <= 378 && DrawY >= 372 && DrawY <= 374) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 378 && DrawX <= 384 && DrawY >= 370 && DrawY <= 372) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 384 && DrawX <= 391 && DrawY >= 368 && DrawY <= 370) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 391 && DrawX <= 397 && DrawY >= 366 && DrawY <= 368) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 397 && DrawX <= 404 && DrawY >= 364 && DrawY <= 366) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 404 && DrawX <= 410 && DrawY >= 362 && DrawY <= 364) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 410 && DrawX <= 417 && DrawY >= 360 && DrawY <= 362) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 417 && DrawX <= 423 && DrawY >= 358 && DrawY <= 360) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 423 && DrawX <= 430 && DrawY >= 357 && DrawY <= 358) // Tolono->Bement
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[25] == 1)
                      begin
                        if (DrawX >= 480 && DrawX <= 488 && DrawY >= 341 && DrawY <= 343) // Sidney->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 488 && DrawX <= 496 && DrawY >= 340 && DrawY <= 341) // Sidney->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 496 && DrawX <= 504 && DrawY >= 339 && DrawY <= 340) // Sidney->Homer
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[26] == 1)
                      begin
                        if (DrawX >= 480 && DrawX <= 483 && DrawY >= 336 && DrawY <= 343) // Sidney->Glover
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 483 && DrawX <= 486 && DrawY >= 329 && DrawY <= 336) // Sidney->Glover
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 486 && DrawX <= 489 && DrawY >= 322 && DrawY <= 329) // Sidney->Glover
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 489 && DrawX <= 493 && DrawY >= 316 && DrawY <= 322) // Sidney->Glover
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[27] == 1)
                      begin
                        if (DrawX >= 461 && DrawX <= 463 && DrawY >= 389 && DrawY <= 396) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 463 && DrawX <= 465 && DrawY >= 382 && DrawY <= 389) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 465 && DrawX <= 468 && DrawY >= 376 && DrawY <= 382) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 468 && DrawX <= 470 && DrawY >= 369 && DrawY <= 376) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 470 && DrawX <= 472 && DrawY >= 362 && DrawY <= 369) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 472 && DrawX <= 475 && DrawY >= 356 && DrawY <= 362) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 475 && DrawX <= 477 && DrawY >= 349 && DrawY <= 356) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 477 && DrawX <= 480 && DrawY >= 343 && DrawY <= 349) // Sidney->VillaGrove
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[28] == 1)
                      begin
                        if (DrawX >= 493 && DrawX <= 495 && DrawY >= 309 && DrawY <= 316) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 495 && DrawX <= 497 && DrawY >= 303 && DrawY <= 309) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 497 && DrawX <= 499 && DrawY >= 297 && DrawY <= 303) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 499 && DrawX <= 501 && DrawY >= 291 && DrawY <= 297) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 501 && DrawX <= 503 && DrawY >= 285 && DrawY <= 291) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 503 && DrawX <= 505 && DrawY >= 279 && DrawY <= 285) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 505 && DrawX <= 508 && DrawY >= 273 && DrawY <= 279) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 508 && DrawX <= 510 && DrawY >= 267 && DrawY <= 273) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 510 && DrawX <= 512 && DrawY >= 261 && DrawY <= 267) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 512 && DrawX <= 514 && DrawY >= 255 && DrawY <= 261) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 514 && DrawX <= 516 && DrawY >= 249 && DrawY <= 255) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 516 && DrawX <= 518 && DrawY >= 243 && DrawY <= 249) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 518 && DrawX <= 521 && DrawY >= 236 && DrawY <= 243) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 521 && DrawX <= 523 && DrawY >= 230 && DrawY <= 236) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 523 && DrawX <= 525 && DrawY >= 224 && DrawY <= 230) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 525 && DrawX <= 527 && DrawY >= 218 && DrawY <= 224) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 527 && DrawX <= 529 && DrawY >= 212 && DrawY <= 218) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 529 && DrawX <= 531 && DrawY >= 206 && DrawY <= 212) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 531 && DrawX <= 534 && DrawY >= 200 && DrawY <= 206) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 534 && DrawX <= 536 && DrawY >= 194 && DrawY <= 200) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 536 && DrawX <= 538 && DrawY >= 188 && DrawY <= 194) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 538 && DrawX <= 540 && DrawY >= 182 && DrawY <= 188) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 540 && DrawX <= 542 && DrawY >= 176 && DrawY <= 182) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 542 && DrawX <= 544 && DrawY >= 170 && DrawY <= 176) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 544 && DrawX <= 547 && DrawY >= 164 && DrawY <= 170) // Glover->Goodwine
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[29] == 1)
                      begin
                        if (DrawX >= 520 && DrawX <= 529 && DrawY >= 164 && DrawY <= 165) // Goodwine->CissnaPark
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 529 && DrawX <= 538 && DrawY >= 164 && DrawY <= 164) // Goodwine->CissnaPark
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 538 && DrawX <= 547 && DrawY >= 164 && DrawY <= 164) // Goodwine->CissnaPark
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[30] == 1)
                      begin
                        if (DrawX >= 461 && DrawX <= 468 && DrawY >= 393 && DrawY <= 396) // VillaGrove->Boradland
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 468 && DrawX <= 475 && DrawY >= 390 && DrawY <= 393) // VillaGrove->Boradland
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 475 && DrawX <= 482 && DrawY >= 387 && DrawY <= 390) // VillaGrove->Boradland
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 482 && DrawX <= 489 && DrawY >= 384 && DrawY <= 387) // VillaGrove->Boradland
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 489 && DrawX <= 497 && DrawY >= 381 && DrawY <= 384) // VillaGrove->Boradland
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path3_export[31] == 1)
                      begin
                      end

                      if (path4_export[0] == 1)
                      begin
                        if (DrawX >= 311 && DrawX <= 317 && DrawY >= 389 && DrawY <= 391) // Bement->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 317 && DrawX <= 324 && DrawY >= 387 && DrawY <= 389) // Bement->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 324 && DrawX <= 331 && DrawY >= 385 && DrawY <= 387) // Bement->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 331 && DrawX <= 338 && DrawY >= 383 && DrawY <= 385) // Bement->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 338 && DrawX <= 345 && DrawY >= 381 && DrawY <= 383) // Bement->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 345 && DrawX <= 352 && DrawY >= 380 && DrawY <= 381) // Bement->CerroGordo
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[1] == 1)
                      begin
                        if (DrawX >= 351 && DrawX <= 351 && DrawY >= 343 && DrawY <= 350) // Bement->Monticello
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 351 && DrawX <= 351 && DrawY >= 350 && DrawY <= 357) // Bement->Monticello
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 351 && DrawX <= 351 && DrawY >= 357 && DrawY <= 365) // Bement->Monticello
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 351 && DrawX <= 351 && DrawY >= 365 && DrawY <= 372) // Bement->Monticello
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 351 && DrawX <= 352 && DrawY >= 372 && DrawY <= 380) // Bement->Monticello
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[2] == 1)
                      begin
                        if (DrawX >= 351 && DrawX <= 353 && DrawY >= 334 && DrawY <= 343) // Monticello->Lodge
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 353 && DrawX <= 355 && DrawY >= 326 && DrawY <= 334) // Monticello->Lodge
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 355 && DrawX <= 357 && DrawY >= 318 && DrawY <= 326) // Monticello->Lodge
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[3] == 1)
                      begin
                        if (DrawX >= 357 && DrawX <= 359 && DrawY >= 311 && DrawY <= 318) // Lodge->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 359 && DrawX <= 361 && DrawY >= 304 && DrawY <= 311) // Lodge->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 361 && DrawX <= 364 && DrawY >= 297 && DrawY <= 304) // Lodge->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 364 && DrawX <= 366 && DrawY >= 290 && DrawY <= 297) // Lodge->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 366 && DrawX <= 369 && DrawY >= 284 && DrawY <= 290) // Lodge->Mansfield
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[4] == 1)
                      begin
                        if (DrawX >= 369 && DrawX <= 370 && DrawY >= 276 && DrawY <= 284) // Mansfield->Lotus
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 370 && DrawX <= 372 && DrawY >= 269 && DrawY <= 276) // Mansfield->Lotus
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 372 && DrawX <= 374 && DrawY >= 262 && DrawY <= 269) // Mansfield->Lotus
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 374 && DrawX <= 376 && DrawY >= 255 && DrawY <= 262) // Mansfield->Lotus
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 376 && DrawX <= 378 && DrawY >= 248 && DrawY <= 255) // Mansfield->Lotus
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[5] == 1)
                      begin
                        if (DrawX >= 335 && DrawX <= 341 && DrawY >= 273 && DrawY <= 275) // Mansfield->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 341 && DrawX <= 348 && DrawY >= 275 && DrawY <= 277) // Mansfield->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 348 && DrawX <= 355 && DrawY >= 277 && DrawY <= 279) // Mansfield->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 355 && DrawX <= 362 && DrawY >= 279 && DrawY <= 281) // Mansfield->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 362 && DrawX <= 369 && DrawY >= 281 && DrawY <= 284) // Mansfield->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[6] == 1)
                      begin
                        if (DrawX >= 378 && DrawX <= 381 && DrawY >= 241 && DrawY <= 248) // Lotus->GibsonCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 381 && DrawX <= 384 && DrawY >= 234 && DrawY <= 241) // Lotus->GibsonCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 384 && DrawX <= 387 && DrawY >= 227 && DrawY <= 234) // Lotus->GibsonCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 387 && DrawX <= 390 && DrawY >= 220 && DrawY <= 227) // Lotus->GibsonCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 390 && DrawX <= 393 && DrawY >= 213 && DrawY <= 220) // Lotus->GibsonCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 393 && DrawX <= 396 && DrawY >= 206 && DrawY <= 213) // Lotus->GibsonCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 396 && DrawX <= 400 && DrawY >= 200 && DrawY <= 206) // Lotus->GibsonCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[7] == 1)
                      begin
                        if (DrawX >= 400 && DrawX <= 405 && DrawY >= 194 && DrawY <= 200) // GibsonCity->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 405 && DrawX <= 410 && DrawY >= 188 && DrawY <= 194) // GibsonCity->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 410 && DrawX <= 415 && DrawY >= 183 && DrawY <= 188) // GibsonCity->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 415 && DrawX <= 420 && DrawY >= 177 && DrawY <= 183) // GibsonCity->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 420 && DrawX <= 425 && DrawY >= 171 && DrawY <= 177) // GibsonCity->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 425 && DrawX <= 431 && DrawY >= 166 && DrawY <= 171) // GibsonCity->Melvin
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[8] == 1)
                      begin
                        if (DrawX >= 342 && DrawX <= 349 && DrawY >= 205 && DrawY <= 206) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 349 && DrawX <= 356 && DrawY >= 204 && DrawY <= 205) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 356 && DrawX <= 363 && DrawY >= 203 && DrawY <= 204) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 363 && DrawX <= 371 && DrawY >= 203 && DrawY <= 203) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 371 && DrawX <= 378 && DrawY >= 202 && DrawY <= 203) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 378 && DrawX <= 385 && DrawY >= 201 && DrawY <= 202) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 385 && DrawX <= 392 && DrawY >= 200 && DrawY <= 201) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 392 && DrawX <= 400 && DrawY >= 200 && DrawY <= 200) // GibsonCity->Arrowsmith
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[9] == 1)
                      begin
                        if (DrawX >= 389 && DrawX <= 390 && DrawY >= 136 && DrawY <= 143) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 390 && DrawX <= 391 && DrawY >= 143 && DrawY <= 150) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 391 && DrawX <= 392 && DrawY >= 150 && DrawY <= 157) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 392 && DrawX <= 393 && DrawY >= 157 && DrawY <= 164) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 393 && DrawX <= 395 && DrawY >= 164 && DrawY <= 171) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 395 && DrawX <= 396 && DrawY >= 171 && DrawY <= 178) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 396 && DrawX <= 397 && DrawY >= 178 && DrawY <= 185) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 397 && DrawX <= 398 && DrawY >= 185 && DrawY <= 192) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 398 && DrawX <= 400 && DrawY >= 192 && DrawY <= 200) // GibsonCity->Risk
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[10] == 1)
                      begin
                        if (DrawX >= 335 && DrawX <= 339 && DrawY >= 268 && DrawY <= 273) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 339 && DrawX <= 343 && DrawY >= 263 && DrawY <= 268) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 343 && DrawX <= 348 && DrawY >= 258 && DrawY <= 263) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 348 && DrawX <= 352 && DrawY >= 253 && DrawY <= 258) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 352 && DrawX <= 356 && DrawY >= 248 && DrawY <= 253) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 356 && DrawX <= 361 && DrawY >= 243 && DrawY <= 248) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 361 && DrawX <= 365 && DrawY >= 238 && DrawY <= 243) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 365 && DrawX <= 369 && DrawY >= 234 && DrawY <= 238) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 369 && DrawX <= 374 && DrawY >= 229 && DrawY <= 234) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 374 && DrawX <= 378 && DrawY >= 224 && DrawY <= 229) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 378 && DrawX <= 382 && DrawY >= 219 && DrawY <= 224) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 382 && DrawX <= 387 && DrawY >= 214 && DrawY <= 219) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 387 && DrawX <= 391 && DrawY >= 209 && DrawY <= 214) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 391 && DrawX <= 395 && DrawY >= 204 && DrawY <= 209) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 395 && DrawX <= 400 && DrawY >= 200 && DrawY <= 204) // GibsonCity->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[11] == 1)
                      begin
                        if (DrawX >= 304 && DrawX <= 309 && DrawY >= 240 && DrawY <= 245) // LeRoy->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 309 && DrawX <= 314 && DrawY >= 245 && DrawY <= 251) // LeRoy->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 314 && DrawX <= 319 && DrawY >= 251 && DrawY <= 256) // LeRoy->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 319 && DrawX <= 324 && DrawY >= 256 && DrawY <= 262) // LeRoy->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 324 && DrawX <= 329 && DrawY >= 262 && DrawY <= 267) // LeRoy->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 329 && DrawX <= 335 && DrawY >= 267 && DrawY <= 273) // LeRoy->FarmerCity
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[12] == 1)
                      begin
                        if (DrawX >= 339 && DrawX <= 345 && DrawY >= 164 && DrawY <= 168) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 345 && DrawX <= 351 && DrawY >= 160 && DrawY <= 164) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 351 && DrawX <= 357 && DrawY >= 156 && DrawY <= 160) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 357 && DrawX <= 364 && DrawY >= 152 && DrawY <= 156) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 364 && DrawX <= 370 && DrawY >= 148 && DrawY <= 152) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 370 && DrawX <= 376 && DrawY >= 144 && DrawY <= 148) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 376 && DrawX <= 382 && DrawY >= 140 && DrawY <= 144) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 382 && DrawX <= 389 && DrawY >= 136 && DrawY <= 140) // Risk->Colfax
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[13] == 1)
                      begin
                        if (DrawX >= 389 && DrawX <= 394 && DrawY >= 130 && DrawY <= 136) // Risk->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 394 && DrawX <= 399 && DrawY >= 125 && DrawY <= 130) // Risk->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 399 && DrawX <= 404 && DrawY >= 119 && DrawY <= 125) // Risk->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 404 && DrawX <= 409 && DrawY >= 114 && DrawY <= 119) // Risk->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 409 && DrawX <= 414 && DrawY >= 108 && DrawY <= 114) // Risk->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 414 && DrawX <= 419 && DrawY >= 103 && DrawY <= 108) // Risk->Chatsworth
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[14] == 1)
                      begin
                        if (DrawX >= 392 && DrawX <= 401 && DrawY >= 103 && DrawY <= 104) // Chatsworth->Forrest
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 401 && DrawX <= 410 && DrawY >= 103 && DrawY <= 103) // Chatsworth->Forrest
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 410 && DrawX <= 419 && DrawY >= 103 && DrawY <= 103) // Chatsworth->Forrest
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end

                      if (path4_export[15] == 1)
                      begin
                        if (DrawX >= 360 && DrawX <= 368 && DrawY >= 107 && DrawY <= 108) // Forrest->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 368 && DrawX <= 376 && DrawY >= 106 && DrawY <= 107) // Forrest->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 376 && DrawX <= 384 && DrawY >= 105 && DrawY <= 106) // Forrest->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                        if (DrawX >= 384 && DrawX <= 392 && DrawY >= 104 && DrawY <= 105) // Forrest->Fairbury
                        begin
                          Red=8'd0;
                          Green=8'd0;
                          Blue=8'd0;
                        end
                      end




                    end

                    // white color for background
                    2'd3:
                    begin
                      Red=8'd255;
                      Green=8'd255;
                      Blue=8'd255;
                      if(storedata != 32'd0)

                        // dark purple color for the city name (like Illinois color)
                      begin
                        if(DrawX<=398&&DrawX>=300 &&DrawY<=20&&DrawY>=0)
                          if(cityname ==1 )
                          begin
                            Red=8'd76;
                            Green=8'd0;
                            Blue=8'd153;
                          end
                      end

                      // red color for the distances
                      if(DrawX<=14&&DrawX>=0&&DrawY<=19&&DrawY>=0)
                      begin
                        if(numbercode1==1)
                        begin
                          Red=8'd222;
                          Green=8'd12;
                          Blue=8'd12;
                        end
                      end
                      if(DrawX<=34&&DrawX>=20&&DrawY<=19&&DrawY>=0)
                      begin
                        if(numbercode2==1)
                        begin
                          Red=8'd222;
                          Green=8'd12;
                          Blue=8'd12;
                        end
                      end

                      // red color for "km"
                      if(DrawX <= 90 && DrawX >= 55 && DrawY <= 19 && DrawY >= 0)
                      begin
                        if(data_km == 1)
                        begin
                          Red=8'd222;
                          Green=8'd12;
                          Blue=8'd12;
                        end
                      end
                    end

                    // white for default color outside the VGA screen
                    default:
                    begin
                      Red=8'd255;
                      Green=8'd255;
                      Blue=8'd255;
                    end

                  endcase

                end

              endmodule


