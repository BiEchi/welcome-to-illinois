module min8(
    input logic [7:0][15:0] INPUT,
    output logic [2:0] MIN_INDEX,
    output logic [15:0] MIN_NUM
);
    assign MIN_NUM = INPUT[MIN_INDEX];
    
    always_comb
    begin
        if (INPUT[0] <= INPUT[1] & INPUT[0] <= INPUT[2] & INPUT[0] <= INPUT[3] & INPUT[0] <= INPUT[4] & INPUT[0] <= INPUT[5] & INPUT[0] <= INPUT[6] & INPUT[0] <= INPUT[7])
        begin
            MIN_INDEX = 0;
        end
        else if (INPUT[1] <= INPUT[0] & INPUT[1] <= INPUT[2] & INPUT[1] <= INPUT[3] & INPUT[1] <= INPUT[4] & INPUT[1] <= INPUT[5] & INPUT[1] <= INPUT[6] & INPUT[1] <= INPUT[7])
        begin
            MIN_INDEX = 1;
        end
        else if (INPUT[2] <= INPUT[0] & INPUT[2] <= INPUT[1] & INPUT[2] <= INPUT[3] & INPUT[2] <= INPUT[4] & INPUT[2] <= INPUT[5] & INPUT[2] <= INPUT[6] & INPUT[2] <= INPUT[7])
        begin
            MIN_INDEX = 2;
        end
        else if (INPUT[3] <= INPUT[0] & INPUT[3] <= INPUT[1] & INPUT[3] <= INPUT[2] & INPUT[3] <= INPUT[4] & INPUT[3] <= INPUT[5] & INPUT[3] <= INPUT[6] & INPUT[3] <= INPUT[7])
        begin
            MIN_INDEX = 3;
        end
        else if (INPUT[4] <= INPUT[0] & INPUT[4] <= INPUT[1] & INPUT[4] <= INPUT[2] & INPUT[4] <= INPUT[3] & INPUT[4] <= INPUT[5] & INPUT[4] <= INPUT[6] & INPUT[4] <= INPUT[7])
        begin
            MIN_INDEX = 4;
        end
        else if (INPUT[5] <= INPUT[0] & INPUT[5] <= INPUT[1] & INPUT[5] <= INPUT[2] & INPUT[5] <= INPUT[3] & INPUT[5] <= INPUT[4] & INPUT[5] <= INPUT[6] & INPUT[5] <= INPUT[7])
        begin
            MIN_INDEX = 5;
        end
        else if (INPUT[6] <= INPUT[0] & INPUT[6] <= INPUT[1] & INPUT[6] <= INPUT[2] & INPUT[6] <= INPUT[3] & INPUT[6] <= INPUT[4] & INPUT[6] <= INPUT[5] & INPUT[6] <= INPUT[7])
        begin
            MIN_INDEX = 6;
        end
        else
        begin
            MIN_INDEX = 7;
        end
    end
endmodule

module minimum_finder(
    input logic [127:0][15:0] INPUT,
    output logic [6:0] MIN_INDEX,
    output logic [15:0] MIN_NUM
);
    logic [15:0][2:0]   MIN_INDEX_0;
    logic [15:0][15:0]  MIN_NUM_0;
    logic [1:0][2:0]    MIN_INDEX_1;
    logic [1:0][15:0]   MIN_NUM_1;
    logic MIN_INDEX_2;

    min8 min8_inst0_0 (.INPUT(INPUT[7:0]),     .MIN_INDEX(MIN_INDEX_0[0]),  .MIN_NUM(MIN_NUM_0[0]));
    min8 min8_inst0_1 (.INPUT(INPUT[15:8]),    .MIN_INDEX(MIN_INDEX_0[1]),  .MIN_NUM(MIN_NUM_0[1]));
    min8 min8_inst0_2 (.INPUT(INPUT[23:16]),   .MIN_INDEX(MIN_INDEX_0[2]),  .MIN_NUM(MIN_NUM_0[2]));
    min8 min8_inst0_3 (.INPUT(INPUT[31:24]),   .MIN_INDEX(MIN_INDEX_0[3]),  .MIN_NUM(MIN_NUM_0[3]));
    min8 min8_inst0_4 (.INPUT(INPUT[39:32]),   .MIN_INDEX(MIN_INDEX_0[4]),  .MIN_NUM(MIN_NUM_0[4]));
    min8 min8_inst0_5 (.INPUT(INPUT[47:40]),   .MIN_INDEX(MIN_INDEX_0[5]),  .MIN_NUM(MIN_NUM_0[5]));
    min8 min8_inst0_6 (.INPUT(INPUT[55:48]),   .MIN_INDEX(MIN_INDEX_0[6]),  .MIN_NUM(MIN_NUM_0[6]));
    min8 min8_inst0_7 (.INPUT(INPUT[63:56]),   .MIN_INDEX(MIN_INDEX_0[7]),  .MIN_NUM(MIN_NUM_0[7]));
    min8 min8_inst0_8 (.INPUT(INPUT[71:64]),   .MIN_INDEX(MIN_INDEX_0[8]),  .MIN_NUM(MIN_NUM_0[8]));
    min8 min8_inst0_9 (.INPUT(INPUT[79:72]),   .MIN_INDEX(MIN_INDEX_0[9]),  .MIN_NUM(MIN_NUM_0[9]));
    min8 min8_inst0_a (.INPUT(INPUT[87:80]),   .MIN_INDEX(MIN_INDEX_0[10]), .MIN_NUM(MIN_NUM_0[10]));
    min8 min8_inst0_b (.INPUT(INPUT[95:88]),   .MIN_INDEX(MIN_INDEX_0[11]), .MIN_NUM(MIN_NUM_0[11]));
    min8 min8_inst0_c (.INPUT(INPUT[103:96]),  .MIN_INDEX(MIN_INDEX_0[12]), .MIN_NUM(MIN_NUM_0[12]));
    min8 min8_inst0_d (.INPUT(INPUT[111:104]), .MIN_INDEX(MIN_INDEX_0[13]), .MIN_NUM(MIN_NUM_0[13]));
    min8 min8_inst0_e (.INPUT(INPUT[119:112]), .MIN_INDEX(MIN_INDEX_0[14]), .MIN_NUM(MIN_NUM_0[14]));
    min8 min8_inst0_f (.INPUT(INPUT[127:120]), .MIN_INDEX(MIN_INDEX_0[15]), .MIN_NUM(MIN_NUM_0[15]));

    min8 min8_inst1_0 (.INPUT(MIN_NUM_0[7:0]), .MIN_INDEX(MIN_INDEX_1[0]), .MIN_NUM(MIN_NUM_1[0]));
    min8 min8_inst1_1 (.INPUT(MIN_NUM_0[15:8]), .MIN_INDEX(MIN_INDEX_1[1]), .MIN_NUM(MIN_NUM_1[1]));
    
    assign MIN_INDEX_2 = (MIN_NUM_1[0] < MIN_NUM_1[1]) ? 1'b0 : 1'b1;
    assign MIN_NUM = MIN_NUM_1[MIN_INDEX_2];
    assign MIN_INDEX = {MIN_INDEX_2, MIN_INDEX_1[MIN_INDEX_2], MIN_INDEX_0[{MIN_INDEX_2, MIN_INDEX_1[MIN_INDEX_2]}]};
endmodule