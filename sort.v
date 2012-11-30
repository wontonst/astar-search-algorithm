
module sort(Clk,Reset);
  
  input Clk;
  input Reset;

  reg[15:0] temp1,temp2,temp3,temp4,temp5,temp6,total1,total2;
  reg did_swap;
  
  reg [7:0] state;

  reg [7:0] openx [0:399];//open list x cord
 reg [7:0] openy [0:399];//open list y cord
   reg [9:0] opencounter;
   
   reg [7:0] sort_count;//used for sorting
   
  
  localparam
    SORT_QUEUE = 8'b000010000,
    BUBBLE_SORT = 8'b00001001,
    GET_SECOND_DISTANCE = 8'b00001010,
    COMPARE_BETTER = 8'b00001011,
    SWITCH = 8'b00001100,
    BUBBLE_NEXT = 8'b00001101,
    SORT_DONE = 8'b00001110;
   

   always @ (posedge Clk, posedge Reset)
     begin
	if(Reset)
	  begin

openx[0] <= {0,0,0,0,0,0,0,0};
openy[0] <= {0,0,0,0,0,0,0,0};
openx[1] <= {0,0,0,0,0,0,0,0};
openy[1] <= {0,0,0,0,0,0,0,0};
openx[2] <= {0,0,0,0,0,0,0,0};
openy[2] <= {0,0,0,0,0,0,0,0};
openx[3] <= {0,0,0,0,0,0,0,0};
openy[3] <= {0,0,0,0,0,0,0,0};
openx[4] <= {0,0,0,0,0,0,0,0};
openy[4] <= {0,0,0,0,0,0,0,0};
openx[5] <= {0,0,0,0,0,0,0,0};
openy[5] <= {0,0,0,0,0,0,0,0};
openx[6] <= {0,0,0,0,0,0,0,0};
openy[6] <= {0,0,0,0,0,0,0,0};
openx[7] <= {0,0,0,0,0,0,0,0};
openy[7] <= {0,0,0,0,0,0,0,0};
openx[8] <= {0,0,0,0,0,0,0,0};
openy[8] <= {0,0,0,0,0,0,0,0};
openx[9] <= {0,0,0,0,0,0,0,0};
openy[9] <= {0,0,0,0,0,0,0,0};
openx[10] <= {0,0,0,0,0,0,0,0};
openy[10] <= {0,0,0,0,0,0,0,0};
openx[11] <= {0,0,0,0,0,0,0,0};
openy[11] <= {0,0,0,0,0,0,0,0};
openx[12] <= {0,0,0,0,0,0,0,0};
openy[12] <= {0,0,0,0,0,0,0,0};
openx[13] <= {0,0,0,0,0,0,0,0};
openy[13] <= {0,0,0,0,0,0,0,0};
openx[14] <= {0,0,0,0,0,0,0,0};
openy[14] <= {0,0,0,0,0,0,0,0};
openx[15] <= {0,0,0,0,0,0,0,0};
openy[15] <= {0,0,0,0,0,0,0,0};
openx[16] <= {0,0,0,0,0,0,0,0};
openy[16] <= {0,0,0,0,0,0,0,0};
openx[17] <= {0,0,0,0,0,0,0,0};
openy[17] <= {0,0,0,0,0,0,0,0};
openx[18] <= {0,0,0,0,0,0,0,0};
openy[18] <= {0,0,0,0,0,0,0,0};
openx[19] <= {0,0,0,0,0,0,0,0};
openy[19] <= {0,0,0,0,0,0,0,0};
openx[20] <= {0,0,0,0,0,0,0,0};
openy[20] <= {0,0,0,0,0,0,0,0};
openx[21] <= {0,0,0,0,0,0,0,0};
openy[21] <= {0,0,0,0,0,0,0,0};
openx[22] <= {0,0,0,0,0,0,0,0};
openy[22] <= {0,0,0,0,0,0,0,0};
openx[23] <= {0,0,0,0,0,0,0,0};
openy[23] <= {0,0,0,0,0,0,0,0};
openx[24] <= {0,0,0,0,0,0,0,0};
openy[24] <= {0,0,0,0,0,0,0,0};
openx[25] <= {0,0,0,0,0,0,0,0};
openy[25] <= {0,0,0,0,0,0,0,0};
openx[26] <= {0,0,0,0,0,0,0,0};
openy[26] <= {0,0,0,0,0,0,0,0};
openx[27] <= {0,0,0,0,0,0,0,0};
openy[27] <= {0,0,0,0,0,0,0,0};
openx[28] <= {0,0,0,0,0,0,0,0};
openy[28] <= {0,0,0,0,0,0,0,0};
openx[29] <= {0,0,0,0,0,0,0,0};
openy[29] <= {0,0,0,0,0,0,0,0};
openx[30] <= {0,0,0,0,0,0,0,0};
openy[30] <= {0,0,0,0,0,0,0,0};
openx[31] <= {0,0,0,0,0,0,0,0};
openy[31] <= {0,0,0,0,0,0,0,0};
openx[32] <= {0,0,0,0,0,0,0,0};
openy[32] <= {0,0,0,0,0,0,0,0};
openx[33] <= {0,0,0,0,0,0,0,0};
openy[33] <= {0,0,0,0,0,0,0,0};
openx[34] <= {0,0,0,0,0,0,0,0};
openy[34] <= {0,0,0,0,0,0,0,0};
openx[35] <= {0,0,0,0,0,0,0,0};
openy[35] <= {0,0,0,0,0,0,0,0};
openx[36] <= {0,0,0,0,0,0,0,0};
openy[36] <= {0,0,0,0,0,0,0,0};
openx[37] <= {0,0,0,0,0,0,0,0};
openy[37] <= {0,0,0,0,0,0,0,0};
openx[38] <= {0,0,0,0,0,0,0,0};
openy[38] <= {0,0,0,0,0,0,0,0};
openx[39] <= {0,0,0,0,0,0,0,0};
openy[39] <= {0,0,0,0,0,0,0,0};
openx[40] <= {0,0,0,0,0,0,0,0};
openy[40] <= {0,0,0,0,0,0,0,0};
openx[41] <= {0,0,0,0,0,0,0,0};
openy[41] <= {0,0,0,0,0,0,0,0};
openx[42] <= {0,0,0,0,0,0,0,0};
openy[42] <= {0,0,0,0,0,0,0,0};
openx[43] <= {0,0,0,0,0,0,0,0};
openy[43] <= {0,0,0,0,0,0,0,0};
openx[44] <= {0,0,0,0,0,0,0,0};
openy[44] <= {0,0,0,0,0,0,0,0};
openx[45] <= {0,0,0,0,0,0,0,0};
openy[45] <= {0,0,0,0,0,0,0,0};
openx[46] <= {0,0,0,0,0,0,0,0};
openy[46] <= {0,0,0,0,0,0,0,0};
openx[47] <= {0,0,0,0,0,0,0,0};
openy[47] <= {0,0,0,0,0,0,0,0};
openx[48] <= {0,0,0,0,0,0,0,0};
openy[48] <= {0,0,0,0,0,0,0,0};
openx[49] <= {0,0,0,0,0,0,0,0};
openy[49] <= {0,0,0,0,0,0,0,0};
openx[50] <= {0,0,0,0,0,0,0,0};
openy[50] <= {0,0,0,0,0,0,0,0};
openx[51] <= {0,0,0,0,0,0,0,0};
openy[51] <= {0,0,0,0,0,0,0,0};
openx[52] <= {0,0,0,0,0,0,0,0};
openy[52] <= {0,0,0,0,0,0,0,0};
openx[53] <= {0,0,0,0,0,0,0,0};
openy[53] <= {0,0,0,0,0,0,0,0};
openx[54] <= {0,0,0,0,0,0,0,0};
openy[54] <= {0,0,0,0,0,0,0,0};
openx[55] <= {0,0,0,0,0,0,0,0};
openy[55] <= {0,0,0,0,0,0,0,0};
openx[56] <= {0,0,0,0,0,0,0,0};
openy[56] <= {0,0,0,0,0,0,0,0};
openx[57] <= {0,0,0,0,0,0,0,0};
openy[57] <= {0,0,0,0,0,0,0,0};
openx[58] <= {0,0,0,0,0,0,0,0};
openy[58] <= {0,0,0,0,0,0,0,0};
openx[59] <= {0,0,0,0,0,0,0,0};
openy[59] <= {0,0,0,0,0,0,0,0};
openx[60] <= {0,0,0,0,0,0,0,0};
openy[60] <= {0,0,0,0,0,0,0,0};
openx[61] <= {0,0,0,0,0,0,0,0};
openy[61] <= {0,0,0,0,0,0,0,0};
openx[62] <= {0,0,0,0,0,0,0,0};
openy[62] <= {0,0,0,0,0,0,0,0};
openx[63] <= {0,0,0,0,0,0,0,0};
openy[63] <= {0,0,0,0,0,0,0,0};
openx[64] <= {0,0,0,0,0,0,0,0};
openy[64] <= {0,0,0,0,0,0,0,0};
openx[65] <= {0,0,0,0,0,0,0,0};
openy[65] <= {0,0,0,0,0,0,0,0};
openx[66] <= {0,0,0,0,0,0,0,0};
openy[66] <= {0,0,0,0,0,0,0,0};
openx[67] <= {0,0,0,0,0,0,0,0};
openy[67] <= {0,0,0,0,0,0,0,0};
openx[68] <= {0,0,0,0,0,0,0,0};
openy[68] <= {0,0,0,0,0,0,0,0};
openx[69] <= {0,0,0,0,0,0,0,0};
openy[69] <= {0,0,0,0,0,0,0,0};
openx[70] <= {0,0,0,0,0,0,0,0};
openy[70] <= {0,0,0,0,0,0,0,0};
openx[71] <= {0,0,0,0,0,0,0,0};
openy[71] <= {0,0,0,0,0,0,0,0};
openx[72] <= {0,0,0,0,0,0,0,0};
openy[72] <= {0,0,0,0,0,0,0,0};
openx[73] <= {0,0,0,0,0,0,0,0};
openy[73] <= {0,0,0,0,0,0,0,0};
openx[74] <= {0,0,0,0,0,0,0,0};
openy[74] <= {0,0,0,0,0,0,0,0};
openx[75] <= {0,0,0,0,0,0,0,0};
openy[75] <= {0,0,0,0,0,0,0,0};
openx[76] <= {0,0,0,0,0,0,0,0};
openy[76] <= {0,0,0,0,0,0,0,0};
openx[77] <= {0,0,0,0,0,0,0,0};
openy[77] <= {0,0,0,0,0,0,0,0};
openx[78] <= {0,0,0,0,0,0,0,0};
openy[78] <= {0,0,0,0,0,0,0,0};
openx[79] <= {0,0,0,0,0,0,0,0};
openy[79] <= {0,0,0,0,0,0,0,0};
openx[80] <= {0,0,0,0,0,0,0,0};
openy[80] <= {0,0,0,0,0,0,0,0};
openx[81] <= {0,0,0,0,0,0,0,0};
openy[81] <= {0,0,0,0,0,0,0,0};
openx[82] <= {0,0,0,0,0,0,0,0};
openy[82] <= {0,0,0,0,0,0,0,0};
openx[83] <= {0,0,0,0,0,0,0,0};
openy[83] <= {0,0,0,0,0,0,0,0};
openx[84] <= {0,0,0,0,0,0,0,0};
openy[84] <= {0,0,0,0,0,0,0,0};
openx[85] <= {0,0,0,0,0,0,0,0};
openy[85] <= {0,0,0,0,0,0,0,0};
openx[86] <= {0,0,0,0,0,0,0,0};
openy[86] <= {0,0,0,0,0,0,0,0};
openx[87] <= {0,0,0,0,0,0,0,0};
openy[87] <= {0,0,0,0,0,0,0,0};
openx[88] <= {0,0,0,0,0,0,0,0};
openy[88] <= {0,0,0,0,0,0,0,0};
openx[89] <= {0,0,0,0,0,0,0,0};
openy[89] <= {0,0,0,0,0,0,0,0};
openx[90] <= {0,0,0,0,0,0,0,0};
openy[90] <= {0,0,0,0,0,0,0,0};
openx[91] <= {0,0,0,0,0,0,0,0};
openy[91] <= {0,0,0,0,0,0,0,0};
openx[92] <= {0,0,0,0,0,0,0,0};
openy[92] <= {0,0,0,0,0,0,0,0};
openx[93] <= {0,0,0,0,0,0,0,0};
openy[93] <= {0,0,0,0,0,0,0,0};
openx[94] <= {0,0,0,0,0,0,0,0};
openy[94] <= {0,0,0,0,0,0,0,0};
openx[95] <= {0,0,0,0,0,0,0,0};
openy[95] <= {0,0,0,0,0,0,0,0};
openx[96] <= {0,0,0,0,0,0,0,0};
openy[96] <= {0,0,0,0,0,0,0,0};
openx[97] <= {0,0,0,0,0,0,0,0};
openy[97] <= {0,0,0,0,0,0,0,0};
openx[98] <= {0,0,0,0,0,0,0,0};
openy[98] <= {0,0,0,0,0,0,0,0};
openx[99] <= {0,0,0,0,0,0,0,0};
openy[99] <= {0,0,0,0,0,0,0,0};
openx[100] <= {0,0,0,0,0,0,0,0};
openy[100] <= {0,0,0,0,0,0,0,0};
openx[101] <= {0,0,0,0,0,0,0,0};
openy[101] <= {0,0,0,0,0,0,0,0};
openx[102] <= {0,0,0,0,0,0,0,0};
openy[102] <= {0,0,0,0,0,0,0,0};
openx[103] <= {0,0,0,0,0,0,0,0};
openy[103] <= {0,0,0,0,0,0,0,0};
openx[104] <= {0,0,0,0,0,0,0,0};
openy[104] <= {0,0,0,0,0,0,0,0};
openx[105] <= {0,0,0,0,0,0,0,0};
openy[105] <= {0,0,0,0,0,0,0,0};
openx[106] <= {0,0,0,0,0,0,0,0};
openy[106] <= {0,0,0,0,0,0,0,0};
openx[107] <= {0,0,0,0,0,0,0,0};
openy[107] <= {0,0,0,0,0,0,0,0};
openx[108] <= {0,0,0,0,0,0,0,0};
openy[108] <= {0,0,0,0,0,0,0,0};
openx[109] <= {0,0,0,0,0,0,0,0};
openy[109] <= {0,0,0,0,0,0,0,0};
openx[110] <= {0,0,0,0,0,0,0,0};
openy[110] <= {0,0,0,0,0,0,0,0};
openx[111] <= {0,0,0,0,0,0,0,0};
openy[111] <= {0,0,0,0,0,0,0,0};
openx[112] <= {0,0,0,0,0,0,0,0};
openy[112] <= {0,0,0,0,0,0,0,0};
openx[113] <= {0,0,0,0,0,0,0,0};
openy[113] <= {0,0,0,0,0,0,0,0};
openx[114] <= {0,0,0,0,0,0,0,0};
openy[114] <= {0,0,0,0,0,0,0,0};
openx[115] <= {0,0,0,0,0,0,0,0};
openy[115] <= {0,0,0,0,0,0,0,0};
openx[116] <= {0,0,0,0,0,0,0,0};
openy[116] <= {0,0,0,0,0,0,0,0};
openx[117] <= {0,0,0,0,0,0,0,0};
openy[117] <= {0,0,0,0,0,0,0,0};
openx[118] <= {0,0,0,0,0,0,0,0};
openy[118] <= {0,0,0,0,0,0,0,0};
openx[119] <= {0,0,0,0,0,0,0,0};
openy[119] <= {0,0,0,0,0,0,0,0};
openx[120] <= {0,0,0,0,0,0,0,0};
openy[120] <= {0,0,0,0,0,0,0,0};
openx[121] <= {0,0,0,0,0,0,0,0};
openy[121] <= {0,0,0,0,0,0,0,0};
openx[122] <= {0,0,0,0,0,0,0,0};
openy[122] <= {0,0,0,0,0,0,0,0};
openx[123] <= {0,0,0,0,0,0,0,0};
openy[123] <= {0,0,0,0,0,0,0,0};
openx[124] <= {0,0,0,0,0,0,0,0};
openy[124] <= {0,0,0,0,0,0,0,0};
openx[125] <= {0,0,0,0,0,0,0,0};
openy[125] <= {0,0,0,0,0,0,0,0};
openx[126] <= {0,0,0,0,0,0,0,0};
openy[126] <= {0,0,0,0,0,0,0,0};
openx[127] <= {0,0,0,0,0,0,0,0};
openy[127] <= {0,0,0,0,0,0,0,0};
openx[128] <= {0,0,0,0,0,0,0,0};
openy[128] <= {0,0,0,0,0,0,0,0};
openx[129] <= {0,0,0,0,0,0,0,0};
openy[129] <= {0,0,0,0,0,0,0,0};
openx[130] <= {0,0,0,0,0,0,0,0};
openy[130] <= {0,0,0,0,0,0,0,0};
openx[131] <= {0,0,0,0,0,0,0,0};
openy[131] <= {0,0,0,0,0,0,0,0};
openx[132] <= {0,0,0,0,0,0,0,0};
openy[132] <= {0,0,0,0,0,0,0,0};
openx[133] <= {0,0,0,0,0,0,0,0};
openy[133] <= {0,0,0,0,0,0,0,0};
openx[134] <= {0,0,0,0,0,0,0,0};
openy[134] <= {0,0,0,0,0,0,0,0};
openx[135] <= {0,0,0,0,0,0,0,0};
openy[135] <= {0,0,0,0,0,0,0,0};
openx[136] <= {0,0,0,0,0,0,0,0};
openy[136] <= {0,0,0,0,0,0,0,0};
openx[137] <= {0,0,0,0,0,0,0,0};
openy[137] <= {0,0,0,0,0,0,0,0};
openx[138] <= {0,0,0,0,0,0,0,0};
openy[138] <= {0,0,0,0,0,0,0,0};
openx[139] <= {0,0,0,0,0,0,0,0};
openy[139] <= {0,0,0,0,0,0,0,0};
openx[140] <= {0,0,0,0,0,0,0,0};
openy[140] <= {0,0,0,0,0,0,0,0};
openx[141] <= {0,0,0,0,0,0,0,0};
openy[141] <= {0,0,0,0,0,0,0,0};
openx[142] <= {0,0,0,0,0,0,0,0};
openy[142] <= {0,0,0,0,0,0,0,0};
openx[143] <= {0,0,0,0,0,0,0,0};
openy[143] <= {0,0,0,0,0,0,0,0};
openx[144] <= {0,0,0,0,0,0,0,0};
openy[144] <= {0,0,0,0,0,0,0,0};
openx[145] <= {0,0,0,0,0,0,0,0};
openy[145] <= {0,0,0,0,0,0,0,0};
openx[146] <= {0,0,0,0,0,0,0,0};
openy[146] <= {0,0,0,0,0,0,0,0};
openx[147] <= {0,0,0,0,0,0,0,0};
openy[147] <= {0,0,0,0,0,0,0,0};
openx[148] <= {0,0,0,0,0,0,0,0};
openy[148] <= {0,0,0,0,0,0,0,0};
openx[149] <= {0,0,0,0,0,0,0,0};
openy[149] <= {0,0,0,0,0,0,0,0};
openx[150] <= {0,0,0,0,0,0,0,0};
openy[150] <= {0,0,0,0,0,0,0,0};
openx[151] <= {0,0,0,0,0,0,0,0};
openy[151] <= {0,0,0,0,0,0,0,0};
openx[152] <= {0,0,0,0,0,0,0,0};
openy[152] <= {0,0,0,0,0,0,0,0};
openx[153] <= {0,0,0,0,0,0,0,0};
openy[153] <= {0,0,0,0,0,0,0,0};
openx[154] <= {0,0,0,0,0,0,0,0};
openy[154] <= {0,0,0,0,0,0,0,0};
openx[155] <= {0,0,0,0,0,0,0,0};
openy[155] <= {0,0,0,0,0,0,0,0};
openx[156] <= {0,0,0,0,0,0,0,0};
openy[156] <= {0,0,0,0,0,0,0,0};
openx[157] <= {0,0,0,0,0,0,0,0};
openy[157] <= {0,0,0,0,0,0,0,0};
openx[158] <= {0,0,0,0,0,0,0,0};
openy[158] <= {0,0,0,0,0,0,0,0};
openx[159] <= {0,0,0,0,0,0,0,0};
openy[159] <= {0,0,0,0,0,0,0,0};
openx[160] <= {0,0,0,0,0,0,0,0};
openy[160] <= {0,0,0,0,0,0,0,0};
openx[161] <= {0,0,0,0,0,0,0,0};
openy[161] <= {0,0,0,0,0,0,0,0};
openx[162] <= {0,0,0,0,0,0,0,0};
openy[162] <= {0,0,0,0,0,0,0,0};
openx[163] <= {0,0,0,0,0,0,0,0};
openy[163] <= {0,0,0,0,0,0,0,0};
openx[164] <= {0,0,0,0,0,0,0,0};
openy[164] <= {0,0,0,0,0,0,0,0};
openx[165] <= {0,0,0,0,0,0,0,0};
openy[165] <= {0,0,0,0,0,0,0,0};
openx[166] <= {0,0,0,0,0,0,0,0};
openy[166] <= {0,0,0,0,0,0,0,0};
openx[167] <= {0,0,0,0,0,0,0,0};
openy[167] <= {0,0,0,0,0,0,0,0};
openx[168] <= {0,0,0,0,0,0,0,0};
openy[168] <= {0,0,0,0,0,0,0,0};
openx[169] <= {0,0,0,0,0,0,0,0};
openy[169] <= {0,0,0,0,0,0,0,0};
openx[170] <= {0,0,0,0,0,0,0,0};
openy[170] <= {0,0,0,0,0,0,0,0};
openx[171] <= {0,0,0,0,0,0,0,0};
openy[171] <= {0,0,0,0,0,0,0,0};
openx[172] <= {0,0,0,0,0,0,0,0};
openy[172] <= {0,0,0,0,0,0,0,0};
openx[173] <= {0,0,0,0,0,0,0,0};
openy[173] <= {0,0,0,0,0,0,0,0};
openx[174] <= {0,0,0,0,0,0,0,0};
openy[174] <= {0,0,0,0,0,0,0,0};
openx[175] <= {0,0,0,0,0,0,0,0};
openy[175] <= {0,0,0,0,0,0,0,0};
openx[176] <= {0,0,0,0,0,0,0,0};
openy[176] <= {0,0,0,0,0,0,0,0};
openx[177] <= {0,0,0,0,0,0,0,0};
openy[177] <= {0,0,0,0,0,0,0,0};
openx[178] <= {0,0,0,0,0,0,0,0};
openy[178] <= {0,0,0,0,0,0,0,0};
openx[179] <= {0,0,0,0,0,0,0,0};
openy[179] <= {0,0,0,0,0,0,0,0};
openx[180] <= {0,0,0,0,0,0,0,0};
openy[180] <= {0,0,0,0,0,0,0,0};
openx[181] <= {0,0,0,0,0,0,0,0};
openy[181] <= {0,0,0,0,0,0,0,0};
openx[182] <= {0,0,0,0,0,0,0,0};
openy[182] <= {0,0,0,0,0,0,0,0};
openx[183] <= {0,0,0,0,0,0,0,0};
openy[183] <= {0,0,0,0,0,0,0,0};
openx[184] <= {0,0,0,0,0,0,0,0};
openy[184] <= {0,0,0,0,0,0,0,0};
openx[185] <= {0,0,0,0,0,0,0,0};
openy[185] <= {0,0,0,0,0,0,0,0};
openx[186] <= {0,0,0,0,0,0,0,0};
openy[186] <= {0,0,0,0,0,0,0,0};
openx[187] <= {0,0,0,0,0,0,0,0};
openy[187] <= {0,0,0,0,0,0,0,0};
openx[188] <= {0,0,0,0,0,0,0,0};
openy[188] <= {0,0,0,0,0,0,0,0};
openx[189] <= {0,0,0,0,0,0,0,0};
openy[189] <= {0,0,0,0,0,0,0,0};
openx[190] <= {0,0,0,0,0,0,0,0};
openy[190] <= {0,0,0,0,0,0,0,0};
openx[191] <= {0,0,0,0,0,0,0,0};
openy[191] <= {0,0,0,0,0,0,0,0};
openx[192] <= {0,0,0,0,0,0,0,0};
openy[192] <= {0,0,0,0,0,0,0,0};
openx[193] <= {0,0,0,0,0,0,0,0};
openy[193] <= {0,0,0,0,0,0,0,0};
openx[194] <= {0,0,0,0,0,0,0,0};
openy[194] <= {0,0,0,0,0,0,0,0};
openx[195] <= {0,0,0,0,0,0,0,0};
openy[195] <= {0,0,0,0,0,0,0,0};
openx[196] <= {0,0,0,0,0,0,0,0};
openy[196] <= {0,0,0,0,0,0,0,0};
openx[197] <= {0,0,0,0,0,0,0,0};
openy[197] <= {0,0,0,0,0,0,0,0};
openx[198] <= {0,0,0,0,0,0,0,0};
openy[198] <= {0,0,0,0,0,0,0,0};
openx[199] <= {0,0,0,0,0,0,0,0};
openy[199] <= {0,0,0,0,0,0,0,0};
openx[200] <= {0,0,0,0,0,0,0,0};
openy[200] <= {0,0,0,0,0,0,0,0};
openx[201] <= {0,0,0,0,0,0,0,0};
openy[201] <= {0,0,0,0,0,0,0,0};
openx[202] <= {0,0,0,0,0,0,0,0};
openy[202] <= {0,0,0,0,0,0,0,0};
openx[203] <= {0,0,0,0,0,0,0,0};
openy[203] <= {0,0,0,0,0,0,0,0};
openx[204] <= {0,0,0,0,0,0,0,0};
openy[204] <= {0,0,0,0,0,0,0,0};
openx[205] <= {0,0,0,0,0,0,0,0};
openy[205] <= {0,0,0,0,0,0,0,0};
openx[206] <= {0,0,0,0,0,0,0,0};
openy[206] <= {0,0,0,0,0,0,0,0};
openx[207] <= {0,0,0,0,0,0,0,0};
openy[207] <= {0,0,0,0,0,0,0,0};
openx[208] <= {0,0,0,0,0,0,0,0};
openy[208] <= {0,0,0,0,0,0,0,0};
openx[209] <= {0,0,0,0,0,0,0,0};
openy[209] <= {0,0,0,0,0,0,0,0};
openx[210] <= {0,0,0,0,0,0,0,0};
openy[210] <= {0,0,0,0,0,0,0,0};
openx[211] <= {0,0,0,0,0,0,0,0};
openy[211] <= {0,0,0,0,0,0,0,0};
openx[212] <= {0,0,0,0,0,0,0,0};
openy[212] <= {0,0,0,0,0,0,0,0};
openx[213] <= {0,0,0,0,0,0,0,0};
openy[213] <= {0,0,0,0,0,0,0,0};
openx[214] <= {0,0,0,0,0,0,0,0};
openy[214] <= {0,0,0,0,0,0,0,0};
openx[215] <= {0,0,0,0,0,0,0,0};
openy[215] <= {0,0,0,0,0,0,0,0};
openx[216] <= {0,0,0,0,0,0,0,0};
openy[216] <= {0,0,0,0,0,0,0,0};
openx[217] <= {0,0,0,0,0,0,0,0};
openy[217] <= {0,0,0,0,0,0,0,0};
openx[218] <= {0,0,0,0,0,0,0,0};
openy[218] <= {0,0,0,0,0,0,0,0};
openx[219] <= {0,0,0,0,0,0,0,0};
openy[219] <= {0,0,0,0,0,0,0,0};
openx[220] <= {0,0,0,0,0,0,0,0};
openy[220] <= {0,0,0,0,0,0,0,0};
openx[221] <= {0,0,0,0,0,0,0,0};
openy[221] <= {0,0,0,0,0,0,0,0};
openx[222] <= {0,0,0,0,0,0,0,0};
openy[222] <= {0,0,0,0,0,0,0,0};
openx[223] <= {0,0,0,0,0,0,0,0};
openy[223] <= {0,0,0,0,0,0,0,0};
openx[224] <= {0,0,0,0,0,0,0,0};
openy[224] <= {0,0,0,0,0,0,0,0};
openx[225] <= {0,0,0,0,0,0,0,0};
openy[225] <= {0,0,0,0,0,0,0,0};
openx[226] <= {0,0,0,0,0,0,0,0};
openy[226] <= {0,0,0,0,0,0,0,0};
openx[227] <= {0,0,0,0,0,0,0,0};
openy[227] <= {0,0,0,0,0,0,0,0};
openx[228] <= {0,0,0,0,0,0,0,0};
openy[228] <= {0,0,0,0,0,0,0,0};
openx[229] <= {0,0,0,0,0,0,0,0};
openy[229] <= {0,0,0,0,0,0,0,0};
openx[230] <= {0,0,0,0,0,0,0,0};
openy[230] <= {0,0,0,0,0,0,0,0};
openx[231] <= {0,0,0,0,0,0,0,0};
openy[231] <= {0,0,0,0,0,0,0,0};
openx[232] <= {0,0,0,0,0,0,0,0};
openy[232] <= {0,0,0,0,0,0,0,0};
openx[233] <= {0,0,0,0,0,0,0,0};
openy[233] <= {0,0,0,0,0,0,0,0};
openx[234] <= {0,0,0,0,0,0,0,0};
openy[234] <= {0,0,0,0,0,0,0,0};
openx[235] <= {0,0,0,0,0,0,0,0};
openy[235] <= {0,0,0,0,0,0,0,0};
openx[236] <= {0,0,0,0,0,0,0,0};
openy[236] <= {0,0,0,0,0,0,0,0};
openx[237] <= {0,0,0,0,0,0,0,0};
openy[237] <= {0,0,0,0,0,0,0,0};
openx[238] <= {0,0,0,0,0,0,0,0};
openy[238] <= {0,0,0,0,0,0,0,0};
openx[239] <= {0,0,0,0,0,0,0,0};
openy[239] <= {0,0,0,0,0,0,0,0};
openx[240] <= {0,0,0,0,0,0,0,0};
openy[240] <= {0,0,0,0,0,0,0,0};
openx[241] <= {0,0,0,0,0,0,0,0};
openy[241] <= {0,0,0,0,0,0,0,0};
openx[242] <= {0,0,0,0,0,0,0,0};
openy[242] <= {0,0,0,0,0,0,0,0};
openx[243] <= {0,0,0,0,0,0,0,0};
openy[243] <= {0,0,0,0,0,0,0,0};
openx[244] <= {0,0,0,0,0,0,0,0};
openy[244] <= {0,0,0,0,0,0,0,0};
openx[245] <= {0,0,0,0,0,0,0,0};
openy[245] <= {0,0,0,0,0,0,0,0};
openx[246] <= {0,0,0,0,0,0,0,0};
openy[246] <= {0,0,0,0,0,0,0,0};
openx[247] <= {0,0,0,0,0,0,0,0};
openy[247] <= {0,0,0,0,0,0,0,0};
openx[248] <= {0,0,0,0,0,0,0,0};
openy[248] <= {0,0,0,0,0,0,0,0};
openx[249] <= {0,0,0,0,0,0,0,0};
openy[249] <= {0,0,0,0,0,0,0,0};
openx[250] <= {0,0,0,0,0,0,0,0};
openy[250] <= {0,0,0,0,0,0,0,0};
openx[251] <= {0,0,0,0,0,0,0,0};
openy[251] <= {0,0,0,0,0,0,0,0};
openx[252] <= {0,0,0,0,0,0,0,0};
openy[252] <= {0,0,0,0,0,0,0,0};
openx[253] <= {0,0,0,0,0,0,0,0};
openy[253] <= {0,0,0,0,0,0,0,0};
openx[254] <= {0,0,0,0,0,0,0,0};
openy[254] <= {0,0,0,0,0,0,0,0};
openx[255] <= {0,0,0,0,0,0,0,0};
openy[255] <= {0,0,0,0,0,0,0,0};
openx[256] <= {0,0,0,0,0,0,0,0};
openy[256] <= {0,0,0,0,0,0,0,0};
openx[257] <= {0,0,0,0,0,0,0,0};
openy[257] <= {0,0,0,0,0,0,0,0};
openx[258] <= {0,0,0,0,0,0,0,0};
openy[258] <= {0,0,0,0,0,0,0,0};
openx[259] <= {0,0,0,0,0,0,0,0};
openy[259] <= {0,0,0,0,0,0,0,0};
openx[260] <= {0,0,0,0,0,0,0,0};
openy[260] <= {0,0,0,0,0,0,0,0};
openx[261] <= {0,0,0,0,0,0,0,0};
openy[261] <= {0,0,0,0,0,0,0,0};
openx[262] <= {0,0,0,0,0,0,0,0};
openy[262] <= {0,0,0,0,0,0,0,0};
openx[263] <= {0,0,0,0,0,0,0,0};
openy[263] <= {0,0,0,0,0,0,0,0};
openx[264] <= {0,0,0,0,0,0,0,0};
openy[264] <= {0,0,0,0,0,0,0,0};
openx[265] <= {0,0,0,0,0,0,0,0};
openy[265] <= {0,0,0,0,0,0,0,0};
openx[266] <= {0,0,0,0,0,0,0,0};
openy[266] <= {0,0,0,0,0,0,0,0};
openx[267] <= {0,0,0,0,0,0,0,0};
openy[267] <= {0,0,0,0,0,0,0,0};
openx[268] <= {0,0,0,0,0,0,0,0};
openy[268] <= {0,0,0,0,0,0,0,0};
openx[269] <= {0,0,0,0,0,0,0,0};
openy[269] <= {0,0,0,0,0,0,0,0};
openx[270] <= {0,0,0,0,0,0,0,0};
openy[270] <= {0,0,0,0,0,0,0,0};
openx[271] <= {0,0,0,0,0,0,0,0};
openy[271] <= {0,0,0,0,0,0,0,0};
openx[272] <= {0,0,0,0,0,0,0,0};
openy[272] <= {0,0,0,0,0,0,0,0};
openx[273] <= {0,0,0,0,0,0,0,0};
openy[273] <= {0,0,0,0,0,0,0,0};
openx[274] <= {0,0,0,0,0,0,0,0};
openy[274] <= {0,0,0,0,0,0,0,0};
openx[275] <= {0,0,0,0,0,0,0,0};
openy[275] <= {0,0,0,0,0,0,0,0};
openx[276] <= {0,0,0,0,0,0,0,0};
openy[276] <= {0,0,0,0,0,0,0,0};
openx[277] <= {0,0,0,0,0,0,0,0};
openy[277] <= {0,0,0,0,0,0,0,0};
openx[278] <= {0,0,0,0,0,0,0,0};
openy[278] <= {0,0,0,0,0,0,0,0};
openx[279] <= {0,0,0,0,0,0,0,0};
openy[279] <= {0,0,0,0,0,0,0,0};
openx[280] <= {0,0,0,0,0,0,0,0};
openy[280] <= {0,0,0,0,0,0,0,0};
openx[281] <= {0,0,0,0,0,0,0,0};
openy[281] <= {0,0,0,0,0,0,0,0};
openx[282] <= {0,0,0,0,0,0,0,0};
openy[282] <= {0,0,0,0,0,0,0,0};
openx[283] <= {0,0,0,0,0,0,0,0};
openy[283] <= {0,0,0,0,0,0,0,0};
openx[284] <= {0,0,0,0,0,0,0,0};
openy[284] <= {0,0,0,0,0,0,0,0};
openx[285] <= {0,0,0,0,0,0,0,0};
openy[285] <= {0,0,0,0,0,0,0,0};
openx[286] <= {0,0,0,0,0,0,0,0};
openy[286] <= {0,0,0,0,0,0,0,0};
openx[287] <= {0,0,0,0,0,0,0,0};
openy[287] <= {0,0,0,0,0,0,0,0};
openx[288] <= {0,0,0,0,0,0,0,0};
openy[288] <= {0,0,0,0,0,0,0,0};
openx[289] <= {0,0,0,0,0,0,0,0};
openy[289] <= {0,0,0,0,0,0,0,0};
openx[290] <= {0,0,0,0,0,0,0,0};
openy[290] <= {0,0,0,0,0,0,0,0};
openx[291] <= {0,0,0,0,0,0,0,0};
openy[291] <= {0,0,0,0,0,0,0,0};
openx[292] <= {0,0,0,0,0,0,0,0};
openy[292] <= {0,0,0,0,0,0,0,0};
openx[293] <= {0,0,0,0,0,0,0,0};
openy[293] <= {0,0,0,0,0,0,0,0};
openx[294] <= {0,0,0,0,0,0,0,0};
openy[294] <= {0,0,0,0,0,0,0,0};
openx[295] <= {0,0,0,0,0,0,0,0};
openy[295] <= {0,0,0,0,0,0,0,0};
openx[296] <= {0,0,0,0,0,0,0,0};
openy[296] <= {0,0,0,0,0,0,0,0};
openx[297] <= {0,0,0,0,0,0,0,0};
openy[297] <= {0,0,0,0,0,0,0,0};
openx[298] <= {0,0,0,0,0,0,0,0};
openy[298] <= {0,0,0,0,0,0,0,0};
openx[299] <= {0,0,0,0,0,0,0,0};
openy[299] <= {0,0,0,0,0,0,0,0};
openx[300] <= {0,0,0,0,0,0,0,0};
openy[300] <= {0,0,0,0,0,0,0,0};
openx[301] <= {0,0,0,0,0,0,0,0};
openy[301] <= {0,0,0,0,0,0,0,0};
openx[302] <= {0,0,0,0,0,0,0,0};
openy[302] <= {0,0,0,0,0,0,0,0};
openx[303] <= {0,0,0,0,0,0,0,0};
openy[303] <= {0,0,0,0,0,0,0,0};
openx[304] <= {0,0,0,0,0,0,0,0};
openy[304] <= {0,0,0,0,0,0,0,0};
openx[305] <= {0,0,0,0,0,0,0,0};
openy[305] <= {0,0,0,0,0,0,0,0};
openx[306] <= {0,0,0,0,0,0,0,0};
openy[306] <= {0,0,0,0,0,0,0,0};
openx[307] <= {0,0,0,0,0,0,0,0};
openy[307] <= {0,0,0,0,0,0,0,0};
openx[308] <= {0,0,0,0,0,0,0,0};
openy[308] <= {0,0,0,0,0,0,0,0};
openx[309] <= {0,0,0,0,0,0,0,0};
openy[309] <= {0,0,0,0,0,0,0,0};
openx[310] <= {0,0,0,0,0,0,0,0};
openy[310] <= {0,0,0,0,0,0,0,0};
openx[311] <= {0,0,0,0,0,0,0,0};
openy[311] <= {0,0,0,0,0,0,0,0};
openx[312] <= {0,0,0,0,0,0,0,0};
openy[312] <= {0,0,0,0,0,0,0,0};
openx[313] <= {0,0,0,0,0,0,0,0};
openy[313] <= {0,0,0,0,0,0,0,0};
openx[314] <= {0,0,0,0,0,0,0,0};
openy[314] <= {0,0,0,0,0,0,0,0};
openx[315] <= {0,0,0,0,0,0,0,0};
openy[315] <= {0,0,0,0,0,0,0,0};
openx[316] <= {0,0,0,0,0,0,0,0};
openy[316] <= {0,0,0,0,0,0,0,0};
openx[317] <= {0,0,0,0,0,0,0,0};
openy[317] <= {0,0,0,0,0,0,0,0};
openx[318] <= {0,0,0,0,0,0,0,0};
openy[318] <= {0,0,0,0,0,0,0,0};
openx[319] <= {0,0,0,0,0,0,0,0};
openy[319] <= {0,0,0,0,0,0,0,0};
openx[320] <= {0,0,0,0,0,0,0,0};
openy[320] <= {0,0,0,0,0,0,0,0};
openx[321] <= {0,0,0,0,0,0,0,0};
openy[321] <= {0,0,0,0,0,0,0,0};
openx[322] <= {0,0,0,0,0,0,0,0};
openy[322] <= {0,0,0,0,0,0,0,0};
openx[323] <= {0,0,0,0,0,0,0,0};
openy[323] <= {0,0,0,0,0,0,0,0};
openx[324] <= {0,0,0,0,0,0,0,0};
openy[324] <= {0,0,0,0,0,0,0,0};
openx[325] <= {0,0,0,0,0,0,0,0};
openy[325] <= {0,0,0,0,0,0,0,0};
openx[326] <= {0,0,0,0,0,0,0,0};
openy[326] <= {0,0,0,0,0,0,0,0};
openx[327] <= {0,0,0,0,0,0,0,0};
openy[327] <= {0,0,0,0,0,0,0,0};
openx[328] <= {0,0,0,0,0,0,0,0};
openy[328] <= {0,0,0,0,0,0,0,0};
openx[329] <= {0,0,0,0,0,0,0,0};
openy[329] <= {0,0,0,0,0,0,0,0};
openx[330] <= {0,0,0,0,0,0,0,0};
openy[330] <= {0,0,0,0,0,0,0,0};
openx[331] <= {0,0,0,0,0,0,0,0};
openy[331] <= {0,0,0,0,0,0,0,0};
openx[332] <= {0,0,0,0,0,0,0,0};
openy[332] <= {0,0,0,0,0,0,0,0};
openx[333] <= {0,0,0,0,0,0,0,0};
openy[333] <= {0,0,0,0,0,0,0,0};
openx[334] <= {0,0,0,0,0,0,0,0};
openy[334] <= {0,0,0,0,0,0,0,0};
openx[335] <= {0,0,0,0,0,0,0,0};
openy[335] <= {0,0,0,0,0,0,0,0};
openx[336] <= {0,0,0,0,0,0,0,0};
openy[336] <= {0,0,0,0,0,0,0,0};
openx[337] <= {0,0,0,0,0,0,0,0};
openy[337] <= {0,0,0,0,0,0,0,0};
openx[338] <= {0,0,0,0,0,0,0,0};
openy[338] <= {0,0,0,0,0,0,0,0};
openx[339] <= {0,0,0,0,0,0,0,0};
openy[339] <= {0,0,0,0,0,0,0,0};
openx[340] <= {0,0,0,0,0,0,0,0};
openy[340] <= {0,0,0,0,0,0,0,0};
openx[341] <= {0,0,0,0,0,0,0,0};
openy[341] <= {0,0,0,0,0,0,0,0};
openx[342] <= {0,0,0,0,0,0,0,0};
openy[342] <= {0,0,0,0,0,0,0,0};
openx[343] <= {0,0,0,0,0,0,0,0};
openy[343] <= {0,0,0,0,0,0,0,0};
openx[344] <= {0,0,0,0,0,0,0,0};
openy[344] <= {0,0,0,0,0,0,0,0};
openx[345] <= {0,0,0,0,0,0,0,0};
openy[345] <= {0,0,0,0,0,0,0,0};
openx[346] <= {0,0,0,0,0,0,0,0};
openy[346] <= {0,0,0,0,0,0,0,0};
openx[347] <= {0,0,0,0,0,0,0,0};
openy[347] <= {0,0,0,0,0,0,0,0};
openx[348] <= {0,0,0,0,0,0,0,0};
openy[348] <= {0,0,0,0,0,0,0,0};
openx[349] <= {0,0,0,0,0,0,0,0};
openy[349] <= {0,0,0,0,0,0,0,0};
openx[350] <= {0,0,0,0,0,0,0,0};
openy[350] <= {0,0,0,0,0,0,0,0};
openx[351] <= {0,0,0,0,0,0,0,0};
openy[351] <= {0,0,0,0,0,0,0,0};
openx[352] <= {0,0,0,0,0,0,0,0};
openy[352] <= {0,0,0,0,0,0,0,0};
openx[353] <= {0,0,0,0,0,0,0,0};
openy[353] <= {0,0,0,0,0,0,0,0};
openx[354] <= {0,0,0,0,0,0,0,0};
openy[354] <= {0,0,0,0,0,0,0,0};
openx[355] <= {0,0,0,0,0,0,0,0};
openy[355] <= {0,0,0,0,0,0,0,0};
openx[356] <= {0,0,0,0,0,0,0,0};
openy[356] <= {0,0,0,0,0,0,0,0};
openx[357] <= {0,0,0,0,0,0,0,0};
openy[357] <= {0,0,0,0,0,0,0,0};
openx[358] <= {0,0,0,0,0,0,0,0};
openy[358] <= {0,0,0,0,0,0,0,0};
openx[359] <= {0,0,0,0,0,0,0,0};
openy[359] <= {0,0,0,0,0,0,0,0};
openx[360] <= {0,0,0,0,0,0,0,0};
openy[360] <= {0,0,0,0,0,0,0,0};
openx[361] <= {0,0,0,0,0,0,0,0};
openy[361] <= {0,0,0,0,0,0,0,0};
openx[362] <= {0,0,0,0,0,0,0,0};
openy[362] <= {0,0,0,0,0,0,0,0};
openx[363] <= {0,0,0,0,0,0,0,0};
openy[363] <= {0,0,0,0,0,0,0,0};
openx[364] <= {0,0,0,0,0,0,0,0};
openy[364] <= {0,0,0,0,0,0,0,0};
openx[365] <= {0,0,0,0,0,0,0,0};
openy[365] <= {0,0,0,0,0,0,0,0};
openx[366] <= {0,0,0,0,0,0,0,0};
openy[366] <= {0,0,0,0,0,0,0,0};
openx[367] <= {0,0,0,0,0,0,0,0};
openy[367] <= {0,0,0,0,0,0,0,0};
openx[368] <= {0,0,0,0,0,0,0,0};
openy[368] <= {0,0,0,0,0,0,0,0};
openx[369] <= {0,0,0,0,0,0,0,0};
openy[369] <= {0,0,0,0,0,0,0,0};
openx[370] <= {0,0,0,0,0,0,0,0};
openy[370] <= {0,0,0,0,0,0,0,0};
openx[371] <= {0,0,0,0,0,0,0,0};
openy[371] <= {0,0,0,0,0,0,0,0};
openx[372] <= {0,0,0,0,0,0,0,0};
openy[372] <= {0,0,0,0,0,0,0,0};
openx[373] <= {0,0,0,0,0,0,0,0};
openy[373] <= {0,0,0,0,0,0,0,0};
openx[374] <= {0,0,0,0,0,0,0,0};
openy[374] <= {0,0,0,0,0,0,0,0};
openx[375] <= {0,0,0,0,0,0,0,0};
openy[375] <= {0,0,0,0,0,0,0,0};
openx[376] <= {0,0,0,0,0,0,0,0};
openy[376] <= {0,0,0,0,0,0,0,0};
openx[377] <= {0,0,0,0,0,0,0,0};
openy[377] <= {0,0,0,0,0,0,0,0};
openx[378] <= {0,0,0,0,0,0,0,0};
openy[378] <= {0,0,0,0,0,0,0,0};
openx[379] <= {0,0,0,0,0,0,0,0};
openy[379] <= {0,0,0,0,0,0,0,0};
openx[380] <= {0,0,0,0,0,0,0,0};
openy[380] <= {0,0,0,0,0,0,0,0};
openx[381] <= {0,0,0,0,0,0,0,0};
openy[381] <= {0,0,0,0,0,0,0,0};
openx[382] <= {0,0,0,0,0,0,0,0};
openy[382] <= {0,0,0,0,0,0,0,0};
openx[383] <= {0,0,0,0,0,0,0,0};
openy[383] <= {0,0,0,0,0,0,0,0};
openx[384] <= {0,0,0,0,0,0,0,0};
openy[384] <= {0,0,0,0,0,0,0,0};
openx[385] <= {0,0,0,0,0,0,0,0};
openy[385] <= {0,0,0,0,0,0,0,0};
openx[386] <= {0,0,0,0,0,0,0,0};
openy[386] <= {0,0,0,0,0,0,0,0};
openx[387] <= {0,0,0,0,0,0,0,0};
openy[387] <= {0,0,0,0,0,0,0,0};
openx[388] <= {0,0,0,0,0,0,0,0};
openy[388] <= {0,0,0,0,0,0,0,0};
openx[389] <= {0,0,0,0,0,0,0,0};
openy[389] <= {0,0,0,0,0,0,0,0};
openx[390] <= {0,0,0,0,0,0,0,0};
openy[390] <= {0,0,0,0,0,0,0,0};
openx[391] <= {0,0,0,0,0,0,0,0};
openy[391] <= {0,0,0,0,0,0,0,0};
openx[392] <= {0,0,0,0,0,0,0,0};
openy[392] <= {0,0,0,0,0,0,0,0};
openx[393] <= {0,0,0,0,0,0,0,0};
openy[393] <= {0,0,0,0,0,0,0,0};
openx[394] <= {0,0,0,0,0,0,0,0};
openy[394] <= {0,0,0,0,0,0,0,0};
openx[395] <= {0,0,0,0,0,0,0,0};
openy[395] <= {0,0,0,0,0,0,0,0};
openx[396] <= {0,0,0,0,0,0,0,0};
openy[396] <= {0,0,0,0,0,0,0,0};
openx[397] <= {0,0,0,0,0,0,0,0};
openy[397] <= {0,0,0,0,0,0,0,0};
openx[398] <= {0,0,0,0,0,0,0,0};
openy[398] <= {0,0,0,0,0,0,0,0};
openx[399] <= {0,0,0,0,0,0,0,0};
openy[399] <= {0,0,0,0,0,0,0,0};


	     state <= SORT_QUEUE;
	     
	     
          end // if (Reset)
	
        else begin
	   case(state)
        
        /////////////////////////////////////////////////////////////////////////////////

      SORT_QUEUE:
	begin
	   sort_count = 8'b0;
	   opencounter <= 3'd399;
	   did_swap = 1'b0;
	   
	end
      
        
//GET FIRST, DISTANCE
      BUBBLE_SORT:
	begin
	   temp1 <=((openx[sort_count] - goalx < openy[sort_count] - goaly)?openy[sort_count]-goaly:openx[sort_count]-goalx);
	temp2 <= ((openy[sort_count] - goaly < 0)? -1*(openy[sort_count]-goaly):openy[sort_count]-goaly) + ((openx[sort_count]-goalx < 0)? -1 *(openx[sort_count]-goalx):openx[sort_count]-goalx);
	
	temp3 <= 1.41421 * temp1 + (temp2 - 2 * temp1);
	
	temp4 <=((openx[sort_count] - startx < openy[sort_count] - starty)?openy[sort_count]-starty:openx[sort_count]-startx);
	temp5 <= ((openy[sort_count] - starty < 0)? -1*(openy[sort_count]-starty):openy[sort_count]-starty) + ((openx[sort_count]-startx < 0)? -1 *(openx[sort_count]-startx):openx[sort_count]-startx);
	
	temp6 <= 1.41421 * temp4 + (temp5 - 2 * temp6);
	
	//TotalDistanceFromGoal
	total1 = temp3 + temp6;
	state = GET_SECOND_DISTANCE;
	end // case: BUBBLE_SORT
      
GET_SECOND_DISTANCE:
	begin
	temp1 <=((openx[sort_count+1] - goalx < openy[sort_count+1] - goaly)?openy[sort_count+1]-goaly:openx[sort_count+1]-goalx);
	temp2 <= ((openy[sort_count+1] - goaly < 0)? -1*(openy[sort_count+1]-goaly):openy[sort_count+1]-goaly) + ((openx[sort_count+1]-goalx < 0)? -1 *(openx[sort_count+1]-goalx):openx[sort_count+1]-goalx);
	
	temp3 <= 1.41421 * temp1 + (temp2 - 2 * temp1);
	
	temp4 <=((openx[sort_count] - startx < openy[sort_count] - starty)?openy[sort_count]-starty:openx[sort_count]-startx);
	temp5 <= ((openy[sort_count+1] - starty < 0)? -1*(openy[sort_count+1]-starty):openy[sort_count+1]-starty) + ((openx[sort_count+1]-startx < 0)? -1 *(openx[sort_count+1]-startx):openx[sort_count+1]-startx);
	
	temp6 <= 1.41421 * temp4 + (temp5 - 2 * temp6);
	
	total2 = temp3 + temp6;
	end // case: GET_SECOND_DISTANCE
      

COMPARE_BETTER:
  begin
     if(total2 > total1)
			state <= SWITCH;
		if(total1 >= total2)
			state <= BUBBLE_NEXT;
  end
SWITCH:
	begin
		did_swap <= 1'b1;
		temp1 = openx[sort_count];
		openx[sort_count] = openx[sort_count+1];
		openx[sort_count+1] = sort_count;
		state <= BUBBLE_NEXT;
	end
	     BUBBLE_NEXT:
	       begin
		  if(sort_count >= opencounter && did_swap == 1'b1)
		    begin
			sort_count <= 0;
			did_swap <= 1'b0;
			state <= BUBBLE_SORT;
		    end
		  if(sort_count >= opencounter && did_swap == 1'b0)
		    begin
			sort_count <= 0;
			state <= SORT_DONE;//go to next stage here
		    end
		  if(sort_count < open_counter)
		    begin
			sort_count <= sort_count + 1;
			state <= BUBBLE_SORT;
		    end
	       end // case: BUBBLE_NEXT

/////////////////////////////////////////////////////////////////////
	     
	   end // else: !if(Reset)
     end // always @ (posedge Clk, posedge Reset)
endmodule // sort

			