module  detect_mouse (		  input logic  LEFT,
                            input logic [7:0] keycode,
                            input logic [9:0] Ball_X_OUT,Ball_Y_OUT,Ball_X_OUT1,Ball_Y_OUT1,
                            input        [9:0] DrawX, DrawY,       // Current pixel coordinates
                            output logic [9:0] pos_x_out,pos_y_out
                       );

  logic enter;
  logic [8:0] enter_usb;
  assign enter=1'b1;
  assign enter_usb=8'h2c;
  always_comb
  begin
    pos_x_out=10'd0;
    pos_y_out=10'd0;

    if (Ball_X_OUT <= 10'd28 && Ball_X_OUT >= 10'd20 && Ball_Y_OUT <= 10'd132 && Ball_Y_OUT >= 10'd124)  // Elm
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd24;
        pos_y_out=10'd128;
      end
    end

    if (Ball_X_OUT <= 10'd49 && Ball_X_OUT >= 10'd41 && Ball_Y_OUT <= 10'd172 && Ball_Y_OUT >= 10'd164)  // Glasford
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd45;
        pos_y_out=10'd168;
      end
    end

    if (Ball_X_OUT <= 10'd55 && Ball_X_OUT >= 10'd47 && Ball_Y_OUT <= 10'd220 && Ball_Y_OUT >= 10'd212)  // Manito
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd51;
        pos_y_out=10'd216;
      end
    end

    if (Ball_X_OUT <= 10'd76 && Ball_X_OUT >= 10'd68 && Ball_Y_OUT <= 10'd444 && Ball_Y_OUT >= 10'd436)  // Jct
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd72;
        pos_y_out=10'd440;
      end
    end

    if (Ball_X_OUT <= 10'd87 && Ball_X_OUT >= 10'd79 && Ball_Y_OUT <= 10'd434 && Ball_Y_OUT >= 10'd426)  // lles
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd83;
        pos_y_out=10'd430;
      end
    end

    if (Ball_X_OUT <= 10'd99 && Ball_X_OUT >= 10'd91 && Ball_Y_OUT <= 10'd418 && Ball_Y_OUT >= 10'd410)  // Starnes
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd95;
        pos_y_out=10'd414;
      end
    end

    if (Ball_X_OUT <= 10'd116 && Ball_X_OUT >= 10'd108 && Ball_Y_OUT <= 10'd410 && Ball_Y_OUT >= 10'd402)  // Riverton
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd112;
        pos_y_out=10'd406;
      end
    end

    if (Ball_X_OUT <= 10'd100 && Ball_X_OUT >= 10'd92 && Ball_Y_OUT <= 10'd396 && Ball_Y_OUT >= 10'd388)  // Sherman
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd96;
        pos_y_out=10'd392;
      end
    end

    if (Ball_X_OUT <= 10'd76 && Ball_X_OUT >= 10'd68 && Ball_Y_OUT <= 10'd377 && Ball_Y_OUT >= 10'd369)  // BarrStation
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd72;
        pos_y_out=10'd373;
      end
    end

    if (Ball_X_OUT <= 10'd89 && Ball_X_OUT >= 10'd81 && Ball_Y_OUT <= 10'd290 && Ball_Y_OUT >= 10'd282)  // Luther
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd85;
        pos_y_out=10'd286;
      end
    end

    if (Ball_X_OUT <= 10'd90 && Ball_X_OUT >= 10'd82 && Ball_Y_OUT <= 10'd226 && Ball_Y_OUT >= 10'd218)  // GreenValley
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd86;
        pos_y_out=10'd222;
      end
    end

    if (Ball_X_OUT <= 10'd89 && Ball_X_OUT >= 10'd81 && Ball_Y_OUT <= 10'd198 && Ball_Y_OUT >= 10'd190)  // SouthPekin
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd85;
        pos_y_out=10'd194;
      end
    end

    if (Ball_X_OUT <= 10'd83 && Ball_X_OUT >= 10'd75 && Ball_Y_OUT <= 10'd180 && Ball_Y_OUT >= 10'd172)  // Powerton
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd79;
        pos_y_out=10'd176;
      end
    end

    if (Ball_X_OUT <= 10'd54 && Ball_X_OUT >= 10'd46 && Ball_Y_OUT <= 10'd131 && Ball_Y_OUT >= 10'd123)  // HannaCity
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd50;
        pos_y_out=10'd127;
      end
    end

    if (Ball_X_OUT <= 10'd109 && Ball_X_OUT >= 10'd101 && Ball_Y_OUT <= 10'd91 && Ball_Y_OUT >= 10'd83)  // Mossville
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd105;
        pos_y_out=10'd87;
      end
    end

    if (Ball_X_OUT <= 10'd106 && Ball_X_OUT >= 10'd98 && Ball_Y_OUT <= 10'd139 && Ball_Y_OUT >= 10'd131)  // EastPeoria
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd102;
        pos_y_out=10'd135;
      end
    end

    if (Ball_X_OUT <= 10'd115 && Ball_X_OUT >= 10'd107 && Ball_Y_OUT <= 10'd236 && Ball_Y_OUT >= 10'd228)  // Delavan
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd111;
        pos_y_out=10'd232;
      end
    end

    if (Ball_X_OUT <= 10'd125 && Ball_X_OUT >= 10'd117 && Ball_Y_OUT <= 10'd143 && Ball_Y_OUT >= 10'd135)  // Farmdale
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd121;
        pos_y_out=10'd139;
      end
    end

    if (Ball_X_OUT <= 10'd146 && Ball_X_OUT >= 10'd138 && Ball_Y_OUT <= 10'd128 && Ball_Y_OUT >= 10'd120)  // Washington
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd142;
        pos_y_out=10'd124;
      end
    end

    if (Ball_X_OUT <= 10'd184 && Ball_X_OUT >= 10'd176 && Ball_Y_OUT <= 10'd121 && Ball_Y_OUT >= 10'd113)  // Eureka
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd180;
        pos_y_out=10'd117;
      end
    end

    if (Ball_X_OUT <= 10'd244 && Ball_X_OUT >= 10'd236 && Ball_Y_OUT <= 10'd116 && Ball_Y_OUT >= 10'd108)  // ElPaso
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd240;
        pos_y_out=10'd112;
      end
    end

    if (Ball_X_OUT <= 10'd163 && Ball_X_OUT >= 10'd155 && Ball_Y_OUT <= 10'd309 && Ball_Y_OUT >= 10'd301)  // Lincoin
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd159;
        pos_y_out=10'd305;
      end
    end

    if (Ball_X_OUT <= 10'd177 && Ball_X_OUT >= 10'd169 && Ball_Y_OUT <= 10'd358 && Ball_Y_OUT >= 10'd350)  // Mt.Pulaski
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd173;
        pos_y_out=10'd354;
      end
    end

    if (Ball_X_OUT <= 10'd188 && Ball_X_OUT >= 10'd180 && Ball_Y_OUT <= 10'd409 && Ball_Y_OUT >= 10'd401)  // Illiopoils
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd184;
        pos_y_out=10'd405;
      end
    end

    if (Ball_X_OUT <= 10'd226 && Ball_X_OUT >= 10'd218 && Ball_Y_OUT <= 10'd409 && Ball_Y_OUT >= 10'd401)  // Harristown
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd222;
        pos_y_out=10'd405;
      end
    end

    if (Ball_X_OUT <= 10'd263 && Ball_X_OUT >= 10'd255 && Ball_Y_OUT <= 10'd410 && Ball_Y_OUT >= 10'd402)  // Decatur
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd259;
        pos_y_out=10'd406;
      end
    end

    if (Ball_X_OUT <= 10'd234 && Ball_X_OUT >= 10'd226 && Ball_Y_OUT <= 10'd382 && Ball_Y_OUT >= 10'd374)  // Warrensburg
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd230;
        pos_y_out=10'd378;
      end
    end

    if (Ball_X_OUT <= 10'd229 && Ball_X_OUT >= 10'd221 && Ball_Y_OUT <= 10'd329 && Ball_Y_OUT >= 10'd321)  // Kenney
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd225;
        pos_y_out=10'd325;
      end
    end

    if (Ball_X_OUT <= 10'd256 && Ball_X_OUT >= 10'd248 && Ball_Y_OUT <= 10'd310 && Ball_Y_OUT >= 10'd302)  // Clinton
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd252;
        pos_y_out=10'd306;
      end
    end

    if (Ball_X_OUT <= 10'd257 && Ball_X_OUT >= 10'd249 && Ball_Y_OUT <= 10'd258 && Ball_Y_OUT >= 10'd250)  // Heyworth
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd253;
        pos_y_out=10'd254;
      end
    end

    if (Ball_X_OUT <= 10'd192 && Ball_X_OUT >= 10'd184 && Ball_Y_OUT <= 10'd274 && Ball_Y_OUT >= 10'd266)  // Atlanta
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd188;
        pos_y_out=10'd270;
      end
    end

    if (Ball_X_OUT <= 10'd249 && Ball_X_OUT >= 10'd241 && Ball_Y_OUT <= 10'd202 && Ball_Y_OUT >= 10'd194)  // Bloomington
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd245;
        pos_y_out=10'd198;
      end
    end

    if (Ball_X_OUT <= 10'd213 && Ball_X_OUT >= 10'd205 && Ball_Y_OUT <= 10'd167 && Ball_Y_OUT >= 10'd159)  // Carlock
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd209;
        pos_y_out=10'd163;
      end
    end

    if (Ball_X_OUT <= 10'd142 && Ball_X_OUT >= 10'd134 && Ball_Y_OUT <= 10'd151 && Ball_Y_OUT >= 10'd143)  // Crandall
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd138;
        pos_y_out=10'd147;
      end
    end

    if (Ball_X_OUT <= 10'd303 && Ball_X_OUT >= 10'd295 && Ball_Y_OUT <= 10'd148 && Ball_Y_OUT >= 10'd140)  // Lexington
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd299;
        pos_y_out=10'd144;
      end
    end

    if (Ball_X_OUT <= 10'd318 && Ball_X_OUT >= 10'd310 && Ball_Y_OUT <= 10'd114 && Ball_Y_OUT >= 10'd106)  // Chenoa
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd314;
        pos_y_out=10'd110;
      end
    end

    if (Ball_X_OUT <= 10'd252 && Ball_X_OUT >= 10'd244 && Ball_Y_OUT <= 10'd451 && Ball_Y_OUT >= 10'd443)  // Macon
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd248;
        pos_y_out=10'd447;
      end
    end

    if (Ball_X_OUT <= 10'd218 && Ball_X_OUT >= 10'd210 && Ball_Y_OUT <= 10'd462 && Ball_Y_OUT >= 10'd454)  // BlueMound
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd214;
        pos_y_out=10'd458;
      end
    end

    if (Ball_X_OUT <= 10'd243 && Ball_X_OUT >= 10'd235 && Ball_Y_OUT <= 10'd432 && Ball_Y_OUT >= 10'd424)  // Boody
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd239;
        pos_y_out=10'd428;
      end
    end

    if (Ball_X_OUT <= 10'd286 && Ball_X_OUT >= 10'd278 && Ball_Y_OUT <= 10'd438 && Ball_Y_OUT >= 10'd430)  // HerveyCity
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd282;
        pos_y_out=10'd434;
      end
    end

    if (Ball_X_OUT <= 10'd288 && Ball_X_OUT >= 10'd280 && Ball_Y_OUT <= 10'd420 && Ball_Y_OUT >= 10'd412)  // LongCreek
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd284;
        pos_y_out=10'd416;
      end
    end

    if (Ball_X_OUT <= 10'd384 && Ball_X_OUT >= 10'd376 && Ball_Y_OUT <= 10'd425 && Ball_Y_OUT >= 10'd417)  // Atwood
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd380;
        pos_y_out=10'd421;
      end
    end

    if (Ball_X_OUT <= 10'd381 && Ball_X_OUT >= 10'd373 && Ball_Y_OUT <= 10'd453 && Ball_Y_OUT >= 10'd445)  // Arthur
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd377;
        pos_y_out=10'd449;
      end
    end

    if (Ball_X_OUT <= 10'd430 && Ball_X_OUT >= 10'd422 && Ball_Y_OUT <= 10'd423 && Ball_Y_OUT >= 10'd415)  // Tuscola
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd426;
        pos_y_out=10'd419;
      end
    end

    if (Ball_X_OUT <= 10'd426 && Ball_X_OUT >= 10'd418 && Ball_Y_OUT <= 10'd457 && Ball_Y_OUT >= 10'd449)  // Arcola
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd422;
        pos_y_out=10'd453;
      end
    end

    if (Ball_X_OUT <= 10'd480 && Ball_X_OUT >= 10'd472 && Ball_Y_OUT <= 10'd423 && Ball_Y_OUT >= 10'd415)  // Murdock
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd476;
        pos_y_out=10'd419;
      end
    end

    if (Ball_X_OUT <= 10'd504 && Ball_X_OUT >= 10'd496 && Ball_Y_OUT <= 10'd422 && Ball_Y_OUT >= 10'd414)  // Newman
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd500;
        pos_y_out=10'd418;
      end
    end

    if (Ball_X_OUT <= 10'd552 && Ball_X_OUT >= 10'd544 && Ball_Y_OUT <= 10'd420 && Ball_Y_OUT >= 10'd412)  // Metcalf
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd548;
        pos_y_out=10'd416;
      end
    end

    if (Ball_X_OUT <= 10'd581 && Ball_X_OUT >= 10'd573 && Ball_Y_OUT <= 10'd420 && Ball_Y_OUT >= 10'd412)  // Chrisman
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd577;
        pos_y_out=10'd416;
      end
    end

    if (Ball_X_OUT <= 10'd624 && Ball_X_OUT >= 10'd616 && Ball_Y_OUT <= 10'd418 && Ball_Y_OUT >= 10'd410)  // WestDana
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd620;
        pos_y_out=10'd414;
      end
    end

    if (Ball_X_OUT <= 10'd586 && Ball_X_OUT >= 10'd578 && Ball_Y_OUT <= 10'd388 && Ball_Y_OUT >= 10'd380)  // RidgeFarm
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd582;
        pos_y_out=10'd384;
      end
    end

    if (Ball_X_OUT <= 10'd592 && Ball_X_OUT >= 10'd584 && Ball_Y_OUT <= 10'd347 && Ball_Y_OUT >= 10'd339)  // Westville
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd588;
        pos_y_out=10'd343;
      end
    end

    if (Ball_X_OUT <= 10'd590 && Ball_X_OUT >= 10'd582 && Ball_Y_OUT <= 10'd322 && Ball_Y_OUT >= 10'd314)  // Tilton
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd586;
        pos_y_out=10'd318;
      end
    end

    if (Ball_X_OUT <= 10'd595 && Ball_X_OUT >= 10'd587 && Ball_Y_OUT <= 10'd311 && Ball_Y_OUT >= 10'd303)  // Danville
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd591;
        pos_y_out=10'd307;
      end
    end

    if (Ball_X_OUT <= 10'd548 && Ball_X_OUT >= 10'd540 && Ball_Y_OUT <= 10'd278 && Ball_Y_OUT >= 10'd270)  // Collison
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd544;
        pos_y_out=10'd274;
      end
    end

    if (Ball_X_OUT <= 10'd574 && Ball_X_OUT >= 10'd566 && Ball_Y_OUT <= 10'd253 && Ball_Y_OUT >= 10'd245)  // Henning
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd570;
        pos_y_out=10'd249;
      end
    end

    if (Ball_X_OUT <= 10'd581 && Ball_X_OUT >= 10'd573 && Ball_Y_OUT <= 10'd228 && Ball_Y_OUT >= 10'd220)  // Rossville
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd577;
        pos_y_out=10'd224;
      end
    end

    if (Ball_X_OUT <= 10'd580 && Ball_X_OUT >= 10'd572 && Ball_Y_OUT <= 10'd200 && Ball_Y_OUT >= 10'd192)  // Hoopston
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd576;
        pos_y_out=10'd196;
      end
    end

    if (Ball_X_OUT <= 10'd572 && Ball_X_OUT >= 10'd564 && Ball_Y_OUT <= 10'd144 && Ball_Y_OUT >= 10'd136)  // Milford
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd568;
        pos_y_out=10'd140;
      end
    end

    if (Ball_X_OUT <= 10'd565 && Ball_X_OUT >= 10'd557 && Ball_Y_OUT <= 10'd125 && Ball_Y_OUT >= 10'd117)  // WoodlandJct.
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd561;
        pos_y_out=10'd121;
      end
    end

    if (Ball_X_OUT <= 10'd561 && Ball_X_OUT >= 10'd553 && Ball_Y_OUT <= 10'd96 && Ball_Y_OUT >= 10'd88)  // Watseka
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd557;
        pos_y_out=10'd92;
      end
    end

    if (Ball_X_OUT <= 10'd594 && Ball_X_OUT >= 10'd586 && Ball_Y_OUT <= 10'd99 && Ball_Y_OUT >= 10'd91)  // Webster
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd590;
        pos_y_out=10'd95;
      end
    end

    if (Ball_X_OUT <= 10'd497 && Ball_X_OUT >= 10'd489 && Ball_Y_OUT <= 10'd101 && Ball_Y_OUT >= 10'd93)  // Gilman
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd493;
        pos_y_out=10'd97;
      end
    end

    if (Ball_X_OUT <= 10'd494 && Ball_X_OUT >= 10'd486 && Ball_Y_OUT <= 10'd121 && Ball_Y_OUT >= 10'd113)  // Onarga
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd490;
        pos_y_out=10'd117;
      end
    end

    if (Ball_X_OUT <= 10'd475 && Ball_X_OUT >= 10'd467 && Ball_Y_OUT <= 10'd204 && Ball_Y_OUT >= 10'd196)  // Paxton
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd471;
        pos_y_out=10'd200;
      end
    end

    if (Ball_X_OUT <= 10'd459 && Ball_X_OUT >= 10'd451 && Ball_Y_OUT <= 10'd253 && Ball_Y_OUT >= 10'd245)  // Rantoul
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd455;
        pos_y_out=10'd249;
      end
    end

    if (Ball_X_OUT <= 10'd480 && Ball_X_OUT >= 10'd472 && Ball_Y_OUT <= 10'd251 && Ball_Y_OUT >= 10'd243)  // Dillsburg
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd476;
        pos_y_out=10'd247;
      end
    end

    if (Ball_X_OUT <= 10'd414 && Ball_X_OUT >= 10'd406 && Ball_Y_OUT <= 10'd251 && Ball_Y_OUT >= 10'd243)  // Fisher
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd410;
        pos_y_out=10'd247;
      end
    end

    if (Ball_X_OUT <= 10'd453 && Ball_X_OUT >= 10'd445 && Ball_Y_OUT <= 10'd273 && Ball_Y_OUT >= 10'd265)  // Thomasboro
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd449;
        pos_y_out=10'd269;
      end
    end

    if (Ball_X_OUT <= 10'd447 && Ball_X_OUT >= 10'd439 && Ball_Y_OUT <= 10'd320 && Ball_Y_OUT >= 10'd312)  // Urbana
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd443;
        pos_y_out=10'd316;
      end
    end

    if (Ball_X_OUT <= 10'd398 && Ball_X_OUT >= 10'd390 && Ball_Y_OUT <= 10'd322 && Ball_Y_OUT >= 10'd314)  // Champaign
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd394;
        pos_y_out=10'd318;
      end
    end

    if (Ball_X_OUT <= 10'd439 && Ball_X_OUT >= 10'd431 && Ball_Y_OUT <= 10'd343 && Ball_Y_OUT >= 10'd335)  // Savoy
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd435;
        pos_y_out=10'd339;
      end
    end

    if (Ball_X_OUT <= 10'd434 && Ball_X_OUT >= 10'd426 && Ball_Y_OUT <= 10'd361 && Ball_Y_OUT >= 10'd353)  // Tolono
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd430;
        pos_y_out=10'd357;
      end
    end

    if (Ball_X_OUT <= 10'd484 && Ball_X_OUT >= 10'd476 && Ball_Y_OUT <= 10'd347 && Ball_Y_OUT >= 10'd339)  // Sidney
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd480;
        pos_y_out=10'd343;
      end
    end

    if (Ball_X_OUT <= 10'd508 && Ball_X_OUT >= 10'd500 && Ball_Y_OUT <= 10'd343 && Ball_Y_OUT >= 10'd335)  // Homer
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd504;
        pos_y_out=10'd339;
      end
    end

    if (Ball_X_OUT <= 10'd497 && Ball_X_OUT >= 10'd489 && Ball_Y_OUT <= 10'd320 && Ball_Y_OUT >= 10'd312)  // Glover
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd493;
        pos_y_out=10'd316;
      end
    end

    if (Ball_X_OUT <= 10'd551 && Ball_X_OUT >= 10'd543 && Ball_Y_OUT <= 10'd168 && Ball_Y_OUT >= 10'd160)  // Goodwine
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd547;
        pos_y_out=10'd164;
      end
    end

    if (Ball_X_OUT <= 10'd524 && Ball_X_OUT >= 10'd516 && Ball_Y_OUT <= 10'd169 && Ball_Y_OUT >= 10'd161)  // CissnaPark
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd520;
        pos_y_out=10'd165;
      end
    end

    if (Ball_X_OUT <= 10'd465 && Ball_X_OUT >= 10'd457 && Ball_Y_OUT <= 10'd400 && Ball_Y_OUT >= 10'd392)  // VillaGrove
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd461;
        pos_y_out=10'd396;
      end
    end

    if (Ball_X_OUT <= 10'd501 && Ball_X_OUT >= 10'd493 && Ball_Y_OUT <= 10'd385 && Ball_Y_OUT >= 10'd377)  // Boradland
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd497;
        pos_y_out=10'd381;
      end
    end

    if (Ball_X_OUT <= 10'd356 && Ball_X_OUT >= 10'd348 && Ball_Y_OUT <= 10'd384 && Ball_Y_OUT >= 10'd376)  // Bement
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd352;
        pos_y_out=10'd380;
      end
    end

    if (Ball_X_OUT <= 10'd315 && Ball_X_OUT >= 10'd307 && Ball_Y_OUT <= 10'd395 && Ball_Y_OUT >= 10'd387)  // CerroGordo
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd311;
        pos_y_out=10'd391;
      end
    end

    if (Ball_X_OUT <= 10'd318 && Ball_X_OUT >= 10'd310 && Ball_Y_OUT <= 10'd355 && Ball_Y_OUT >= 10'd347)  // Cisco
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd314;
        pos_y_out=10'd351;
      end
    end

    if (Ball_X_OUT <= 10'd355 && Ball_X_OUT >= 10'd347 && Ball_Y_OUT <= 10'd347 && Ball_Y_OUT >= 10'd339)  // Monticello
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd351;
        pos_y_out=10'd343;
      end
    end

    if (Ball_X_OUT <= 10'd361 && Ball_X_OUT >= 10'd353 && Ball_Y_OUT <= 10'd322 && Ball_Y_OUT >= 10'd314)  // Lodge
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd357;
        pos_y_out=10'd318;
      end
    end

    if (Ball_X_OUT <= 10'd373 && Ball_X_OUT >= 10'd365 && Ball_Y_OUT <= 10'd288 && Ball_Y_OUT >= 10'd280)  // Mansfield
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd369;
        pos_y_out=10'd284;
      end
    end

    if (Ball_X_OUT <= 10'd382 && Ball_X_OUT >= 10'd374 && Ball_Y_OUT <= 10'd252 && Ball_Y_OUT >= 10'd244)  // Lotus
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd378;
        pos_y_out=10'd248;
      end
    end

    if (Ball_X_OUT <= 10'd404 && Ball_X_OUT >= 10'd396 && Ball_Y_OUT <= 10'd204 && Ball_Y_OUT >= 10'd196)  // GibsonCity
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd400;
        pos_y_out=10'd200;
      end
    end

    if (Ball_X_OUT <= 10'd435 && Ball_X_OUT >= 10'd427 && Ball_Y_OUT <= 10'd170 && Ball_Y_OUT >= 10'd162)  // Melvin
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd431;
        pos_y_out=10'd166;
      end
    end

    if (Ball_X_OUT <= 10'd308 && Ball_X_OUT >= 10'd300 && Ball_Y_OUT <= 10'd244 && Ball_Y_OUT >= 10'd236)  // LeRoy
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd304;
        pos_y_out=10'd240;
      end
    end

    if (Ball_X_OUT <= 10'd346 && Ball_X_OUT >= 10'd338 && Ball_Y_OUT <= 10'd210 && Ball_Y_OUT >= 10'd202)  // Arrowsmith
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd342;
        pos_y_out=10'd206;
      end
    end

    if (Ball_X_OUT <= 10'd393 && Ball_X_OUT >= 10'd385 && Ball_Y_OUT <= 10'd140 && Ball_Y_OUT >= 10'd132)  // Risk
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd389;
        pos_y_out=10'd136;
      end
    end

    if (Ball_X_OUT <= 10'd343 && Ball_X_OUT >= 10'd335 && Ball_Y_OUT <= 10'd172 && Ball_Y_OUT >= 10'd164)  // Colfax
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd339;
        pos_y_out=10'd168;
      end
    end

    if (Ball_X_OUT <= 10'd423 && Ball_X_OUT >= 10'd415 && Ball_Y_OUT <= 10'd107 && Ball_Y_OUT >= 10'd99)  // Chatsworth
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd419;
        pos_y_out=10'd103;
      end
    end

    if (Ball_X_OUT <= 10'd396 && Ball_X_OUT >= 10'd388 && Ball_Y_OUT <= 10'd108 && Ball_Y_OUT >= 10'd100)  // Forrest
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd392;
        pos_y_out=10'd104;
      end
    end

    if (Ball_X_OUT <= 10'd364 && Ball_X_OUT >= 10'd356 && Ball_Y_OUT <= 10'd112 && Ball_Y_OUT >= 10'd104)  // Fairbury
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd360;
        pos_y_out=10'd108;
      end
    end

    if (Ball_X_OUT <= 10'd339 && Ball_X_OUT >= 10'd331 && Ball_Y_OUT <= 10'd277 && Ball_Y_OUT >= 10'd269)  // FarmerCity
    begin
      if (LEFT==enter)
      begin
        pos_x_out=10'd335;
        pos_y_out=10'd273;
      end
    end






    // usb part


    if (Ball_X_OUT1 <= 10'd28 && Ball_X_OUT1 >= 10'd20 && Ball_Y_OUT1 <= 10'd132 && Ball_Y_OUT1 >= 10'd124)  // Elm
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd24;
        pos_y_out=10'd128;
      end
    end

    if (Ball_X_OUT1 <= 10'd49 && Ball_X_OUT1 >= 10'd41 && Ball_Y_OUT1 <= 10'd172 && Ball_Y_OUT1 >= 10'd164)  // Glasford
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd45;
        pos_y_out=10'd168;
      end
    end

    if (Ball_X_OUT1 <= 10'd55 && Ball_X_OUT1 >= 10'd47 && Ball_Y_OUT1 <= 10'd220 && Ball_Y_OUT1 >= 10'd212)  // Manito
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd51;
        pos_y_out=10'd216;
      end
    end

    if (Ball_X_OUT1 <= 10'd76 && Ball_X_OUT1 >= 10'd68 && Ball_Y_OUT1 <= 10'd444 && Ball_Y_OUT1 >= 10'd436)  // Jct
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd72;
        pos_y_out=10'd440;
      end
    end

    if (Ball_X_OUT1 <= 10'd87 && Ball_X_OUT1 >= 10'd79 && Ball_Y_OUT1 <= 10'd434 && Ball_Y_OUT1 >= 10'd426)  // lles
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd83;
        pos_y_out=10'd430;
      end
    end

    if (Ball_X_OUT1 <= 10'd99 && Ball_X_OUT1 >= 10'd91 && Ball_Y_OUT1 <= 10'd418 && Ball_Y_OUT1 >= 10'd410)  // Starnes
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd95;
        pos_y_out=10'd414;
      end
    end

    if (Ball_X_OUT1 <= 10'd116 && Ball_X_OUT1 >= 10'd108 && Ball_Y_OUT1 <= 10'd410 && Ball_Y_OUT1 >= 10'd402)  // Riverton
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd112;
        pos_y_out=10'd406;
      end
    end

    if (Ball_X_OUT1 <= 10'd100 && Ball_X_OUT1 >= 10'd92 && Ball_Y_OUT1 <= 10'd396 && Ball_Y_OUT1 >= 10'd388)  // Sherman
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd96;
        pos_y_out=10'd392;
      end
    end

    if (Ball_X_OUT1 <= 10'd76 && Ball_X_OUT1 >= 10'd68 && Ball_Y_OUT1 <= 10'd377 && Ball_Y_OUT1 >= 10'd369)  // BarrStation
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd72;
        pos_y_out=10'd373;
      end
    end

    if (Ball_X_OUT1 <= 10'd89 && Ball_X_OUT1 >= 10'd81 && Ball_Y_OUT1 <= 10'd290 && Ball_Y_OUT1 >= 10'd282)  // Luther
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd85;
        pos_y_out=10'd286;
      end
    end

    if (Ball_X_OUT1 <= 10'd90 && Ball_X_OUT1 >= 10'd82 && Ball_Y_OUT1 <= 10'd226 && Ball_Y_OUT1 >= 10'd218)  // GreenValley
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd86;
        pos_y_out=10'd222;
      end
    end

    if (Ball_X_OUT1 <= 10'd89 && Ball_X_OUT1 >= 10'd81 && Ball_Y_OUT1 <= 10'd198 && Ball_Y_OUT1 >= 10'd190)  // SouthPekin
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd85;
        pos_y_out=10'd194;
      end
    end

    if (Ball_X_OUT1 <= 10'd83 && Ball_X_OUT1 >= 10'd75 && Ball_Y_OUT1 <= 10'd180 && Ball_Y_OUT1 >= 10'd172)  // Powerton
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd79;
        pos_y_out=10'd176;
      end
    end

    if (Ball_X_OUT1 <= 10'd54 && Ball_X_OUT1 >= 10'd46 && Ball_Y_OUT1 <= 10'd131 && Ball_Y_OUT1 >= 10'd123)  // HannaCity
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd50;
        pos_y_out=10'd127;
      end
    end

    if (Ball_X_OUT1 <= 10'd109 && Ball_X_OUT1 >= 10'd101 && Ball_Y_OUT1 <= 10'd91 && Ball_Y_OUT1 >= 10'd83)  // Mossville
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd105;
        pos_y_out=10'd87;
      end
    end

    if (Ball_X_OUT1 <= 10'd106 && Ball_X_OUT1 >= 10'd98 && Ball_Y_OUT1 <= 10'd139 && Ball_Y_OUT1 >= 10'd131)  // EastPeoria
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd102;
        pos_y_out=10'd135;
      end
    end

    if (Ball_X_OUT1 <= 10'd115 && Ball_X_OUT1 >= 10'd107 && Ball_Y_OUT1 <= 10'd236 && Ball_Y_OUT1 >= 10'd228)  // Delavan
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd111;
        pos_y_out=10'd232;
      end
    end

    if (Ball_X_OUT1 <= 10'd125 && Ball_X_OUT1 >= 10'd117 && Ball_Y_OUT1 <= 10'd143 && Ball_Y_OUT1 >= 10'd135)  // Farmdale
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd121;
        pos_y_out=10'd139;
      end
    end

    if (Ball_X_OUT1 <= 10'd146 && Ball_X_OUT1 >= 10'd138 && Ball_Y_OUT1 <= 10'd128 && Ball_Y_OUT1 >= 10'd120)  // Washington
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd142;
        pos_y_out=10'd124;
      end
    end

    if (Ball_X_OUT1 <= 10'd184 && Ball_X_OUT1 >= 10'd176 && Ball_Y_OUT1 <= 10'd121 && Ball_Y_OUT1 >= 10'd113)  // Eureka
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd180;
        pos_y_out=10'd117;
      end
    end

    if (Ball_X_OUT1 <= 10'd244 && Ball_X_OUT1 >= 10'd236 && Ball_Y_OUT1 <= 10'd116 && Ball_Y_OUT1 >= 10'd108)  // ElPaso
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd240;
        pos_y_out=10'd112;
      end
    end

    if (Ball_X_OUT1 <= 10'd163 && Ball_X_OUT1 >= 10'd155 && Ball_Y_OUT1 <= 10'd309 && Ball_Y_OUT1 >= 10'd301)  // Lincoin
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd159;
        pos_y_out=10'd305;
      end
    end

    if (Ball_X_OUT1 <= 10'd177 && Ball_X_OUT1 >= 10'd169 && Ball_Y_OUT1 <= 10'd358 && Ball_Y_OUT1 >= 10'd350)  // Mt.Pulaski
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd173;
        pos_y_out=10'd354;
      end
    end

    if (Ball_X_OUT1 <= 10'd188 && Ball_X_OUT1 >= 10'd180 && Ball_Y_OUT1 <= 10'd409 && Ball_Y_OUT1 >= 10'd401)  // Illiopoils
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd184;
        pos_y_out=10'd405;
      end
    end

    if (Ball_X_OUT1 <= 10'd226 && Ball_X_OUT1 >= 10'd218 && Ball_Y_OUT1 <= 10'd409 && Ball_Y_OUT1 >= 10'd401)  // Harristown
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd222;
        pos_y_out=10'd405;
      end
    end

    if (Ball_X_OUT1 <= 10'd263 && Ball_X_OUT1 >= 10'd255 && Ball_Y_OUT1 <= 10'd410 && Ball_Y_OUT1 >= 10'd402)  // Decatur
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd259;
        pos_y_out=10'd406;
      end
    end

    if (Ball_X_OUT1 <= 10'd234 && Ball_X_OUT1 >= 10'd226 && Ball_Y_OUT1 <= 10'd382 && Ball_Y_OUT1 >= 10'd374)  // Warrensburg
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd230;
        pos_y_out=10'd378;
      end
    end

    if (Ball_X_OUT1 <= 10'd229 && Ball_X_OUT1 >= 10'd221 && Ball_Y_OUT1 <= 10'd329 && Ball_Y_OUT1 >= 10'd321)  // Kenney
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd225;
        pos_y_out=10'd325;
      end
    end

    if (Ball_X_OUT1 <= 10'd256 && Ball_X_OUT1 >= 10'd248 && Ball_Y_OUT1 <= 10'd310 && Ball_Y_OUT1 >= 10'd302)  // Clinton
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd252;
        pos_y_out=10'd306;
      end
    end

    if (Ball_X_OUT1 <= 10'd257 && Ball_X_OUT1 >= 10'd249 && Ball_Y_OUT1 <= 10'd258 && Ball_Y_OUT1 >= 10'd250)  // Heyworth
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd253;
        pos_y_out=10'd254;
      end
    end

    if (Ball_X_OUT1 <= 10'd192 && Ball_X_OUT1 >= 10'd184 && Ball_Y_OUT1 <= 10'd274 && Ball_Y_OUT1 >= 10'd266)  // Atlanta
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd188;
        pos_y_out=10'd270;
      end
    end

    if (Ball_X_OUT1 <= 10'd249 && Ball_X_OUT1 >= 10'd241 && Ball_Y_OUT1 <= 10'd202 && Ball_Y_OUT1 >= 10'd194)  // Bloomington
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd245;
        pos_y_out=10'd198;
      end
    end

    if (Ball_X_OUT1 <= 10'd213 && Ball_X_OUT1 >= 10'd205 && Ball_Y_OUT1 <= 10'd167 && Ball_Y_OUT1 >= 10'd159)  // Carlock
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd209;
        pos_y_out=10'd163;
      end
    end

    if (Ball_X_OUT1 <= 10'd142 && Ball_X_OUT1 >= 10'd134 && Ball_Y_OUT1 <= 10'd151 && Ball_Y_OUT1 >= 10'd143)  // Crandall
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd138;
        pos_y_out=10'd147;
      end
    end

    if (Ball_X_OUT1 <= 10'd303 && Ball_X_OUT1 >= 10'd295 && Ball_Y_OUT1 <= 10'd148 && Ball_Y_OUT1 >= 10'd140)  // Lexington
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd299;
        pos_y_out=10'd144;
      end
    end

    if (Ball_X_OUT1 <= 10'd318 && Ball_X_OUT1 >= 10'd310 && Ball_Y_OUT1 <= 10'd114 && Ball_Y_OUT1 >= 10'd106)  // Chenoa
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd314;
        pos_y_out=10'd110;
      end
    end

    if (Ball_X_OUT1 <= 10'd252 && Ball_X_OUT1 >= 10'd244 && Ball_Y_OUT1 <= 10'd451 && Ball_Y_OUT1 >= 10'd443)  // Macon
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd248;
        pos_y_out=10'd447;
      end
    end

    if (Ball_X_OUT1 <= 10'd218 && Ball_X_OUT1 >= 10'd210 && Ball_Y_OUT1 <= 10'd462 && Ball_Y_OUT1 >= 10'd454)  // BlueMound
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd214;
        pos_y_out=10'd458;
      end
    end

    if (Ball_X_OUT1 <= 10'd243 && Ball_X_OUT1 >= 10'd235 && Ball_Y_OUT1 <= 10'd432 && Ball_Y_OUT1 >= 10'd424)  // Boody
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd239;
        pos_y_out=10'd428;
      end
    end

    if (Ball_X_OUT1 <= 10'd286 && Ball_X_OUT1 >= 10'd278 && Ball_Y_OUT1 <= 10'd438 && Ball_Y_OUT1 >= 10'd430)  // HerveyCity
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd282;
        pos_y_out=10'd434;
      end
    end

    if (Ball_X_OUT1 <= 10'd288 && Ball_X_OUT1 >= 10'd280 && Ball_Y_OUT1 <= 10'd420 && Ball_Y_OUT1 >= 10'd412)  // LongCreek
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd284;
        pos_y_out=10'd416;
      end
    end

    if (Ball_X_OUT1 <= 10'd384 && Ball_X_OUT1 >= 10'd376 && Ball_Y_OUT1 <= 10'd425 && Ball_Y_OUT1 >= 10'd417)  // Atwood
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd380;
        pos_y_out=10'd421;
      end
    end

    if (Ball_X_OUT1 <= 10'd381 && Ball_X_OUT1 >= 10'd373 && Ball_Y_OUT1 <= 10'd453 && Ball_Y_OUT1 >= 10'd445)  // Arthur
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd377;
        pos_y_out=10'd449;
      end
    end

    if (Ball_X_OUT1 <= 10'd430 && Ball_X_OUT1 >= 10'd422 && Ball_Y_OUT1 <= 10'd423 && Ball_Y_OUT1 >= 10'd415)  // Tuscola
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd426;
        pos_y_out=10'd419;
      end
    end

    if (Ball_X_OUT1 <= 10'd426 && Ball_X_OUT1 >= 10'd418 && Ball_Y_OUT1 <= 10'd457 && Ball_Y_OUT1 >= 10'd449)  // Arcola
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd422;
        pos_y_out=10'd453;
      end
    end

    if (Ball_X_OUT1 <= 10'd480 && Ball_X_OUT1 >= 10'd472 && Ball_Y_OUT1 <= 10'd423 && Ball_Y_OUT1 >= 10'd415)  // Murdock
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd476;
        pos_y_out=10'd419;
      end
    end

    if (Ball_X_OUT1 <= 10'd504 && Ball_X_OUT1 >= 10'd496 && Ball_Y_OUT1 <= 10'd422 && Ball_Y_OUT1 >= 10'd414)  // Newman
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd500;
        pos_y_out=10'd418;
      end
    end

    if (Ball_X_OUT1 <= 10'd552 && Ball_X_OUT1 >= 10'd544 && Ball_Y_OUT1 <= 10'd420 && Ball_Y_OUT1 >= 10'd412)  // Metcalf
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd548;
        pos_y_out=10'd416;
      end
    end

    if (Ball_X_OUT1 <= 10'd581 && Ball_X_OUT1 >= 10'd573 && Ball_Y_OUT1 <= 10'd420 && Ball_Y_OUT1 >= 10'd412)  // Chrisman
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd577;
        pos_y_out=10'd416;
      end
    end

    if (Ball_X_OUT1 <= 10'd624 && Ball_X_OUT1 >= 10'd616 && Ball_Y_OUT1 <= 10'd418 && Ball_Y_OUT1 >= 10'd410)  // WestDana
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd620;
        pos_y_out=10'd414;
      end
    end

    if (Ball_X_OUT1 <= 10'd586 && Ball_X_OUT1 >= 10'd578 && Ball_Y_OUT1 <= 10'd388 && Ball_Y_OUT1 >= 10'd380)  // RidgeFarm
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd582;
        pos_y_out=10'd384;
      end
    end

    if (Ball_X_OUT1 <= 10'd592 && Ball_X_OUT1 >= 10'd584 && Ball_Y_OUT1 <= 10'd347 && Ball_Y_OUT1 >= 10'd339)  // Westville
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd588;
        pos_y_out=10'd343;
      end
    end

    if (Ball_X_OUT1 <= 10'd590 && Ball_X_OUT1 >= 10'd582 && Ball_Y_OUT1 <= 10'd322 && Ball_Y_OUT1 >= 10'd314)  // Tilton
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd586;
        pos_y_out=10'd318;
      end
    end

    if (Ball_X_OUT1 <= 10'd595 && Ball_X_OUT1 >= 10'd587 && Ball_Y_OUT1 <= 10'd311 && Ball_Y_OUT1 >= 10'd303)  // Danville
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd591;
        pos_y_out=10'd307;
      end
    end

    if (Ball_X_OUT1 <= 10'd548 && Ball_X_OUT1 >= 10'd540 && Ball_Y_OUT1 <= 10'd278 && Ball_Y_OUT1 >= 10'd270)  // Collison
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd544;
        pos_y_out=10'd274;
      end
    end

    if (Ball_X_OUT1 <= 10'd574 && Ball_X_OUT1 >= 10'd566 && Ball_Y_OUT1 <= 10'd253 && Ball_Y_OUT1 >= 10'd245)  // Henning
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd570;
        pos_y_out=10'd249;
      end
    end

    if (Ball_X_OUT1 <= 10'd581 && Ball_X_OUT1 >= 10'd573 && Ball_Y_OUT1 <= 10'd228 && Ball_Y_OUT1 >= 10'd220)  // Rossville
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd577;
        pos_y_out=10'd224;
      end
    end

    if (Ball_X_OUT1 <= 10'd580 && Ball_X_OUT1 >= 10'd572 && Ball_Y_OUT1 <= 10'd200 && Ball_Y_OUT1 >= 10'd192)  // Hoopston
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd576;
        pos_y_out=10'd196;
      end
    end

    if (Ball_X_OUT1 <= 10'd572 && Ball_X_OUT1 >= 10'd564 && Ball_Y_OUT1 <= 10'd144 && Ball_Y_OUT1 >= 10'd136)  // Milford
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd568;
        pos_y_out=10'd140;
      end
    end

    if (Ball_X_OUT1 <= 10'd565 && Ball_X_OUT1 >= 10'd557 && Ball_Y_OUT1 <= 10'd125 && Ball_Y_OUT1 >= 10'd117)  // WoodlandJct.
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd561;
        pos_y_out=10'd121;
      end
    end

    if (Ball_X_OUT1 <= 10'd561 && Ball_X_OUT1 >= 10'd553 && Ball_Y_OUT1 <= 10'd96 && Ball_Y_OUT1 >= 10'd88)  // Watseka
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd557;
        pos_y_out=10'd92;
      end
    end

    if (Ball_X_OUT1 <= 10'd594 && Ball_X_OUT1 >= 10'd586 && Ball_Y_OUT1 <= 10'd99 && Ball_Y_OUT1 >= 10'd91)  // Webster
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd590;
        pos_y_out=10'd95;
      end
    end

    if (Ball_X_OUT1 <= 10'd497 && Ball_X_OUT1 >= 10'd489 && Ball_Y_OUT1 <= 10'd101 && Ball_Y_OUT1 >= 10'd93)  // Gilman
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd493;
        pos_y_out=10'd97;
      end
    end

    if (Ball_X_OUT1 <= 10'd494 && Ball_X_OUT1 >= 10'd486 && Ball_Y_OUT1 <= 10'd121 && Ball_Y_OUT1 >= 10'd113)  // Onarga
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd490;
        pos_y_out=10'd117;
      end
    end

    if (Ball_X_OUT1 <= 10'd475 && Ball_X_OUT1 >= 10'd467 && Ball_Y_OUT1 <= 10'd204 && Ball_Y_OUT1 >= 10'd196)  // Paxton
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd471;
        pos_y_out=10'd200;
      end
    end

    if (Ball_X_OUT1 <= 10'd459 && Ball_X_OUT1 >= 10'd451 && Ball_Y_OUT1 <= 10'd253 && Ball_Y_OUT1 >= 10'd245)  // Rantoul
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd455;
        pos_y_out=10'd249;
      end
    end

    if (Ball_X_OUT1 <= 10'd480 && Ball_X_OUT1 >= 10'd472 && Ball_Y_OUT1 <= 10'd251 && Ball_Y_OUT1 >= 10'd243)  // Dillsburg
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd476;
        pos_y_out=10'd247;
      end
    end

    if (Ball_X_OUT1 <= 10'd414 && Ball_X_OUT1 >= 10'd406 && Ball_Y_OUT1 <= 10'd251 && Ball_Y_OUT1 >= 10'd243)  // Fisher
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd410;
        pos_y_out=10'd247;
      end
    end

    if (Ball_X_OUT1 <= 10'd453 && Ball_X_OUT1 >= 10'd445 && Ball_Y_OUT1 <= 10'd273 && Ball_Y_OUT1 >= 10'd265)  // Thomasboro
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd449;
        pos_y_out=10'd269;
      end
    end

    if (Ball_X_OUT1 <= 10'd447 && Ball_X_OUT1 >= 10'd439 && Ball_Y_OUT1 <= 10'd320 && Ball_Y_OUT1 >= 10'd312)  // Urbana
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd443;
        pos_y_out=10'd316;
      end
    end

    if (Ball_X_OUT1 <= 10'd398 && Ball_X_OUT1 >= 10'd390 && Ball_Y_OUT1 <= 10'd322 && Ball_Y_OUT1 >= 10'd314)  // Champaign
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd394;
        pos_y_out=10'd318;
      end
    end

    if (Ball_X_OUT1 <= 10'd439 && Ball_X_OUT1 >= 10'd431 && Ball_Y_OUT1 <= 10'd343 && Ball_Y_OUT1 >= 10'd335)  // Savoy
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd435;
        pos_y_out=10'd339;
      end
    end

    if (Ball_X_OUT1 <= 10'd434 && Ball_X_OUT1 >= 10'd426 && Ball_Y_OUT1 <= 10'd361 && Ball_Y_OUT1 >= 10'd353)  // Tolono
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd430;
        pos_y_out=10'd357;
      end
    end

    if (Ball_X_OUT1 <= 10'd484 && Ball_X_OUT1 >= 10'd476 && Ball_Y_OUT1 <= 10'd347 && Ball_Y_OUT1 >= 10'd339)  // Sidney
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd480;
        pos_y_out=10'd343;
      end
    end

    if (Ball_X_OUT1 <= 10'd508 && Ball_X_OUT1 >= 10'd500 && Ball_Y_OUT1 <= 10'd343 && Ball_Y_OUT1 >= 10'd335)  // Homer
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd504;
        pos_y_out=10'd339;
      end
    end

    if (Ball_X_OUT1 <= 10'd497 && Ball_X_OUT1 >= 10'd489 && Ball_Y_OUT1 <= 10'd320 && Ball_Y_OUT1 >= 10'd312)  // Glover
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd493;
        pos_y_out=10'd316;
      end
    end

    if (Ball_X_OUT1 <= 10'd551 && Ball_X_OUT1 >= 10'd543 && Ball_Y_OUT1 <= 10'd168 && Ball_Y_OUT1 >= 10'd160)  // Goodwine
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd547;
        pos_y_out=10'd164;
      end
    end

    if (Ball_X_OUT1 <= 10'd524 && Ball_X_OUT1 >= 10'd516 && Ball_Y_OUT1 <= 10'd169 && Ball_Y_OUT1 >= 10'd161)  // CissnaPark
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd520;
        pos_y_out=10'd165;
      end
    end

    if (Ball_X_OUT1 <= 10'd465 && Ball_X_OUT1 >= 10'd457 && Ball_Y_OUT1 <= 10'd400 && Ball_Y_OUT1 >= 10'd392)  // VillaGrove
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd461;
        pos_y_out=10'd396;
      end
    end

    if (Ball_X_OUT1 <= 10'd501 && Ball_X_OUT1 >= 10'd493 && Ball_Y_OUT1 <= 10'd385 && Ball_Y_OUT1 >= 10'd377)  // Boradland
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd497;
        pos_y_out=10'd381;
      end
    end

    if (Ball_X_OUT1 <= 10'd356 && Ball_X_OUT1 >= 10'd348 && Ball_Y_OUT1 <= 10'd384 && Ball_Y_OUT1 >= 10'd376)  // Bement
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd352;
        pos_y_out=10'd380;
      end
    end

    if (Ball_X_OUT1 <= 10'd315 && Ball_X_OUT1 >= 10'd307 && Ball_Y_OUT1 <= 10'd395 && Ball_Y_OUT1 >= 10'd387)  // CerroGordo
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd311;
        pos_y_out=10'd391;
      end
    end

    if (Ball_X_OUT1 <= 10'd318 && Ball_X_OUT1 >= 10'd310 && Ball_Y_OUT1 <= 10'd355 && Ball_Y_OUT1 >= 10'd347)  // Cisco
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd314;
        pos_y_out=10'd351;
      end
    end

    if (Ball_X_OUT1 <= 10'd355 && Ball_X_OUT1 >= 10'd347 && Ball_Y_OUT1 <= 10'd347 && Ball_Y_OUT1 >= 10'd339)  // Monticello
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd351;
        pos_y_out=10'd343;
      end
    end

    if (Ball_X_OUT1 <= 10'd361 && Ball_X_OUT1 >= 10'd353 && Ball_Y_OUT1 <= 10'd322 && Ball_Y_OUT1 >= 10'd314)  // Lodge
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd357;
        pos_y_out=10'd318;
      end
    end

    if (Ball_X_OUT1 <= 10'd373 && Ball_X_OUT1 >= 10'd365 && Ball_Y_OUT1 <= 10'd288 && Ball_Y_OUT1 >= 10'd280)  // Mansfield
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd369;
        pos_y_out=10'd284;
      end
    end

    if (Ball_X_OUT1 <= 10'd382 && Ball_X_OUT1 >= 10'd374 && Ball_Y_OUT1 <= 10'd252 && Ball_Y_OUT1 >= 10'd244)  // Lotus
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd378;
        pos_y_out=10'd248;
      end
    end

    if (Ball_X_OUT1 <= 10'd404 && Ball_X_OUT1 >= 10'd396 && Ball_Y_OUT1 <= 10'd204 && Ball_Y_OUT1 >= 10'd196)  // GibsonCity
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd400;
        pos_y_out=10'd200;
      end
    end

    if (Ball_X_OUT1 <= 10'd435 && Ball_X_OUT1 >= 10'd427 && Ball_Y_OUT1 <= 10'd170 && Ball_Y_OUT1 >= 10'd162)  // Melvin
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd431;
        pos_y_out=10'd166;
      end
    end

    if (Ball_X_OUT1 <= 10'd308 && Ball_X_OUT1 >= 10'd300 && Ball_Y_OUT1 <= 10'd244 && Ball_Y_OUT1 >= 10'd236)  // LeRoy
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd304;
        pos_y_out=10'd240;
      end
    end

    if (Ball_X_OUT1 <= 10'd346 && Ball_X_OUT1 >= 10'd338 && Ball_Y_OUT1 <= 10'd210 && Ball_Y_OUT1 >= 10'd202)  // Arrowsmith
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd342;
        pos_y_out=10'd206;
      end
    end

    if (Ball_X_OUT1 <= 10'd393 && Ball_X_OUT1 >= 10'd385 && Ball_Y_OUT1 <= 10'd140 && Ball_Y_OUT1 >= 10'd132)  // Risk
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd389;
        pos_y_out=10'd136;
      end
    end

    if (Ball_X_OUT1 <= 10'd343 && Ball_X_OUT1 >= 10'd335 && Ball_Y_OUT1 <= 10'd172 && Ball_Y_OUT1 >= 10'd164)  // Colfax
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd339;
        pos_y_out=10'd168;
      end
    end

    if (Ball_X_OUT1 <= 10'd423 && Ball_X_OUT1 >= 10'd415 && Ball_Y_OUT1 <= 10'd107 && Ball_Y_OUT1 >= 10'd99)  // Chatsworth
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd419;
        pos_y_out=10'd103;
      end
    end

    if (Ball_X_OUT1 <= 10'd396 && Ball_X_OUT1 >= 10'd388 && Ball_Y_OUT1 <= 10'd108 && Ball_Y_OUT1 >= 10'd100)  // Forrest
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd392;
        pos_y_out=10'd104;
      end
    end

    if (Ball_X_OUT1 <= 10'd364 && Ball_X_OUT1 >= 10'd356 && Ball_Y_OUT1 <= 10'd112 && Ball_Y_OUT1 >= 10'd104)  // Fairbury
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd360;
        pos_y_out=10'd108;
      end
    end

    if (Ball_X_OUT1 <= 10'd339 && Ball_X_OUT1 >= 10'd331 && Ball_Y_OUT1 <= 10'd277 && Ball_Y_OUT1 >= 10'd269)  // FarmerCity
    begin
      if (keycode == enter_usb)
      begin
        pos_x_out=10'd335;
        pos_y_out=10'd273;
      end
    end





  end
endmodule
