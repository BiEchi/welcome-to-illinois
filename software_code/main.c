/*---------------------------------------------------------------------------
  --      main.c                                                    	   --
  --      Christine Chen                                                   --
  --      Ref. DE2-115 Demonstrations by Terasic Technologies Inc.         --
  --      Fall 2014                                                        --
  --                                                                       --
  --      For use with ECE 298 Experiment 7                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>
#include <math.h>
#include "system.h"
#include "alt_types.h"
#include <unistd.h> // usleep
#include "sys/alt_irq.h"
#include <string.h>
#include "io_handler.h"

#include "sys/alt_timestamp.h"

#include "cy7c67200.h"
#include "usb.h"
#include "lcp_cmd.h"
#include "lcp_data.h"


typedef unsigned char uint8;
typedef unsigned int uint32;
#define MAX_NEIGHBOR_NUM 8
const uint32 MAX_UINT32 = (uint32)(-1);
const uint8 MAX_UINT8 = (uint8)(-1);

#define X 100000

#define MAP_LENTH 97
#define EDGE_NUM 112
#define SPEED 0.5
#define SECOND 250000
// #define CLOCKS_PER_SEC 400000000000000.0

volatile unsigned int *path1 = (unsigned int *)0x000000c0; // lower path
volatile unsigned int *path2 = (unsigned int *)0x00000010; // higher path
volatile unsigned int *path3 = (unsigned int *)0x00000120; // third path
volatile unsigned int *path4 = (unsigned int *)0x00000110; // last path

volatile unsigned int *distancehigh = (unsigned int *)0x00000160; //high bit of score
volatile unsigned int *distancelow = (unsigned int *)0x00000150;  //low bit of score

volatile unsigned int *ACCELERATOR_START_PTR = (unsigned int *) 0x000001d0;
volatile unsigned int *ACCELERATOR_SOURCE_INDEX_PTR = (unsigned int *) 0x000001c0;
volatile unsigned int *ACCELERATOR_TARGET_INDEX_PTR = (unsigned int *) 0x000001b0;
volatile unsigned int *ACCELERATOR_FINISH_PTR = (unsigned int *) 0x000001a0;
volatile unsigned int *ACCELERATOR_MIN_PATH_LENGTH_PTR = (unsigned int *) 0x00000190;
volatile unsigned int *ACCELERATOR_DEBUG_STATE = (unsigned int *) 0x00000180;
volatile unsigned int *ACCELERATOR_DEBUG_MIN_INDEX = (unsigned int *) 0x00000170;
volatile unsigned int *ACCELERATOR_DEBUG_MIN_NUM = (unsigned int *) 0x00000140;


int path_save_1, path_save_2, path_save_3, path_save_4;
int have_found = 0;

const uint8 dist_list[MAP_LENTH][MAX_NEIGHBOR_NUM][2] = {
	{{13, 26}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{15, 65}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{12, 48}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{4, 14}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{3, 14}, {5, 20}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{4, 20}, {6, 18}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{5, 18}, {7, 21}, {23, 72}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{6, 21}, {8, 30}, {21, 107}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{7, 30}, {9, 87}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{8, 87}, {10, 64}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{9, 64}, {11, 28}, {16, 26}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{10, 28}, {12, 18}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{2, 48}, {11, 18}, {15, 47}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{0, 26}, {15, 52}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{15, 48}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{1, 65}, {12, 47}, {13, 52}, {14, 48}, {17, 19}, {253, 255}, {254, 255}, {255, 255}},
	{{10, 26}, {21, 87}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{15, 19}, {18, 25}, {33, 18}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{17, 25}, {19, 38}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{18, 38}, {20, 60}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{19, 60}, {35, 74}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{7, 107}, {16, 87}, {22, 50}, {30, 45}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{21, 50}, {26, 61}, {27, 59}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{6, 72}, {24, 38}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{23, 38}, {25, 37}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{24, 37}, {26, 40}, {36, 42}, {38, 29}, {39, 36}, {40, 26}, {81, 54}, {82, 77}},
	{{22, 61}, {25, 40}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{22, 59}, {28, 33}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{27, 33}, {29, 52}, {96, 89}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{28, 52}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{21, 45}, {31, 91}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{30, 91}, {32, 50}, {34, 76}, {89, 72}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{31, 50}, {33, 72}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{17, 18}, {32, 72}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{31, 76}, {35, 37}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{20, 74}, {34, 37}, {95, 46}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{25, 42}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{38, 39}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{25, 29}, {37, 39}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{25, 36}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{25, 26}, {41, 96}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{40, 96}, {43, 46}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{43, 57}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{41, 46}, {42, 57}, {44, 34}, {45, 50}, {78, 41}, {253, 255}, {254, 255}, {255, 255}},
	{{43, 34}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{43, 50}, {46, 24}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{45, 24}, {47, 48}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{46, 48}, {48, 29}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{47, 29}, {49, 43}, {50, 32}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{48, 43}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{48, 32}, {51, 41}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{50, 41}, {52, 25}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{51, 25}, {53, 12}, {74, 84}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{52, 12}, {56, 84}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{55, 36}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{54, 36}, {56, 25}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{53, 84}, {55, 25}, {57, 28}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{56, 28}, {58, 56}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{57, 56}, {59, 20}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{58, 20}, {60, 29}, {76, 45}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{59, 29}, {61, 33}, {62, 64}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{60, 33}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{60, 64}, {63, 20}, {88, 92}, {93, 74}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{62, 20}, {64, 85}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{63, 85}, {65, 51}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{64, 51}, {66, 21}, {67, 45}, {68, 20}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{65, 21}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{65, 45}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{65, 20}, {69, 47}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{68, 47}, {70, 49}, {71, 24}, {85, 80}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{69, 49}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{69, 24}, {72, 18}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{71, 18}, {73, 51}, {80, 81}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{72, 51}, {74, 24}, {75, 29}, {78, 56}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{52, 84}, {73, 24}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{73, 29}, {76, 161}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{59, 45}, {75, 161}, {77, 27}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{76, 27}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{43, 41}, {73, 56}, {79, 39}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{78, 39}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{72, 81}, {81, 42}, {83, 37}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{25, 54}, {80, 42}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{25, 77}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{80, 37}, {84, 25}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{83, 25}, {85, 36}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{69, 80}, {84, 36}, {86, 37}, {96, 35}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{85, 37}, {87, 52}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{86, 52}, {88, 46}, {90, 58}, {91, 64}, {96, 97}, {253, 255}, {254, 255}, {255, 255}},
	{{62, 92}, {87, 46}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{31, 72}, {96, 45}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{87, 58}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{87, 64}, {92, 59}, {93, 44}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{91, 59}, {249, 255}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{62, 74}, {91, 44}, {94, 27}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{93, 27}, {95, 32}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{35, 46}, {94, 32}, {250, 255}, {251, 255}, {252, 255}, {253, 255}, {254, 255}, {255, 255}},
	{{28, 89}, {85, 35}, {87, 97}, {89, 45}, {252, 255}, {253, 255}, {254, 255}, {255, 255}}};

const int edges[112] = {
	{0, 13},
	{1, 15},
	{2, 12},
	{3, 4},
	{4, 5},
	{5, 6},
	{6, 7},
	{6, 23},
	{7, 8},
	{7, 21},
	{8, 9},
	{9, 10},
	{10, 11},
	{10, 16},
	{11, 12},
	{12, 15},
	{13, 15},
	{14, 15},
	{15, 17},
	{16, 21},
	{17, 18},
	{17, 33},
	{18, 19},
	{19, 20},
	{20, 35},
	{21, 22},
	{21, 30},
	{22, 26},
	{22, 27},
	{23, 24},
	{24, 25},
	{25, 26},
	{25, 36},
	{25, 38},
	{25, 39},
	{25, 40},
	{25, 81},
	{25, 82},
	{27, 28},
	{28, 29},
	{28, 96},
	{30, 31},
	{31, 32},
	{31, 34},
	{31, 89},
	{32, 33},
	{34, 35},
	{35, 95},
	{37, 38},
	{40, 41},
	{41, 43},
	{42, 43},
	{43, 44},
	{43, 45},
	{43, 78},
	{45, 46},
	{46, 47},
	{47, 48},
	{48, 49},
	{48, 50},
	{50, 51},
	{51, 52},
	{52, 53},
	{52, 74},
	{53, 56},
	{54, 55},
	{55, 56},
	{56, 57},
	{57, 58},
	{58, 59},
	{59, 60},
	{59, 76},
	{60, 61},
	{60, 62},
	{62, 63},
	{62, 88},
	{62, 93},
	{63, 64},
	{64, 65},
	{65, 66},
	{65, 67},
	{65, 68},
	{68, 69},
	{69, 70},
	{69, 71},
	{69, 85},
	{71, 72},
	{72, 73},
	{72, 80},
	{73, 74},
	{73, 75},
	{73, 78},
	{75, 76},
	{76, 77},
	{78, 79},
	{80, 80},
	{80, 81},
	{80, 83},
	{83, 84},
	{84, 85},
	{85, 86},
	{85, 96},
	{86, 87},
	{87, 88},
	{87, 90},
	{87, 91},
	{87, 96},
	{89, 96},
	{91, 92},
	{91, 93},
	{93, 94},
	{94, 95}};

float dis[MAP_LENTH][2] = {
	{24, 128},
	{45, 168},
	{51, 216},
	{72, 440},
	{83, 430},
	{95, 414},
	{112, 406},
	{96, 392},
	{72, 373},
	{85, 286},
	{86, 222},
	{85, 194},
	{79, 176},
	{50, 127},
	{105, 87},
	{102, 135},
	{111, 232},
	{121, 139},
	{142, 124},
	{180, 117},
	{240, 112},
	{159, 305},
	{173, 354},
	{184, 405},
	{222, 405},
	{259, 406},
	{230, 378},
	{225, 325},
	{252, 306},
	{253, 254},
	{188, 270},
	{245, 198},
	{209, 163},
	{138, 147},
	{299, 144},
	{314, 110},
	{248, 447},
	{214, 458},
	{239, 428},
	{282, 434},
	{284, 416},
	{380, 421},
	{377, 449},
	{426, 419},
	{422, 453},
	{476, 419},
	{500, 418},
	{548, 416},
	{577, 416},
	{620, 414},
	{582, 384},
	{588, 343},
	{586, 318},
	{591, 307},
	{544, 274},
	{570, 249},
	{577, 224},
	{576, 196},
	{568, 140},
	{561, 121},
	{557, 92},
	{590, 95},
	{493, 97},
	{490, 117},
	{471, 200},
	{455, 249},
	{476, 247},
	{410, 247},
	{449, 269},
	{443, 316},
	{394, 318},
	{435, 339},
	{430, 357},
	{480, 343},
	{504, 339},
	{493, 316},
	{547, 164},
	{520, 165},
	{461, 396},
	{497, 381},
	{352, 380},
	{311, 391},
	{314, 351},
	{351, 343},
	{357, 318},
	{369, 284},
	{378, 248},
	{400, 200},
	{431, 166},
	{304, 240},
	{342, 206},
	{389, 136},
	{339, 168},
	{419, 103},
	{392, 104},
	{360, 108},
	{335, 273},
};

//---------------------------------------------------------------------------//

int strtoint(char *a);

int find_line(int point1, int point2)
{
	int data[2 * EDGE_NUM][3] = {
		{0, 13, 0},
		{13, 0, 0},
		{1, 15, 1},
		{15, 1, 1},
		{2, 12, 2},
		{12, 2, 2},
		{3, 4, 3},
		{4, 3, 3},
		{4, 5, 4},
		{5, 4, 4},
		{5, 6, 5},
		{6, 5, 5},
		{6, 7, 6},
		{7, 6, 6},
		{6, 23, 7},
		{23, 6, 7},
		{7, 8, 8},
		{8, 7, 8},
		{7, 21, 9},
		{21, 7, 9},
		{8, 9, 10},
		{9, 8, 10},
		{9, 10, 11},
		{10, 9, 11},
		{10, 11, 12},
		{11, 10, 12},
		{10, 16, 13},
		{16, 10, 13},
		{11, 12, 14},
		{12, 11, 14},
		{12, 15, 15},
		{15, 12, 15},
		{13, 15, 16},
		{15, 13, 16},
		{14, 15, 17},
		{15, 14, 17},
		{15, 17, 18},
		{17, 15, 18},
		{16, 21, 19},
		{21, 16, 19},
		{17, 18, 20},
		{18, 17, 20},
		{17, 33, 21},
		{33, 17, 21},
		{18, 19, 22},
		{19, 18, 22},
		{19, 20, 23},
		{20, 19, 23},
		{20, 35, 24},
		{35, 20, 24},
		{21, 22, 25},
		{22, 21, 25},
		{21, 30, 26},
		{30, 21, 26},
		{22, 26, 27},
		{26, 22, 27},
		{22, 27, 28},
		{27, 22, 28},
		{23, 24, 29},
		{24, 23, 29},
		{24, 25, 30},
		{25, 24, 30},
		{25, 26, 31},
		{26, 25, 31},
		{25, 36, 32},
		{36, 25, 32},
		{25, 38, 33},
		{38, 25, 33},
		{25, 39, 34},
		{39, 25, 34},
		{25, 40, 35},
		{40, 25, 35},
		{25, 81, 36},
		{81, 25, 36},
		{25, 82, 37},
		{82, 25, 37},
		{27, 28, 38},
		{28, 27, 38},
		{28, 29, 39},
		{29, 28, 39},
		{28, 96, 40},
		{96, 28, 40},
		{30, 31, 41},
		{31, 30, 41},
		{31, 32, 42},
		{32, 31, 42},
		{31, 34, 43},
		{34, 31, 43},
		{31, 89, 44},
		{89, 31, 44},
		{32, 33, 45},
		{33, 32, 45},
		{34, 35, 46},
		{35, 34, 46},
		{35, 95, 47},
		{95, 35, 47},
		{37, 38, 48},
		{38, 37, 48},
		{40, 41, 49},
		{41, 40, 49},
		{41, 43, 50},
		{43, 41, 50},
		{42, 43, 51},
		{43, 42, 51},
		{43, 44, 52},
		{44, 43, 52},
		{43, 45, 53},
		{45, 43, 53},
		{43, 78, 54},
		{78, 43, 54},
		{45, 46, 55},
		{46, 45, 55},
		{46, 47, 56},
		{47, 46, 56},
		{47, 48, 57},
		{48, 47, 57},
		{48, 49, 58},
		{49, 48, 58},
		{48, 50, 59},
		{50, 48, 59},
		{50, 51, 60},
		{51, 50, 60},
		{51, 52, 61},
		{52, 51, 61},
		{52, 53, 62},
		{53, 52, 62},
		{52, 74, 63},
		{74, 52, 63},
		{53, 56, 64},
		{56, 53, 64},
		{54, 55, 65},
		{55, 54, 65},
		{55, 56, 66},
		{56, 55, 66},
		{56, 57, 67},
		{57, 56, 67},
		{57, 58, 68},
		{58, 57, 68},
		{58, 59, 69},
		{59, 58, 69},
		{59, 60, 70},
		{60, 59, 70},
		{59, 76, 71},
		{76, 59, 71},
		{60, 61, 72},
		{61, 60, 72},
		{60, 62, 73},
		{62, 60, 73},
		{62, 63, 74},
		{63, 62, 74},
		{62, 88, 75},
		{88, 62, 75},
		{62, 93, 76},
		{93, 62, 76},
		{63, 64, 77},
		{64, 63, 77},
		{64, 65, 78},
		{65, 64, 78},
		{65, 66, 79},
		{66, 65, 79},
		{65, 67, 80},
		{67, 65, 80},
		{65, 68, 81},
		{68, 65, 81},
		{68, 69, 82},
		{69, 68, 82},
		{69, 70, 83},
		{70, 69, 83},
		{69, 71, 84},
		{71, 69, 84},
		{69, 85, 85},
		{85, 69, 85},
		{71, 72, 86},
		{72, 71, 86},
		{72, 73, 87},
		{73, 72, 87},
		{72, 80, 88},
		{80, 72, 88},
		{73, 74, 89},
		{74, 73, 89},
		{73, 75, 90},
		{75, 73, 90},
		{73, 78, 91},
		{78, 73, 91},
		{75, 76, 92},
		{76, 75, 92},
		{76, 77, 93},
		{77, 76, 93},
		{78, 79, 94},
		{79, 78, 94},
		{80, 80, 95},
		{80, 80, 95},
		{80, 81, 96},
		{81, 80, 96},
		{80, 83, 97},
		{83, 80, 97},
		{83, 84, 98},
		{84, 83, 98},
		{84, 85, 99},
		{85, 84, 99},
		{85, 86, 100},
		{86, 85, 100},
		{85, 96, 101},
		{96, 85, 101},
		{86, 87, 102},
		{87, 86, 102},
		{87, 88, 103},
		{88, 87, 103},
		{87, 90, 104},
		{90, 87, 104},
		{87, 91, 105},
		{91, 87, 105},
		{87, 96, 106},
		{96, 87, 106},
		{89, 96, 107},
		{96, 89, 107},
		{91, 92, 108},
		{92, 91, 108},
		{91, 93, 109},
		{93, 91, 109},
		{93, 94, 110},
		{94, 93, 110},
		{94, 95, 111},
		{95, 94, 111},
	};
	int linenum;

	for (int i = 0; i < 2 * EDGE_NUM; i++)
	{
		if (point1 == data[i][0] && point2 == data[i][1])
		{
			linenum = data[i][2];
		}
	}
	return linenum;
}

void display_path(uint8 *path, uint8 path_num, uint32 path_length, int *p1, int *p2, int *p3, int *p4)
{
	*p1 = 0b00000000000000000000000000000000;
	*p2 = 0b00000000000000000000000000000000;
	*p3 = 0b00000000000000000000000000000000;
	*p4 = 0b00000000000000000000000000000000;

	for (uint8 i = 0; i < path_num - 1; i++)
	{
		int point1 = path[i];
		int point2 = path[i + 1];
		int line = find_line(point1, point2);
		if (line < 32) // 0-31
		{
			*p1 += (unsigned int)(pow(2, line) + 0.01);
		}
		else if (line < 2 * 32) // 32-63
		{
			*p2 += (unsigned int)(pow(2, line - 32) + 0.01);
		}
		else if (line < 3 * 32) // 64-95
		{
			*p3 += (unsigned int)(pow(2, line - 64) + 0.01);
		}
		else // 96-127 (we have only 112 edges, so should be sufficient)
		{
			*p4 += (unsigned int)(pow(2, line - 96) + 0.01);
		}

		usleep(0.5 * SECOND); // the time to sleep. 250000 is 1s
	}

	path_save_1 = *p1;
	path_save_2 = *p2;
	path_save_3 = *p3;
	path_save_4 = *p4;
}

void find_shortest_path_software(uint8 s, uint8 t, uint32 *min_dist) {
	uint8 visited[MAP_LENTH];
	for (uint8 i = 0; i < MAP_LENTH; i++)
	{
		min_dist[i] = MAX_UINT32;
		visited[i] = 0;
	}

	min_dist[s] = 0;
	for (uint8 t = 0; t < MAP_LENTH; t++)
	{
		uint8 min_idx = MAX_UINT8;
		uint32 min_d = MAX_UINT32;
		for (uint8 u = 0; u < MAP_LENTH; u++)
			if (min_dist[u] < min_d && visited[u] == 0)
			{
				min_d = min_dist[u];
				min_idx = u;
			}
		if (min_idx == MAX_UINT8 || min_d == MAX_UINT32 || min_idx == t)
			break;
		visited[min_idx] = 1;
		for (uint8 k = 0; k < MAX_NEIGHBOR_NUM; k++)
			if (dist_list[min_idx][k][1] != MAX_UINT8 && min_d + dist_list[min_idx][k][1] < min_dist[dist_list[min_idx][k][0]])
			{
				min_dist[dist_list[min_idx][k][0]] = min_d + dist_list[min_idx][k][1];
			}
	}
}

void find_shortest_path(uint8 s, uint8 t, uint8 *path, uint8 *path_num, uint32 *path_min, int* dis1, int*dis2)
{
	uint32 min_dist[MAP_LENTH];
	uint8 visited[MAP_LENTH];
	int distance = 0;

	for (uint8 i = 0; i < MAP_LENTH; i++)
	{
		min_dist[i] = MAX_UINT32;
		visited[i] = 0;
	}

	min_dist[s] = 0;
	for (uint8 t = 0; t < MAP_LENTH; t++)
	{
		uint8 min_idx = MAX_UINT8;
		uint32 min_d = MAX_UINT32;
		for (uint8 u = 0; u < MAP_LENTH; u++)
			if (min_dist[u] < min_d && visited[u] == 0)
			{
				min_d = min_dist[u];
				min_idx = u;
			}
		if (min_idx == MAX_UINT8 || min_d == MAX_UINT32)
			break;
		visited[min_idx] = 1;
		for (uint8 k = 0; k < MAX_NEIGHBOR_NUM; k++)
			if (dist_list[min_idx][k][1] != MAX_UINT8 && min_d + dist_list[min_idx][k][1] < min_dist[dist_list[min_idx][k][0]])
			{
				min_dist[dist_list[min_idx][k][0]] = min_d + dist_list[min_idx][k][1];
			}
	}

	if (min_dist[t] != MAX_UINT32)
	{
		uint8 u = t;
		*path_num = 0;
		while (1)
		{
			path[*path_num] = u;
			*path_num += 1;
			if (u == s)
				break;
			for (uint8 k = 0; k < MAX_NEIGHBOR_NUM; k++)
				if (min_dist[dist_list[u][k][0]] + dist_list[u][k][1] == min_dist[u])
				{
					u = dist_list[u][k][0];
					break;
				}
		}
		*path_min = min_dist[t];
	}
	else
	{
		*path_num = MAX_UINT8;
		*path_min = MAX_UINT32;
	}

	int scale_parameter = 6;
	distance = scale_parameter * (*path_min); // use a scale of 6

	// export the distance information to the hardware for display
	distance = (int) (distance / 60);
	*dis1 = (int) (distance / 10);
	*dis2 = distance % 10;
	// printf("dis1=%d, dis2=%d.\n", *dis1, *dis2);
}

uint32 find_shortest_path_accelerator(uint8 START, uint8 END) {
	*ACCELERATOR_START_PTR = 0x0;
	*ACCELERATOR_SOURCE_INDEX_PTR = START;
	*ACCELERATOR_TARGET_INDEX_PTR = END;
	*ACCELERATOR_START_PTR = 0x1;
	while(*ACCELERATOR_FINISH_PTR & 1 == 0) {}
	usleep(1);
	return *ACCELERATOR_MIN_PATH_LENGTH_PTR;
}

void find_and_display(int START, int END)
{
	uint8 path[MAP_LENTH];
	uint8 path_num;
	uint32 path_min;

	alt_timestamp_start();
	alt_u32 t0 = alt_timestamp();
	uint32 path_min_from_accelerator = find_shortest_path_accelerator(START, END);
	alt_u32 t1 = alt_timestamp();
	double time_spent_accelerator = (double)(t1-t0)/(double)alt_timestamp_freq();

	alt_timestamp_start();
	t0 = alt_timestamp();
	find_shortest_path((uint8)START, (uint8)END, path, &path_num, &path_min, distancehigh, distancelow);
	t1 = alt_timestamp();
	double time_spent_software = (double)(t1-t0)/(double)alt_timestamp_freq();

	printf("result from software:    %dkm\n", path_min/10);
	printf("result from accelerator: %dkm\n", path_min_from_accelerator/10);
	printf("software time:           %.5lfs\n", time_spent_software);
	printf("accelerator time:        %.5lfs\n", time_spent_accelerator);

	have_found = 1;
	display_path(path, path_num, path_min, path1, path2, path3, path4);
}

void benchmark(double *time_for_software, double *time_for_accelerator, int *cnt1, int *cnt2) {
	uint32 min_dist[MAP_LENTH];
	cnt1 = 0;
	cnt2 = 0;
	printf("====Start Benchmark====\n");
	printf("Software:    ");
	for (uint8 s=0; s<MAP_LENTH; s+=40) {
		printf("%d ", s);
		for (uint8 t=s+1; t<MAP_LENTH; t++) {
			alt_timestamp_start();
			alt_u32 t0 = alt_timestamp();
			find_shortest_path_software(t, s, min_dist);
			alt_u32 t1 = alt_timestamp();
			*time_for_software += (double)(t1-t0)/(double)alt_timestamp_freq();
			cnt1 += 1;
		}
	}
	printf(" total paths: %d\n", cnt1);

	printf("Accelerator: ");
	for (uint8 s=0; s<MAP_LENTH; s+=40) {
		printf("%d ", s);
		for (uint8 t=s+1; t<MAP_LENTH; t++) {
			alt_timestamp_start();
			alt_u32 t0 = alt_timestamp();
			find_shortest_path_accelerator(t, s);
			alt_u32 t1 = alt_timestamp();
			*time_for_accelerator += (double)(t1-t0)/(double)alt_timestamp_freq();
			*time_for_accelerator -= 0.000004;
			cnt2 += 1;
		}
	}
	printf(" total paths: %d\n", cnt2);
}
//---------------------------------------------------------------------------//
//----------------------------------------------------------------------------------------//
//
//                                Main function
//
//----------------------------------------------------------------------------------------//
int main(void)
{
	IO_init();

	alt_u16 intStat;
	alt_u16 usb_ctl_val;
	static alt_u16 ctl_reg = 0;
	static alt_u16 no_device = 0;
	alt_u16 fs_device = 0;
	int keycode = 0;
	alt_u8 toggle = 0;
	alt_u8 data_size;
	alt_u8 hot_plug_count;
	alt_u16 code;

	volatile unsigned int *pos_x = (unsigned int *)0x000000e0; //input x position
	volatile unsigned int *pos_y = (unsigned int *)0x000000d0; //input y position

	volatile unsigned int *beginpoint = (unsigned int *)0x00000100; //input x position
	volatile unsigned int *endpoint = (unsigned int *)0x000000f0;	//input y position

	*path1 = (unsigned int)0b00000000000000000000000000000000;
	*path2 = (unsigned int)0b00000000000000000000000000000000;
	*path3 = (unsigned int)0b00000000000000000000000000000000;
	*path4 = (unsigned int)0b00000000000000000000000000000000;

	*beginpoint = (unsigned int)0;
	*endpoint = (unsigned int)0;

	*distancehigh = (unsigned int)0;
	*distancelow = (unsigned int)0;

	int situation;
	int START;
	int END;
	int v = 0;
	char a[5];
	char b[5];
	printf("Please select a mode: (1)use console to enter. (2)use keyboard to enter. (3)benchmark.\n");
	scanf("%d", &situation);
	if (situation == 1)
	{
		printf("You're now in the console mode\n");
		while (1)
		{
			int mode;
			if (v != 0)
			{
				printf("Do you want to use again? press(1)-yes, press(2)-no\n");
				scanf("%d", &mode);
				*distancehigh = 0;
				*distancelow = 0;
			}
			v = 1;
			if (mode == 2)
			{
				printf("Thanks for your use!\n");
				while (1)
				{
				}
			}
			*path1 = (unsigned int)0b00000000000000000000000000000000;
			*path2 = (unsigned int)0b00000000000000000000000000000000;
			*path3 = (unsigned int)0b00000000000000000000000000000000;
			*path4 = (unsigned int)0b00000000000000000000000000000000;
			int y = 1;
			while (y == 1)
			{
				while (1)
				{
					if (have_found)
					{
						*path1 = path_save_1;
						*path2 = path_save_2;
						*path3 = path_save_3;
						*path4 = path_save_4;
					}
					printf("please enter the start point\n");
					scanf("%s", a);
					have_found = 0;
					END = strtoint(a);
					printf("The start point is %d\n", END);
					if (END != -1)
					{
						break;
					}
					printf("INPUT WRONG!! AGAIN!!\n");
				}
				while (1)
				{
					if (have_found)
					{
						*path1 = path_save_1;
						*path2 = path_save_2;
						*path3 = path_save_3;
						*path4 = path_save_4;
					}
					printf("please enter the end point\n");
					scanf("%s", b);
					have_found = 0;
					START = strtoint(b);
					printf("The end point is %d\n", START);
					if (START != -1)
					{
						break;
					}
					printf("INPUT WRONG!! AGAIN!!\n");
				}
				if (END == START)
				{
					printf("Please enter different place\n");
					continue;
				}
				y = 0;
			}

			// deliver the message to hardware for processing path
			*endpoint = END + 1;
			*beginpoint = START + 1;
			find_and_display(START, END);
			have_found = 1;
		}
	}

	// keyboard solution
	if (situation == 2)
	{
		printf("USB keyboard setup...\n\n");

	//----------------------------------------SIE1 initial---------------------------------------------------//
	USB_HOT_PLUG1:
		UsbSoftReset();

		// STEP 1a:
		UsbWrite(HPI_SIE1_MSG_ADR, 0);
		UsbWrite(HOST1_STAT_REG, 0xFFFF);

		/* Set HUSB_pEOT time */
		UsbWrite(HUSB_pEOT, 600); // adjust the according to your USB device speed

		usb_ctl_val = SOFEOP1_TO_CPU_EN | RESUME1_TO_HPI_EN; // | SOFEOP1_TO_HPI_EN;
		UsbWrite(HPI_IRQ_ROUTING_REG, usb_ctl_val);

		intStat = A_CHG_IRQ_EN | SOF_EOP_IRQ_EN;
		UsbWrite(HOST1_IRQ_EN_REG, intStat);
		// STEP 1a end

		// STEP 1b begin
		UsbWrite(COMM_R0, 0x0000);					//reset time
		UsbWrite(COMM_R1, 0x0000);					//port number
		UsbWrite(COMM_R2, 0x0000);					//r1
		UsbWrite(COMM_R3, 0x0000);					//r1
		UsbWrite(COMM_R4, 0x0000);					//r1
		UsbWrite(COMM_R5, 0x0000);					//r1
		UsbWrite(COMM_R6, 0x0000);					//r1
		UsbWrite(COMM_R7, 0x0000);					//r1
		UsbWrite(COMM_R8, 0x0000);					//r1
		UsbWrite(COMM_R9, 0x0000);					//r1
		UsbWrite(COMM_R10, 0x0000);					//r1
		UsbWrite(COMM_R11, 0x0000);					//r1
		UsbWrite(COMM_R12, 0x0000);					//r1
		UsbWrite(COMM_R13, 0x0000);					//r1
		UsbWrite(COMM_INT_NUM, HUSB_SIE1_INIT_INT); //HUSB_SIE1_INIT_INT
		IO_write(HPI_MAILBOX, COMM_EXEC_INT);

		while (!(IO_read(HPI_STATUS) & 0xFFFF)) //read sie1 msg register
		{
		}
		while (IO_read(HPI_MAILBOX) != COMM_ACK)
		{
			printf("[ERROR]:routine mailbox data is %x\n", IO_read(HPI_MAILBOX));
			goto USB_HOT_PLUG1;
		}
		// STEP 1b end

		//printf("STEP 1 Complete");
		// STEP 2 begin
		UsbWrite(COMM_INT_NUM, HUSB_RESET_INT); //husb reset
		UsbWrite(COMM_R0, 0x003c);				//reset time
		UsbWrite(COMM_R1, 0x0000);				//port number
		UsbWrite(COMM_R2, 0x0000);				//r1
		UsbWrite(COMM_R3, 0x0000);				//r1
		UsbWrite(COMM_R4, 0x0000);				//r1
		UsbWrite(COMM_R5, 0x0000);				//r1
		UsbWrite(COMM_R6, 0x0000);				//r1
		UsbWrite(COMM_R7, 0x0000);				//r1
		UsbWrite(COMM_R8, 0x0000);				//r1
		UsbWrite(COMM_R9, 0x0000);				//r1
		UsbWrite(COMM_R10, 0x0000);				//r1
		UsbWrite(COMM_R11, 0x0000);				//r1
		UsbWrite(COMM_R12, 0x0000);				//r1
		UsbWrite(COMM_R13, 0x0000);				//r1

		IO_write(HPI_MAILBOX, COMM_EXEC_INT);

		while (IO_read(HPI_MAILBOX) != COMM_ACK)
		{
			printf("[ERROR]:routine mailbox data is %x\n", IO_read(HPI_MAILBOX));
			goto USB_HOT_PLUG1;
		}
		// STEP 2 end

		ctl_reg = USB1_CTL_REG;
		no_device = (A_DP_STAT | A_DM_STAT);
		fs_device = A_DP_STAT;
		usb_ctl_val = UsbRead(ctl_reg);

		if (!(usb_ctl_val & no_device))
		{
			for (hot_plug_count = 0; hot_plug_count < 5; hot_plug_count++)
			{
				usleep(5 * 1000);
				usb_ctl_val = UsbRead(ctl_reg);
				if (usb_ctl_val & no_device)
					break;
			}
			if (!(usb_ctl_val & no_device))
			{
				printf("\n[INFO]: no device is present in SIE1!\n");
				printf("[INFO]: please insert a USB keyboard in SIE1!\n");
				while (!(usb_ctl_val & no_device))
				{
					usb_ctl_val = UsbRead(ctl_reg);
					if (usb_ctl_val & no_device)
						goto USB_HOT_PLUG1;

					usleep(2000);
				}
			}
		}
		else
		{
			/* check for low speed or full speed by reading D+ and D- lines */
			if (usb_ctl_val & fs_device)
			{
				printf("[INFO]: full speed device\n");
			}
			else
			{
				printf("[INFO]: low speed device\n");
			}
		}

		// STEP 3 begin
		//------------------------------------------------------set address -----------------------------------------------------------------
		UsbSetAddress();

		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			UsbSetAddress();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506); // i
		printf("[ENUM PROCESS]:step 3 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508); // n
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 3 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03) // retries occurred
		{
			usb_ctl_val = UsbGetRetryCnt();

			goto USB_HOT_PLUG1;
		}

		printf("------------[ENUM PROCESS]:set address done!---------------\n");

		// STEP 4 begin
		//-------------------------------get device descriptor-1 -----------------------------------//
		// TASK: Call the appropriate function for this step.
		UsbGetDeviceDesc1(); // Get Device Descriptor -1
		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbGetDeviceDesc1();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]:step 4 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 4 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();

			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}

		//printf("---------------[ENUM PROCESS]:get device descriptor-1 done!-----------------\n");

		//--------------------------------get device descriptor-2---------------------------------------------//
		//get device descriptor
		// TASK: Call the appropriate function for this step.
		UsbGetDeviceDesc2(); // Get Device Descriptor -2

		//if no message
		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			//resend the get device descriptor
			//get device descriptor
			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbGetDeviceDesc2();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]:step 4 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 4 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();

			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}

		printf("------------[ENUM PROCESS]:get device descriptor-2 done!--------------\n");

		// STEP 5 begin
		//-----------------------------------get configuration descriptor -1 ----------------------------------//
		// TASK: Call the appropriate function for this step.
		UsbGetConfigDesc1(); // Get Configuration Descriptor -1

		//if no message
		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			//resend the get device descriptor
			//get device descriptor

			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbGetConfigDesc1();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]:step 5 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 5 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();

			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}
		printf("------------[ENUM PROCESS]:get configuration descriptor-1 pass------------\n");

		// STEP 6 begin
		//-----------------------------------get configuration descriptor-2------------------------------------//
		//get device descriptor
		// TASK: Call the appropriate function for this step.
		UsbGetConfigDesc2(); // Get Configuration Descriptor -2

		usleep(100 * 1000);
		//if no message
		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbGetConfigDesc2();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]:step 6 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 6 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();

			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}

		printf("-----------[ENUM PROCESS]:get configuration descriptor-2 done!------------\n");

		// ---------------------------------get device info---------------------------------------------//

		// TASK: Write the address to read from the memory for byte 7 of the interface descriptor to HPI_ADDR.
		IO_write(HPI_ADDR, 0x056c);
		code = IO_read(HPI_DATA);
		code = code & 0x003;
		printf("\ncode = %x\n", code);

		if (code == 0x01)
		{
			printf("\n[INFO]:check TD rec data7 \n[INFO]:Keyboard Detected!!!\n\n");
		}
		else
		{
			printf("\n[INFO]:Keyboard Not Detected!!! \n\n");
		}

		// TASK: Write the address to read from the memory for the endpoint descriptor to HPI_ADDR.

		IO_write(HPI_ADDR, 0x0576);
		IO_write(HPI_DATA, 0x073F);
		IO_write(HPI_DATA, 0x8105);
		IO_write(HPI_DATA, 0x0003);
		IO_write(HPI_DATA, 0x0008);
		IO_write(HPI_DATA, 0xAC0A);
		UsbWrite(HUSB_SIE1_pCurrentTDPtr, 0x0576); //HUSB_SIE1_pCurrentTDPtr

		//data_size = (IO_read(HPI_DATA)>>8)&0x0ff;
		//data_size = 0x08;//(IO_read(HPI_DATA))&0x0ff;
		//UsbPrintMem();
		IO_write(HPI_ADDR, 0x057c);
		data_size = (IO_read(HPI_DATA)) & 0x0ff;
		printf("[ENUM PROCESS]:data packet size is %d\n", data_size);
		// STEP 7 begin
		//------------------------------------set configuration -----------------------------------------//
		// TASK: Call the appropriate function for this step.
		UsbSetConfig(); // Set Configuration

		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbSetConfig(); // Set Configuration
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]:step 7 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 7 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();

			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}

		printf("------------[ENUM PROCESS]:set configuration done!-------------------\n");

		//----------------------------------------------class request out ------------------------------------------//
		// TASK: Call the appropriate function for this step.
		UsbClassRequest();

		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbClassRequest();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]:step 8 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 8 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();

			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}

		printf("------------[ENUM PROCESS]:class request out done!-------------------\n");

		// STEP 8 begin
		//----------------------------------get descriptor(class 0x21 = HID) request out --------------------------------//
		// TASK: Call the appropriate function for this step.
		UsbGetHidDesc();

		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbGetHidDesc();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]:step 8 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]:step 8 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();
			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}

		printf("------------[ENUM PROCESS]:get descriptor (class 0x21) done!-------------------\n");

		// STEP 9 begin
		//-------------------------------get descriptor (class 0x22 = report)-------------------------------------------//
		// TASK: Call the appropriate function for this step.
		UsbGetReportDesc();
		//if no message
		while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
		{
			// TASK: Call the appropriate function again if it wasn't processed successfully.
			UsbGetReportDesc();
			usleep(10 * 1000);
		}

		UsbWaitTDListDone();

		IO_write(HPI_ADDR, 0x0506);
		printf("[ENUM PROCESS]: step 9 TD Status Byte is %x\n", IO_read(HPI_DATA));

		IO_write(HPI_ADDR, 0x0508);
		usb_ctl_val = IO_read(HPI_DATA);
		printf("[ENUM PROCESS]: step 9 TD Control Byte is %x\n", usb_ctl_val);
		while (usb_ctl_val != 0x03)
		{
			usb_ctl_val = UsbGetRetryCnt();
			printf("Encountered Fatal Error");
			goto USB_HOT_PLUG1;
		}

		printf("---------------[ENUM PROCESS]:get descriptor (class 0x22) done!----------------\n");

		//-----------------------------------get keycode value------------------------------------------------//
		usleep(10000);
		int x1_p;
		int y1_p;
		int x2_p;
		int y2_p;
		int bool = 0;
		while (1)
		{
			toggle++;
			IO_write(HPI_ADDR, 0x0500); //the start address
			//data phase IN-1
			IO_write(HPI_DATA, 0x051c); //500

			IO_write(HPI_DATA, 0x000f & data_size); //2 data length

			IO_write(HPI_DATA, 0x0291); //4 //endpoint 1
			if (toggle % 2)
			{
				IO_write(HPI_DATA, 0x0001); //6 //data 1
			}
			else
			{
				IO_write(HPI_DATA, 0x0041); //6 //data 1
			}
			IO_write(HPI_DATA, 0x0013);				   //8
			IO_write(HPI_DATA, 0x0000);				   //a
			UsbWrite(HUSB_SIE1_pCurrentTDPtr, 0x0500); //HUSB_SIE1_pCurrentTDPtr

			while (!(IO_read(HPI_STATUS) & HPI_STATUS_SIE1msg_FLAG)) //read sie1 msg register
			{
				IO_write(HPI_ADDR, 0x0500); //the start address
				//data phase IN-1
				IO_write(HPI_DATA, 0x051c); //500

				IO_write(HPI_DATA, 0x000f & data_size); //2 data length

				IO_write(HPI_DATA, 0x0291); //4 //endpoint 1
				if (toggle % 2)
				{
					IO_write(HPI_DATA, 0x0001); //6 //data 1
				}
				else
				{
					IO_write(HPI_DATA, 0x0041); //6 //data 1
				}
				IO_write(HPI_DATA, 0x0013);				   //8
				IO_write(HPI_DATA, 0x0000);				   //
				UsbWrite(HUSB_SIE1_pCurrentTDPtr, 0x0500); //HUSB_SIE1_pCurrentTDPtr
				usleep(10 * 1000);
			} //end while

			usb_ctl_val = UsbWaitTDListDone();

			// The first two keycodes are stored in 0x051E. Other keycodes are in
			// subsequent addresses.
			// We only need the first keycode, which is at the lower byte of keycode.
			// Send the keycode to hardware via PIO.
			keycode = UsbRead(0x051e);
			// printf("\nfirst two keycode values are %04x\n",keycode);

			*keycode_base = keycode & 0xff;
			usleep(200);

			if (have_found)
			{
				*path1 = path_save_1;
				*path2 = path_save_2;
				*path3 = path_save_3;
				*path4 = path_save_4;
			}

			if ((*pos_x != 0) || (*pos_y != 0))
			{
				if (bool == 0)
				{
					have_found = 0;
					*path1 = (unsigned int)0b00000000000000000000000000000000;
					*path2 = (unsigned int)0b00000000000000000000000000000000;
					*path3 = (unsigned int)0b00000000000000000000000000000000;
					*path4 = (unsigned int)0b00000000000000000000000000000000;
					*distancehigh = 0;
					*distancelow = 0;
					x1_p = *pos_x;
					y1_p = *pos_y;
					bool = 1;
					usleep(100000);
					for (int i = 0; i < MAP_LENTH; i++)
					{
						if (((int)dis[i][0] == x1_p) && ((int)dis[i][1] == y1_p))
						{
							END = i;
							*endpoint = END + 1;
							*beginpoint = 0;
						}
					}
				}
				else
				{
					have_found = 0;
					x2_p = *pos_x;
					y2_p = *pos_y;
					for (int i = 0; i < MAP_LENTH; i++)
					{
						if (((int)dis[i][0] == x2_p) && ((int)dis[i][1] == y2_p))
						{
							START = i;
							*beginpoint = START + 1;
						}
					}
					find_and_display(START, END);
					bool = 0;
				}
			}

			usb_ctl_val = UsbRead(ctl_reg);

			if (!(usb_ctl_val & no_device))
			{
				//USB hot plug routine
				for (hot_plug_count = 0; hot_plug_count < 7; hot_plug_count++)
				{
					usleep(5 * 1000);
					usb_ctl_val = UsbRead(ctl_reg);
					if (usb_ctl_val & no_device)
						break;
				}
				if (!(usb_ctl_val & no_device))
				{
					printf("\n[INFO]: the keyboard has been removed!!! \n");
					printf("[INFO]: please insert again!!! \n");
				}
			}

			while (!(usb_ctl_val & no_device))
			{
				usb_ctl_val = UsbRead(ctl_reg);
				usleep(5 * 1000);
				usb_ctl_val = UsbRead(ctl_reg);
				usleep(5 * 1000);
				usb_ctl_val = UsbRead(ctl_reg);
				usleep(5 * 1000);

				if (usb_ctl_val & no_device)
					goto USB_HOT_PLUG1;

				usleep(200);
			}

		} //end while

		return 0;
	}

	if (situation == 3) {
		double time_for_software = 0.0;
		double time_for_accelerator = 0.0;
		int cnt1, cnt2;
		benchmark(&time_for_software, &time_for_accelerator, &cnt1, &cnt2);
		printf("software    total time: %.5lfs\n", time_for_software);
		printf("accelerator total time: %.5lfs\n", time_for_accelerator);
		printf("%dX speed up !!! AMAZING !!!\n", (int)(time_for_software/time_for_accelerator));
		while(1) {}
	}
}

int strtoint(char *a)
{
	int m = -1;
	if (strcmp(a, "Elm") == 0)
	{
		m = 0;
	}
	if (strcmp(a, "Gla") == 0)
	{
		m = 1;
	}
	if (strcmp(a, "Manito") == 0)
	{
		m = 2;
	}
	if (strcmp(a, "Jct") == 0)
	{
		m = 3;
	}
	if (strcmp(a, "lle") == 0)
	{
		m = 4;
	}
	if (strcmp(a, "Sta") == 0)
	{
		m = 5;
	}
	if (strcmp(a, "Riv") == 0)
	{
		m = 6;
	}
	if (strcmp(a, "She") == 0)
	{
		m = 7;
	}
	if (strcmp(a, "Bar") == 0)
	{
		m = 8;
	}
	if (strcmp(a, "Lut") == 0)
	{
		m = 9;
	}
	if (strcmp(a, "Gre") == 0)
	{
		m = 10;
	}
	if (strcmp(a, "Sou") == 0)
	{
		m = 11;
	}
	if (strcmp(a, "Pow") == 0)
	{
		m = 12;
	}
	if (strcmp(a, "Han") == 0)
	{
		m = 13;
	}
	if (strcmp(a, "Mos") == 0)
	{
		m = 14;
	}
	if (strcmp(a, "Eas") == 0)
	{
		m = 15;
	}
	if (strcmp(a, "Del") == 0)
	{
		m = 16;
	}
	if (strcmp(a, "Farmd") == 0)
	{
		m = 17;
	}
	if (strcmp(a, "Was") == 0)
	{
		m = 18;
	}
	if (strcmp(a, "Eur") == 0)
	{
		m = 19;
	}
	if (strcmp(a, "ElP") == 0)
	{
		m = 20;
	}
	if (strcmp(a, "Lin") == 0)
	{
		m = 21;
	}
	if (strcmp(a, "Mt.") == 0)
	{
		m = 22;
	}
	if (strcmp(a, "Ill") == 0)
	{
		m = 23;
	}
	if (strcmp(a, "Har") == 0)
	{
		m = 24;
	}
	if (strcmp(a, "Dec") == 0)
	{
		m = 25;
	}
	if (strcmp(a, "War") == 0)
	{
		m = 26;
	}
	if (strcmp(a, "Ken") == 0)
	{
		m = 27;
	}
	if (strcmp(a, "Cli") == 0)
	{
		m = 28;
	}
	if (strcmp(a, "Hey") == 0)
	{
		m = 29;
	}
	if (strcmp(a, "Atl") == 0)
	{
		m = 30;
	}
	if (strcmp(a, "Blo") == 0)
	{
		m = 31;
	}
	if (strcmp(a, "Car") == 0)
	{
		m = 32;
	}
	if (strcmp(a, "Cra") == 0)
	{
		m = 33;
	}
	if (strcmp(a, "Lex") == 0)
	{
		m = 34;
	}
	if (strcmp(a, "Che") == 0)
	{
		m = 35;
	}
	if (strcmp(a, "Mac") == 0)
	{
		m = 36;
	}
	if (strcmp(a, "Blu") == 0)
	{
		m = 37;
	}
	if (strcmp(a, "Boo") == 0)
	{
		m = 38;
	}
	if (strcmp(a, "Her") == 0)
	{
		m = 39;
	}
	if (strcmp(a, "Lon") == 0)
	{
		m = 40;
	}
	if (strcmp(a, "Atw") == 0)
	{
		m = 41;
	}
	if (strcmp(a, "Art") == 0)
	{
		m = 42;
	}
	if (strcmp(a, "Tus") == 0)
	{
		m = 43;
	}
	if (strcmp(a, "Arc") == 0)
	{
		m = 44;
	}
	if (strcmp(a, "Mur") == 0)
	{
		m = 45;
	}
	if (strcmp(a, "New") == 0)
	{
		m = 46;
	}
	if (strcmp(a, "Met") == 0)
	{
		m = 47;
	}
	if (strcmp(a, "Chr") == 0)
	{
		m = 48;
	}
	if (strcmp(a, "WestD") == 0)
	{
		m = 49;
	}
	if (strcmp(a, "Rid") == 0)
	{
		m = 50;
	}
	if (strcmp(a, "Wes") == 0)
	{
		m = 51;
	}
	if (strcmp(a, "Til") == 0)
	{
		m = 52;
	}
	if (strcmp(a, "Dan") == 0)
	{
		m = 53;
	}
	if (strcmp(a, "Col") == 0)
	{
		m = 54;
	}
	if (strcmp(a, "Hen") == 0)
	{
		m = 55;
	}
	if (strcmp(a, "Ros") == 0)
	{
		m = 56;
	}
	if (strcmp(a, "Hoo") == 0)
	{
		m = 57;
	}
	if (strcmp(a, "Mil") == 0)
	{
		m = 58;
	}
	if (strcmp(a, "Woo") == 0)
	{
		m = 59;
	}
	if (strcmp(a, "Wat") == 0)
	{
		m = 60;
	}
	if (strcmp(a, "Web") == 0)
	{
		m = 61;
	}
	if (strcmp(a, "Gil") == 0)
	{
		m = 62;
	}
	if (strcmp(a, "Ona") == 0)
	{
		m = 63;
	}
	if (strcmp(a, "Pax") == 0)
	{
		m = 64;
	}
	if (strcmp(a, "Ran") == 0)
	{
		m = 65;
	}
	if (strcmp(a, "Dil") == 0)
	{
		m = 66;
	}
	if (strcmp(a, "Fis") == 0)
	{
		m = 67;
	}
	if (strcmp(a, "Tho") == 0)
	{
		m = 68;
	}
	if (strcmp(a, "Urb") == 0)
	{
		m = 69;
	}
	if (strcmp(a, "Champaign") == 0)
	{
		m = 70;
	}
	if (strcmp(a, "Sav") == 0)
	{
		m = 71;
	}
	if (strcmp(a, "Tol") == 0)
	{
		m = 72;
	}
	if (strcmp(a, "Sid") == 0)
	{
		m = 73;
	}
	if (strcmp(a, "Hom") == 0)
	{
		m = 74;
	}
	if (strcmp(a, "Glo") == 0)
	{
		m = 75;
	}
	if (strcmp(a, "Goo") == 0)
	{
		m = 76;
	}
	if (strcmp(a, "Cis") == 0)
	{
		m = 77;
	}
	if (strcmp(a, "Vil") == 0)
	{
		m = 78;
	}
	if (strcmp(a, "Bor") == 0)
	{
		m = 79;
	}
	if (strcmp(a, "Bem") == 0)
	{
		m = 80;
	}
	if (strcmp(a, "Cer") == 0)
	{
		m = 81;
	}
	if (strcmp(a, "Cisco") == 0)
	{
		m = 82;
	}
	if (strcmp(a, "Mon") == 0)
	{
		m = 83;
	}
	if (strcmp(a, "Lod") == 0)
	{
		m = 84;
	}
	if (strcmp(a, "Man") == 0)
	{
		m = 85;
	}
	if (strcmp(a, "Lot") == 0)
	{
		m = 86;
	}
	if (strcmp(a, "Gib") == 0)
	{
		m = 87;
	}
	if (strcmp(a, "Mel") == 0)
	{
		m = 88;
	}
	if (strcmp(a, "LeR") == 0)
	{
		m = 89;
	}
	if (strcmp(a, "Arr") == 0)
	{
		m = 90;
	}
	if (strcmp(a, "Ris") == 0)
	{
		m = 91;
	}
	if (strcmp(a, "Colfax") == 0)
	{
		m = 92;
	}
	if (strcmp(a, "Cha") == 0)
	{
		m = 93;
	}
	if (strcmp(a, "For") == 0)
	{
		m = 94;
	}
	if (strcmp(a, "Fai") == 0)
	{
		m = 95;
	}
	if (strcmp(a, "Far") == 0)
	{
		m = 96;
	}

	return m;
}
