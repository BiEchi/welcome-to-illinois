module accelerator (
    input logic CLK,
    input logic RESET,
    input logic START,
    input logic [7:0] SOURCE_INDEX, TARGET_INDEX,
    output logic FINISH,
    output logic [15:0] MIN_PATH_LENGTH,
    output logic [2:0] DEBUG_STATE,
    output logic [6:0] DEBUG_MIN_INDEX,
    output logic [15:0] DEBUG_MIN_NUM
);
    parameter CITY_NUM = 97;
    parameter MAX_NEIGHBOR_NUM = 8;
    // (city_idx, distance)
    parameter [CITY_NUM-1:0][MAX_NEIGHBOR_NUM-1:0][1:0][15:0] dist_list = {
        {{ 16'd28, 16'd89},{ 16'd85, 16'd35},{ 16'd87, 16'd97},{ 16'd89, 16'd45},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd35, 16'd46},{ 16'd94, 16'd32},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd93, 16'd27},{ 16'd95, 16'd32},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd62, 16'd74},{ 16'd91, 16'd44},{ 16'd94, 16'd27},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd91, 16'd59},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd87, 16'd64},{ 16'd92, 16'd59},{ 16'd93, 16'd44},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd87, 16'd58},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd31, 16'd72},{ 16'd96, 16'd45},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd62, 16'd92},{ 16'd87, 16'd46},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd86, 16'd52},{ 16'd88, 16'd46},{ 16'd90, 16'd58},{ 16'd91, 16'd64},{ 16'd96, 16'd97},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd85, 16'd37},{ 16'd87, 16'd52},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd69, 16'd80},{ 16'd84, 16'd36},{ 16'd86, 16'd37},{ 16'd96, 16'd35},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd83, 16'd25},{ 16'd85, 16'd36},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd80, 16'd37},{ 16'd84, 16'd25},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd25, 16'd77},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd25, 16'd54},{ 16'd80, 16'd42},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd72, 16'd81},{ 16'd81, 16'd42},{ 16'd83, 16'd37},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd78, 16'd39},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd43, 16'd41},{ 16'd73, 16'd56},{ 16'd79, 16'd39},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd76, 16'd27},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd59, 16'd45},{ 16'd75,16'd161},{ 16'd77, 16'd27},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd73, 16'd29},{ 16'd76,16'd161},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd52, 16'd84},{ 16'd73, 16'd24},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd72, 16'd51},{ 16'd74, 16'd24},{ 16'd75, 16'd29},{ 16'd78, 16'd56},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd71, 16'd18},{ 16'd73, 16'd51},{ 16'd80, 16'd81},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd69, 16'd24},{ 16'd72, 16'd18},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd69, 16'd49},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd68, 16'd47},{ 16'd70, 16'd49},{ 16'd71, 16'd24},{ 16'd85, 16'd80},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd65, 16'd20},{ 16'd69, 16'd47},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd65, 16'd45},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd65, 16'd21},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd64, 16'd51},{ 16'd66, 16'd21},{ 16'd67, 16'd45},{ 16'd68, 16'd20},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd63, 16'd85},{ 16'd65, 16'd51},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd62, 16'd20},{ 16'd64, 16'd85},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd60, 16'd64},{ 16'd63, 16'd20},{ 16'd88, 16'd92},{ 16'd93, 16'd74},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd60, 16'd33},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd59, 16'd29},{ 16'd61, 16'd33},{ 16'd62, 16'd64},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd58, 16'd20},{ 16'd60, 16'd29},{ 16'd76, 16'd45},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd57, 16'd56},{ 16'd59, 16'd20},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd56, 16'd28},{ 16'd58, 16'd56},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd53, 16'd84},{ 16'd55, 16'd25},{ 16'd57, 16'd28},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd54, 16'd36},{ 16'd56, 16'd25},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd55, 16'd36},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd52, 16'd12},{ 16'd56, 16'd84},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd51, 16'd25},{ 16'd53, 16'd12},{ 16'd74, 16'd84},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd50, 16'd41},{ 16'd52, 16'd25},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd48, 16'd32},{ 16'd51, 16'd41},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd48, 16'd43},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd47, 16'd29},{ 16'd49, 16'd43},{ 16'd50, 16'd32},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd46, 16'd48},{ 16'd48, 16'd29},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd45, 16'd24},{ 16'd47, 16'd48},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd43, 16'd50},{ 16'd46, 16'd24},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd43, 16'd34},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd41, 16'd46},{ 16'd42, 16'd57},{ 16'd44, 16'd34},{ 16'd45, 16'd50},{ 16'd78, 16'd41},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd43, 16'd57},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd40, 16'd96},{ 16'd43, 16'd46},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd25, 16'd26},{ 16'd41, 16'd96},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd25, 16'd36},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd25, 16'd29},{ 16'd37, 16'd39},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd38, 16'd39},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd25, 16'd42},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd20, 16'd74},{ 16'd34, 16'd37},{ 16'd95, 16'd46},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd31, 16'd76},{ 16'd35, 16'd37},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd17, 16'd18},{ 16'd32, 16'd72},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd31, 16'd50},{ 16'd33, 16'd72},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd30, 16'd91},{ 16'd32, 16'd50},{ 16'd34, 16'd76},{ 16'd89, 16'd72},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd21, 16'd45},{ 16'd31, 16'd91},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd28, 16'd52},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd27, 16'd33},{ 16'd29, 16'd52},{ 16'd96, 16'd89},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd22, 16'd59},{ 16'd28, 16'd33},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd22, 16'd61},{ 16'd25, 16'd40},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd24, 16'd37},{ 16'd26, 16'd40},{ 16'd36, 16'd42},{ 16'd38, 16'd29},{ 16'd39, 16'd36},{ 16'd40, 16'd26},{ 16'd81, 16'd54},{ 16'd82, 16'd77}},
        {{ 16'd23, 16'd38},{ 16'd25, 16'd37},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd6, 16'd72},{ 16'd24, 16'd38},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd21, 16'd50},{ 16'd26, 16'd61},{ 16'd27, 16'd59},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd7,16'd107},{ 16'd16, 16'd87},{ 16'd22, 16'd50},{ 16'd30, 16'd45},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd19, 16'd60},{ 16'd35, 16'd74},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd18, 16'd38},{ 16'd20, 16'd60},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd17, 16'd25},{ 16'd19, 16'd38},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd15, 16'd19},{ 16'd18, 16'd25},{ 16'd33, 16'd18},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd10, 16'd26},{ 16'd21, 16'd87},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd1, 16'd65},{ 16'd12, 16'd47},{ 16'd13, 16'd52},{ 16'd14, 16'd48},{ 16'd17, 16'd19},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd15, 16'd48},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd0, 16'd26},{ 16'd15, 16'd52},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd2, 16'd48},{ 16'd11, 16'd18},{ 16'd15, 16'd47},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd10, 16'd28},{ 16'd12, 16'd18},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd9, 16'd64},{ 16'd11, 16'd28},{ 16'd16, 16'd26},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd8, 16'd87},{ 16'd10, 16'd64},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd7, 16'd30},{  16'd9, 16'd87},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd6, 16'd21},{  16'd8, 16'd30},{ 16'd21,16'd107},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd5, 16'd18},{  16'd7, 16'd21},{ 16'd23, 16'd72},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd4, 16'd20},{  16'd6, 16'd18},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd3, 16'd14},{  16'd5, 16'd20},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{  16'd4, 16'd14},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd12, 16'd48},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd15, 16'd65},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}},
        {{ 16'd13, 16'd26},{16'd249,16'd255},{16'd250,16'd255},{16'd251,16'd255},{16'd252,16'd255},{16'd253,16'd255},{16'd254,16'd255},{16'd255,16'd255}}
    };



    enum logic [2:0] {STATE_IDLE, STATE_PREPARE, STATE_GET_MIN_INDEX_1, STATE_GET_MIN_INDEX_2, STATE_UPDATE_MIN_DIST, STATE_FINISH} curr_state, next_state;
    logic [6:0] curr_min_index, next_min_index;
    logic [15:0] curr_min_num, next_min_num;
    logic [127:0][15:0] min_dist;
    logic [127:0] visited;
    logic [127:0][15:0] next_min_dist;
    logic [127:0] next_visited;

    logic [7:0][15:0] adj_index, adj_dist, new_dist;
    logic reg_finish;
    assign FINISH = reg_finish;


    assign DEBUG_STATE = curr_state;
    assign DEBUG_MIN_INDEX = curr_min_index;
    assign DEBUG_MIN_NUM = curr_min_num;


    assign adj_index[0] = dist_list[curr_min_index][0][1];
    assign adj_index[1] = dist_list[curr_min_index][1][1];
    assign adj_index[2] = dist_list[curr_min_index][2][1];
    assign adj_index[3] = dist_list[curr_min_index][3][1];
    assign adj_index[4] = dist_list[curr_min_index][4][1];
    assign adj_index[5] = dist_list[curr_min_index][5][1];
    assign adj_index[6] = dist_list[curr_min_index][6][1];
    assign adj_index[7] = dist_list[curr_min_index][7][1];

    assign adj_dist[0] = dist_list[curr_min_index][0][0];
    assign adj_dist[1] = dist_list[curr_min_index][1][0];
    assign adj_dist[2] = dist_list[curr_min_index][2][0];
    assign adj_dist[3] = dist_list[curr_min_index][3][0];
    assign adj_dist[4] = dist_list[curr_min_index][4][0];
    assign adj_dist[5] = dist_list[curr_min_index][5][0];
    assign adj_dist[6] = dist_list[curr_min_index][6][0];
    assign adj_dist[7] = dist_list[curr_min_index][7][0];


    genvar i;
    generate
        for (i=0;i<8;i++)
        begin:NEW_DIST
            assign new_dist[i] = (adj_index[i] != 16'd255 & curr_min_num + adj_dist[i] < min_dist[adj_index[i]]) ? curr_min_num + adj_dist[i] : min_dist[adj_index[i]];
        end
    endgenerate


    logic [127:0][15:0] min_dist_with_visited;
    generate
        for (i=0;i<128;i++)
        begin: MIN_DIST_WITH_VISITED
            assign min_dist_with_visited[i] = min_dist[i] | {visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i],visited[i]};
        end
    endgenerate

    minimum_finder minimum_finder_inst (.INPUT(min_dist_with_visited), .MIN_INDEX(next_min_index), .MIN_NUM(next_min_num));

    always_ff @ (posedge CLK)
    begin
        if (RESET)
        begin
            curr_state <= STATE_IDLE;
            curr_min_index <= 7'd0;
            curr_min_num <= 16'hffff;
            reg_finish <= 1'b0;
            MIN_PATH_LENGTH <= 16'd0;
            for (int i=0;i<128;i++)
            begin
                min_dist[i] <= 16'hffff;
                visited[i] <= 1'b0;
            end
        end
        else
        begin
            curr_state <= next_state;
            if (curr_state == STATE_FINISH)
            begin
                reg_finish <= 1'b1;
                MIN_PATH_LENGTH <= min_dist[TARGET_INDEX[6:0]];                
            end
            else
            begin
                reg_finish <= 1'b0;
                MIN_PATH_LENGTH <= 16'd0;
            end
            if (curr_state == STATE_GET_MIN_INDEX_2)
            begin
                curr_min_index <= next_min_index;
                curr_min_num <= next_min_num;
            end
            if (curr_state == STATE_PREPARE || curr_state == STATE_UPDATE_MIN_DIST)
            begin
                for (int i=0;i<128;i++)
                begin
                    min_dist[i] <= next_min_dist[i];
                    visited[i] <= next_visited[i];
                end
            end
        end
    end

    always_comb 
    begin
        for (int i=0;i<128;i++)
        begin
            next_min_dist[i] = min_dist[i];
            next_visited[i] = visited[i];
        end
        case (curr_state)
            STATE_IDLE:
            begin
                if (START) next_state = STATE_PREPARE;
                else next_state = STATE_IDLE;
            end
            STATE_PREPARE:
            begin
                next_state = STATE_GET_MIN_INDEX_1;
                for (int i=0;i<128;i++)
                begin
                    next_min_dist[i] = 16'hffff;
                    next_visited[i] = 1'b0;
                end
                next_min_dist[SOURCE_INDEX[6:0]] = 1'd0;
            end
            STATE_GET_MIN_INDEX_1:
                next_state = STATE_GET_MIN_INDEX_2;
            STATE_GET_MIN_INDEX_2:
            begin
                if (next_min_num == 16'hffff)
                    next_state = STATE_FINISH;
                else
                    next_state = STATE_UPDATE_MIN_DIST;
            end
            STATE_UPDATE_MIN_DIST:
            begin
                if (curr_min_index == TARGET_INDEX[6:0])
                    next_state = STATE_FINISH;
                else
                    next_state = STATE_GET_MIN_INDEX_1;
                next_visited[curr_min_index] = 1'b1;
                for (int i=0;i<8;i++)
                begin
                    next_min_dist[adj_index[i]] = new_dist[i];
                end
            end
            STATE_FINISH:
            begin
                if (~START)
                    next_state = STATE_IDLE;
                else
                    next_state = STATE_FINISH;
            end
            default:
                next_state = STATE_FINISH;
        endcase
    end
    
endmodule