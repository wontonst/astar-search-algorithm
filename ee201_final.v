/*questions
 VGA output?
 string output to some sort of console for debugging? display
 
 PREVIOUS NODE MUST USE X AND Y SO DOUBLE NUMBER OF REGISTERS, FIX THE FOR LOOP gen.php
 SORT COMPARISO NEEDS DISTANCEFROMSTART
 
 SORTING MUST USE THE DISTANCEFROMSTART!
 */

module astar_algorithm(sync,reset,gridx,gridy,draw_grid,draw_obstacle,draw_path,draw_unknown);
   
   input sync, reset, gridx, gridy;
   output draw_grid, draw_obstacle, draw_path, draw_unknown;

   reg [15:0] temp1, temp2, temp3, temp4, temp5, temp6, total1, total2;//temporary calculation registers
   reg 	      did_swap;

   reg [7:0]  openx [0:399];//open list x cord
   reg [7:0]  openy [0:399];//open list y cord
   reg [8:0]  opencounter;//count openx/y reg
   reg [7:0]  closex [0:399];//close list x cord
   reg [7:0]  closey [0:399];//close list y cord
   reg [8:0]  closecounter;//count closex/y reg

   reg [7:0]  currentx;
   reg [7:0]  currenty;

  
   reg [7:0]  neighborx [7:0];//9x1byte, stores neighbor list
   reg [7:0]  neighbory [7:0];//9x1byte, stores neighbor list
   reg [7:0]  tempneighborx [7:0];
   reg [7:0]  tempneighbory [7:0];
   reg [3:0]  neighborcounter;
   reg 	      neighbor_is_better;
   reg [7:0]  neighbor_distance_from_start;
   
      reg [7:0] checkx;//searches for this in queue
   reg [7:0] checky;
      reg [9:0] sort_count;//used for sorting
      reg [7:0] goalx;
      reg[7:0] goaly;
      reg done;
      
   reg [7:0]  state;//current state
   reg [7:0]  nextstate;//for utility sms this lets it know where to go next
   
   reg 	      bad;

   localparam
     INITIALIZE                  = 8'b00000000,
     INITIALIZE_ARRAY            = 8'b00000001,
     VERIFY                      = 8'b00000010,
     CHECK_DONE                  = 8'b00000011,
     QUEUE_MODS                  = 8'b00000_100,
     QUEUE_MODS_SHIFT            = 8'b00000_101,
     QUEUE_MODS_APPEND           = 8'b00000_110,
     SORT_QUEUE = 8'b00001000,
    BUBBLE_SORT = 8'b00001001,
    GET_SECOND_DISTANCE = 8'b00001010,
    COMPARE_BETTER = 8'b00001011,
    SWITCH = 8'b00001100,
    BUBBLE_NEXT = 8'b00001101,
    SORT_DONE = 8'b00001110,
    
     CREATE_NEIGHBORS            = 8'b10010000,
     RESET_NEIGHBORS             = 8'b10010001,
     GENERATE_NEIGHBORS          = 8'b10010010,
     NEIGHBOR_CHECK_LOOP         = 8'b10010011,
     CHECK_IF_IN_CLOSED          = 8'b00_100000,
     SEARCH_CLOSED_COMPARE       = 8'b00_100001,
     SEARCH_CLOSED_NEXT          = 8'b00_100010,
     SEARCH_CLOSED_DONE_FOUND    = 8'b00_100011,
     SEARCH_CLOSED_DONE_NOT_FOUND= 8'b00_100100,
     CHECK_IF_IN_OPEN            = 8'b0_1000000,
     SEARCH_OPEN_COMPARE         = 8'b0_1000001,
     SEARCH_OPEN_NEXT            = 8'b0_1000010,
     SEARCH_OPEN_DONE_FOUND      = 8'b0_1000011,
     SEARCH_OPEN_DONE_NOT_FOUND  = 8'b0_1000100,
     CHECK_IF_NEIGHBOR_IS_BETTER = 8'b10000000,
     NEIGHBOR_IS_BETTER          = 8'b11000000,
     RECONSTRUCT                 = 8'b11100000,
     DONE                        = 8'b11111100,
     ERROR                       = 8'b11111111;

   reg [39:0]  map [39:0];
   
   reg [7:0]   previousNodeX0 [39:0];
   reg [7:0]   previousNodeY0 [39:0];
   reg [7:0]   previousNodeX1 [39:0];
   reg [7:0]   previousNodeY1 [39:0];
   reg [7:0]   previousNodeX2 [39:0];
   reg [7:0]   previousNodeY2 [39:0];
   reg [7:0]   previousNodeX3 [39:0];
   reg [7:0]   previousNodeY3 [39:0];
   reg [7:0]   previousNodeX4 [39:0];
   reg [7:0]   previousNodeY4 [39:0];
   reg [7:0]   previousNodeX5 [39:0];
   reg [7:0]   previousNodeY5 [39:0];
   reg [7:0]   previousNodeX6 [39:0];
   reg [7:0]   previousNodeY6 [39:0];
   reg [7:0]   previousNodeX7 [39:0];
   reg [7:0]   previousNodeY7 [39:0];
   reg [7:0]   previousNodeX8 [39:0];
   reg [7:0]   previousNodeY8 [39:0];
   reg [7:0]   previousNodeX9 [39:0];
   reg [7:0]   previousNodeY9 [39:0];
   reg [7:0]   previousNodeX10 [39:0];
   reg [7:0]   previousNodeY10 [39:0];
   reg [7:0]   previousNodeX11 [39:0];
   reg [7:0]   previousNodeY11 [39:0];
   reg [7:0]   previousNodeX12 [39:0];
   reg [7:0]   previousNodeY12 [39:0];
   reg [7:0]   previousNodeX13 [39:0];
   reg [7:0]   previousNodeY13 [39:0];
   reg [7:0]   previousNodeX14 [39:0];
   reg [7:0]   previousNodeY14 [39:0];
   reg [7:0]   previousNodeX15 [39:0];
   reg [7:0]   previousNodeY15 [39:0];
   reg [7:0]   previousNodeX16 [39:0];
   reg [7:0]   previousNodeY16 [39:0];
   reg [7:0]   previousNodeX17 [39:0];
   reg [7:0]   previousNodeY17 [39:0];
   reg [7:0]   previousNodeX18 [39:0];
   reg [7:0]   previousNodeY18 [39:0];
   reg [7:0]   previousNodeX19 [39:0];
   reg [7:0]   previousNodeY19 [39:0];
   reg [7:0]   previousNodeX20 [39:0];
   reg [7:0]   previousNodeY20 [39:0];
   reg [7:0]   previousNodeX21 [39:0];
   reg [7:0]   previousNodeY21 [39:0];
   reg [7:0]   previousNodeX22 [39:0];
   reg [7:0]   previousNodeY22 [39:0];
   reg [7:0]   previousNodeX23 [39:0];
   reg [7:0]   previousNodeY23 [39:0];
   reg [7:0]   previousNodeX24 [39:0];
   reg [7:0]   previousNodeY24 [39:0];
   reg [7:0]   previousNodeX25 [39:0];
   reg [7:0]   previousNodeY25 [39:0];
   reg [7:0]   previousNodeX26 [39:0];
   reg [7:0]   previousNodeY26 [39:0];
   reg [7:0]   previousNodeX27 [39:0];
   reg [7:0]   previousNodeY27 [39:0];
   reg [7:0]   previousNodeX28 [39:0];
   reg [7:0]   previousNodeY28 [39:0];
   reg [7:0]   previousNodeX29 [39:0];
   reg [7:0]   previousNodeY29 [39:0];
   reg [7:0]   previousNodeX30 [39:0];
   reg [7:0]   previousNodeY30 [39:0];
   reg [7:0]   previousNodeX31 [39:0];
   reg [7:0]   previousNodeY31 [39:0];
   reg [7:0]   previousNodeX32 [39:0];
   reg [7:0]   previousNodeY32 [39:0];
   reg [7:0]   previousNodeX33 [39:0];
   reg [7:0]   previousNodeY33 [39:0];
   reg [7:0]   previousNodeX34 [39:0];
   reg [7:0]   previousNodeY34 [39:0];
   reg [7:0]   previousNodeX35 [39:0];
   reg [7:0]   previousNodeY35 [39:0];
   reg [7:0]   previousNodeX36 [39:0];
   reg [7:0]   previousNodeY36 [39:0];
   reg [7:0]   previousNodeX37 [39:0];
   reg [7:0]   previousNodeY37 [39:0];
   reg [7:0]   previousNodeX38 [39:0];
   reg [7:0]   previousNodeY38 [39:0];
   reg [7:0]   previousNodeX39 [39:0];
   reg [7:0]   previousNodeY39 [39:0];
   
   
   reg [7:0]   distanceFromStart0 [39:0];
   reg [7:0]   distanceFromStart1 [39:0];
   reg [7:0]   distanceFromStart2 [39:0];
   reg [7:0]   distanceFromStart3 [39:0];
   reg [7:0]   distanceFromStart4 [39:0];
   reg [7:0]   distanceFromStart5 [39:0];
   reg [7:0]   distanceFromStart6 [39:0];
   reg [7:0]   distanceFromStart7 [39:0];
   reg [7:0]   distanceFromStart8 [39:0];
   reg [7:0]   distanceFromStart9 [39:0];
   reg [7:0]   distanceFromStart10 [39:0];
   reg [7:0]   distanceFromStart11 [39:0];
   reg [7:0]   distanceFromStart12 [39:0];
   reg [7:0]   distanceFromStart13 [39:0];
   reg [7:0]   distanceFromStart14 [39:0];
   reg [7:0]   distanceFromStart15 [39:0];
   reg [7:0]   distanceFromStart16 [39:0];
   reg [7:0]   distanceFromStart17 [39:0];
   reg [7:0]   distanceFromStart18 [39:0];
   reg [7:0]   distanceFromStart19 [39:0];
   reg [7:0]   distanceFromStart20 [39:0];
   reg [7:0]   distanceFromStart21 [39:0];
   reg [7:0]   distanceFromStart22 [39:0];
   reg [7:0]   distanceFromStart23 [39:0];
   reg [7:0]   distanceFromStart24 [39:0];
   reg [7:0]   distanceFromStart25 [39:0];
   reg [7:0]   distanceFromStart26 [39:0];
   reg [7:0]   distanceFromStart27 [39:0];
   reg [7:0]   distanceFromStart28 [39:0];
   reg [7:0]   distanceFromStart29 [39:0];
   reg [7:0]   distanceFromStart30 [39:0];
   reg [7:0]   distanceFromStart31 [39:0];
   reg [7:0]   distanceFromStart32 [39:0];
   reg [7:0]   distanceFromStart33 [39:0];
   reg [7:0]   distanceFromStart34 [39:0];
   reg [7:0]   distanceFromStart35 [39:0];
   reg [7:0]   distanceFromStart36 [39:0];
   reg [7:0]   distanceFromStart37 [39:0];
   reg [7:0]   distanceFromStart38 [39:0];
   reg [7:0]   distanceFromStart39 [39:0];
   
   
   
   		    //COPYPASTE FROM OTHER SOURCE
		       reg [8:0] search_index; //used to iterate through reg
   reg 	    found;
   
   
   always @ (posedge sync,posedge reset)
     begin
	if(reset)
	  begin
	     state <= INITIALIZE;
	  end
	else
	  begin
	     case(state)
	       INITIALIZE:
		 begin
		 $display("STATE: INITIALIZE");
		    //STATE TRANSITION
		    state <= INITIALIZE_ARRAY;
		    //RTL
		    map[0]=40'b0;
		    map[1]=40'b0;
		    map[2]=40'b0;
		    map[3]=40'b0;
		    map[4]=40'b0;
		    map[5]=40'b0;
		    map[6]=40'b0;
		    map[7]=40'b0;
		    map[8]=40'b0;
		    map[9]=40'b0;
		    map[10]=40'b0;
		    map[11]=40'b0;
		    map[12]=40'b0;
		    map[13]=40'b0;
		    map[14]=40'b0;
		    map[15]=40'b0;
		    map[16]=40'b0;
		    map[17]=40'b0;
		    map[18]=40'b0;
		    map[19]=40'b0;
		    map[20]=40'b0;
		    map[21]=40'b0;
		    map[22]=40'b0;
		    map[23]=40'b0;
		    map[24]=40'b0;
		    map[25]=40'b0;
		    map[26]=40'b0;
		    map[27]=40'b0;
		    map[28]=40'b0;
		    map[29]=40'b0;
		    map[30]=40'b0;
		    map[31]=40'b0;
		    map[32]=40'b0;
		    map[33]=40'b0;
		    map[34]=40'b0;
		    map[35]=40'b0;
		    map[36]=40'b0;
		    map[37]=40'b0;
		    map[38]=40'b0;
		    map[39]=40'b0;
	       
		    bad = 0;
		    opencounter <= 9'b000000000;
		    closecounter <= 9'b000000000;
		    temp1 <= 32'b00000000000000000000000000000000;
		    
		    	     goalx = 8'b00100111;
	     goaly = 8'b00100111;
		    

   
		 end // case: INITIALIZE
	       INITIALIZE_ARRAY:
		 begin
		 $display("STATE: INITIALIZE ARRAY");
		    //STATE TRANSITION
		    if(temp1 == 16'b0000000110001111)
		      state <= VERIFY;

		    //RTL
		    if(temp1 <= 16'b0000000000100111)
		      begin
		        //ROY YOU BETTER CHANGE THIS SHIT
		        //shit what was i supposed to do
			 distanceFromStart0[temp1] = 8'b11111111;
			 distanceFromStart1[temp1] = 8'b11111111;
			 distanceFromStart2[temp1] = 8'b11111111;
			 distanceFromStart3[temp1] = 8'b11111111;
			 distanceFromStart4[temp1] = 8'b11111111;
			 distanceFromStart5[temp1] = 8'b11111111;
			 distanceFromStart6[temp1] = 8'b11111111;
			 distanceFromStart7[temp1] = 8'b11111111;
			 distanceFromStart8[temp1] = 8'b11111111;
			 distanceFromStart9[temp1] = 8'b11111111;
			 distanceFromStart10[temp1] = 8'b11111111;
			 distanceFromStart11[temp1] = 8'b11111111;
			 distanceFromStart12[temp1] = 8'b11111111;
			 distanceFromStart13[temp1] = 8'b11111111;
			 distanceFromStart14[temp1] = 8'b11111111;
			 distanceFromStart15[temp1] = 8'b11111111;
			 distanceFromStart16[temp1] = 8'b11111111;
			 distanceFromStart17[temp1] = 8'b11111111;
			 distanceFromStart18[temp1] = 8'b11111111;
			 distanceFromStart19[temp1] = 8'b11111111;
			 distanceFromStart20[temp1] = 8'b11111111;
			 distanceFromStart21[temp1] = 8'b11111111;
			 distanceFromStart22[temp1] = 8'b11111111;
			 distanceFromStart23[temp1] = 8'b11111111;
			 distanceFromStart24[temp1] = 8'b11111111;
			 distanceFromStart25[temp1] = 8'b11111111;
			 distanceFromStart26[temp1] = 8'b11111111;
			 distanceFromStart27[temp1] = 8'b11111111;
			 distanceFromStart28[temp1] = 8'b11111111;
			 distanceFromStart29[temp1] = 8'b11111111;
			 distanceFromStart30[temp1] = 8'b11111111;
			 distanceFromStart31[temp1] = 8'b11111111;
			 distanceFromStart32[temp1] = 8'b11111111;
			 distanceFromStart33[temp1] = 8'b11111111;
			 distanceFromStart34[temp1] = 8'b11111111;
			 distanceFromStart35[temp1] = 8'b11111111;
			 distanceFromStart36[temp1] = 8'b11111111;
			 distanceFromStart37[temp1] = 8'b11111111;
			 distanceFromStart38[temp1] = 8'b11111111;
			 distanceFromStart39[temp1] = 8'b11111111;
		 end // if (temp1 <= 16'b0000000000100111)
		 
		       
			 openx[temp1] <= 8'b11111111;
			 openy[temp1] <= 8'b11111111;
			 closex[temp1] <= 8'b11111111;
			 closey[temp1] <= 8'b11111111;
		 

distanceFromStart0[0] = 0;
		      
			 temp1 <= temp1+1;
		 end // case: INITIALIZE_ARRAY
	       VERIFY:
		 begin
		 $display("STATE: VERIFY");
		    //TRANSITION LOGIC
		    if(map[0] == 40'b0000000000000000000000000000000000000001)
		      state <= ERROR;
		    else if(map[39] == 40'b1000000000000000000000000000000000000000)
		      state <= ERROR;
		    else
		      state <= CHECK_DONE;
		    //RTL
		    openx[0] <= 8'b00000000;
		    openy[0] <= 8'b00000000;
		    opencounter <= opencounter + 1;
		 end // case: VERIFY
	       CHECK_DONE:
		 begin
		 $display("STATE: CHECK DONE");
		 $display("Open: %d,%d", openx[0],openy[0]);
		 //TRANSITION LOGIC
		    if(openx[0] == 8'b00100111 && openy[0] == 8'b00100111)
		      state <= RECONSTRUCT;
		    else if(openx[0] == 8'b11111111 && openy[0] == 8'b11111111)
		      state <= RECONSTRUCT;
		    else state <= QUEUE_MODS;
		 end // case: CHECK_DONE
	       QUEUE_MODS:
		 begin
		 $display("STATE: QUEUE MODS");
		    //STATE TRANSITION
		    state <= QUEUE_MODS_SHIFT;
		    //RTL
		    currentx <= openx[0];
		    currenty <= openy[0];
		    closex[closecounter] <= openx[0];
		    closex[closecounter] <= openy[0];
		    closecounter <= closecounter + 1;
		    temp1 <= 0; 
		 end // case: QUEUE_MODS
	       QUEUE_MODS_SHIFT:
		 begin
		 $display("STATE: QUEUE MODS SHIFT");
		    //STATE TRANSITION
		    if(temp1 == 16'b0000000110001110)//equals to 398
		      state <= QUEUE_MODS_APPEND;
		    //RTL
		    openx[temp1] <= openx[temp1+1];
		    openy[temp1] <= openy[temp1+1];
		    temp1 <= temp1 +1;
		 end // case: QUEUE_MODS_SHIFT
	       QUEUE_MODS_APPEND:
		 begin
		 $display("STATE: QUEUE MODS APPEND");
		    //STATE TRANSITION
		    state <= SORT_QUEUE;
		    //RTL
		    openx[399] <= 8'b11111111;
		    openy[399] <= 8'b11111111;
		 end // case: QUEUE_MODS_APPEND
		 
	       CREATE_NEIGHBORS:
		 begin
		 $display("STATE: CREATE NEIGHBORS");
		    //STATE TRANSITIONS
		    state <= RESET_NEIGHBORS;
		    //RTL
		    neighborcounter <= 3'b0;
		 end
	       RESET_NEIGHBORS:
		 begin
		 $display("STATE: RESET NEIGHBORS");
		    //STATE TRANSITIONS
		    if(neighborcounter == 3'b111)
		      state <= GENERATE_NEIGHBORS;
		    //RTL
		    neighborx[neighborcounter] <= 8'b11111111;
		    neighbory[neighborcounter] <= 8'b11111111;
		    tempneighborx[neighborcounter] <= 8'b11111111;
		    tempneighbory[neighborcounter] <= 8'b11111111;
		    neighborcounter <= neighborcounter + 1;
		 end // case: RESET_NEIGHBORS
	       GENERATE_NEIGHBORS:
		 begin
		 $display("STATE: GENERATE NEIGHBORS");
		    //0 - NW
		    //1 - N
		    //2 - NE
		    //3 - E
		    //4 - SE
		    //5 - S
		    //6 - SW
		    //7 - W
		    //STATE TRANSITION
		    state <= NEIGHBOR_CHECK_LOOP;
		    //RTL
		    if(currentx != 0 && currenty != 0)//NW
		      begin
			 tempneighborx[0] <= currentx-1;
			 tempneighbory[0] <= currenty-1;
		      end
		    else
		      begin
			 tempneighborx[0] <= 8'b11111111;
			 tempneighbory[0] <= 8'b11111111;
		      end
		    if(currenty != 0)//N
		      begin
			 tempneighborx[1] <= currentx;
			 tempneighbory[1] <= currenty-1;
		      end
		    else
		      begin
			 tempneighborx[1] <= 8'b11111111;
			 tempneighbory[1] <= 8'b11111111;
		      end
		    if(currentx != 8'b00100111 && currenty != 0)//NE
		      begin
			 tempneighborx[2] <= currentx + 1;
			 tempneighbory[2] <= currenty -1;
		      end
		    else
		      begin
			 tempneighborx[2] <= 8'b11111111;
			 tempneighbory[2] <= 8'b11111111;
		      end
		    if(currentx != 8'b00100111)//E
		      begin
			 tempneighborx[3] <= currentx + 1;
			 tempneighbory[3] <= currenty;
		      end
		    else
		      begin
			 tempneighborx[3] <= 8'b11111111;
			 tempneighbory[3] <= 8'b11111111;
		      end
		    if(currentx != 8'b00100111 && currenty != 8'b00100111)//SE
		      begin
			 tempneighborx[4] <= currentx + 1;
			 tempneighbory[4] <= currenty + 1;
		      end
		    else
		      begin
			 tempneighborx[4] <= 8'b11111111;
			 tempneighbory[4] <= 8'b11111111;
		      end
		    if(currenty != 8'b00100111)//S
		      begin
			 tempneighborx[5] <= currentx;
			 tempneighbory[5] <= currenty + 1;
		      end
		    else
		      begin
			 tempneighborx[5] <= 8'b11111111;
			 tempneighbory[5] <= 8'b11111111;
		      end
		    if(currentx != 8'b0 && currenty != 8'b00100111)
		      begin
			 tempneighborx[6] <= currentx -1;
			 tempneighbory[6] <= currenty + 1;
		      end
		    else
		      begin
			 tempneighborx[6] <= 8'b11111111;
			 tempneighbory[6] <= 8'b11111111;
		      end
		    if(currentx != 8'b0)//W
		      begin
			 tempneighborx[7] <= currentx - 1;
			 tempneighbory[7] <= currenty;
		      end
		    else
		      begin
			 tempneighborx[7] <= 8'b11111111;
			 tempneighbory[7] <= 8'b11111111;
		      end
		 end // case: GENERATE_NEIGHBORS
	       NEIGHBOR_CHECK_LOOP:
		 begin	   
		 $display("STATE: NEIGHBOR CHECK LOOP");
   		    if(tempneighborx[neighborcounter] != 8'b11111111 && tempneighbory[neighborcounter] != 8'b11111111 && map[tempneighbory[neighborcounter]][tempneighborx[neighborcounter]] != 1'b1)//exists and is not obstacle
		   begin
		      state <= CHECK_IF_IN_CLOSED;
		      checkx = tempneighborx[neighborcounter];
			 checky = tempneighbory[neighborcounter];
			 end
			   else
		      begin
			 if(neighborcounter == 3'b111)
			   state <= CHECK_DONE;
			   else
			     neighborcounter <= neighborcounter + 1;
		      end
		    neighbor_is_better <= 1'b0;
		  
		 end
	       
	       CHECK_IF_NEIGHBOR_IS_BETTER:
		 begin
		 $display("STATE: CHECK IF NEIGHBOR IS BETTER");
		    case(currentx)
		      
		      8'b0:
			begin
			   if((distanceFromStart0[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart0[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b1:
			begin
			   if((distanceFromStart1[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart1[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b10:
			begin
			   if((distanceFromStart2[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart2[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b11:
			begin
			   if((distanceFromStart3[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart3[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b100:
			begin
			   if((distanceFromStart4[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart4[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b101:
			begin
			   if((distanceFromStart5[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart5[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b110:
			begin
			   if((distanceFromStart6[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart6[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b111:
			begin
			   if((distanceFromStart7[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart7[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b1000:
			begin
			   if((distanceFromStart8[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart8[currentx])
			     state <= NEIGHBOR_IS_BETTER;
			   else state <= NEIGHBOR_CHECK_LOOP;
			end
		      8'b1001:
			begin
			   if((distanceFromStart9[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart9[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b1010:
		 begin
		    if((distanceFromStart10[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart10[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b1011:
		 begin
		    if((distanceFromStart11[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart11[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b1100:
		 begin
		    if((distanceFromStart12[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart12[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b1101:
		 begin
		    if((distanceFromStart13[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart13[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b1110:
		 begin
		    if((distanceFromStart14[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart14[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b1111:
		 begin
		    if((distanceFromStart15[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart15[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10000:
		 begin
		    if((distanceFromStart16[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart16[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10001:
		 begin
		    if((distanceFromStart17[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart17[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10010:
		 begin
		    if((distanceFromStart18[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart18[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10011:
		 begin
		    if((distanceFromStart19[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart19[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10100:
		 begin
		    if((distanceFromStart20[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart20[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10101:
		 begin
		    if((distanceFromStart21[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart21[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10110:
		 begin
		    if((distanceFromStart22[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart22[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b10111:
		 begin
		    if((distanceFromStart23[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart23[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11000:
		 begin
		    if((distanceFromStart24[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart24[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11001:
		 begin
		    if((distanceFromStart25[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart25[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11010:
		 begin
		    if((distanceFromStart26[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart26[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11011:
		 begin
		    if((distanceFromStart27[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart27[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11100:
		 begin
		    if((distanceFromStart28[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart28[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11101:
		 begin
		    if((distanceFromStart29[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart29[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11110:
		 begin
		    if((distanceFromStart30[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart30[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b11111:
		 begin
		    if((distanceFromStart31[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart31[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100000:
		 begin
		    if((distanceFromStart32[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart32[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100001:
		 begin
		    if((distanceFromStart33[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart33[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100010:
		 begin
		    if((distanceFromStart34[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart34[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100011:
		 begin
		    if((distanceFromStart35[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart35[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100100:
		 begin
		    if((distanceFromStart36[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart36[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100101:
		 begin
		    if((distanceFromStart37[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart37[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100110:
		 begin
		    if((distanceFromStart38[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart38[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
	       8'b100111:
		 begin
		    if((distanceFromStart39[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart39[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else state <= NEIGHBOR_CHECK_LOOP;
		 end
endcase
end

NEIGHBOR_IS_BETTER:
begin
$display("STATE: NEIGHBOR IS BETTER");
  //STATE TRANSITION
  if(neighborcounter == 3'b111)
    state <= CHECK_DONE;
  else
    begin
      		    neighborcounter <= neighborcounter + 1;
    state <= NEIGHBOR_CHECK_LOOP;
  end
    
  case(tempneighborx[neighborcounter])
    
   /* 8'b0:
    begin
      case(tempneighbory[neighborcounter])
        8'b0:
        begin
          previousNode0[0] <= currentx;
          end
          
        endcase
              end
    */
    
    
8'b0:
begin
case(tempneighborx[neighborcounter])
8'b0:
begin
previousNodeX0[0] <= currentx;
previousNodeY0[0] <= currenty;
end
8'b0:
begin
previousNodeX0[1] <= currentx;
previousNodeY0[1] <= currenty;
end
8'b0:
begin
previousNodeX0[2] <= currentx;
previousNodeY0[2] <= currenty;
end
8'b0:
begin
previousNodeX0[3] <= currentx;
previousNodeY0[3] <= currenty;
end
8'b0:
begin
previousNodeX0[4] <= currentx;
previousNodeY0[4] <= currenty;
end
8'b0:
begin
previousNodeX0[5] <= currentx;
previousNodeY0[5] <= currenty;
end
8'b0:
begin
previousNodeX0[6] <= currentx;
previousNodeY0[6] <= currenty;
end
8'b0:
begin
previousNodeX0[7] <= currentx;
previousNodeY0[7] <= currenty;
end
8'b0:
begin
previousNodeX0[8] <= currentx;
previousNodeY0[8] <= currenty;
end
8'b0:
begin
previousNodeX0[9] <= currentx;
previousNodeY0[9] <= currenty;
end
8'b0:
begin
previousNodeX0[10] <= currentx;
previousNodeY0[10] <= currenty;
end
8'b0:
begin
previousNodeX0[11] <= currentx;
previousNodeY0[11] <= currenty;
end
8'b0:
begin
previousNodeX0[12] <= currentx;
previousNodeY0[12] <= currenty;
end
8'b0:
begin
previousNodeX0[13] <= currentx;
previousNodeY0[13] <= currenty;
end
8'b0:
begin
previousNodeX0[14] <= currentx;
previousNodeY0[14] <= currenty;
end
8'b0:
begin
previousNodeX0[15] <= currentx;
previousNodeY0[15] <= currenty;
end
8'b0:
begin
previousNodeX0[16] <= currentx;
previousNodeY0[16] <= currenty;
end
8'b0:
begin
previousNodeX0[17] <= currentx;
previousNodeY0[17] <= currenty;
end
8'b0:
begin
previousNodeX0[18] <= currentx;
previousNodeY0[18] <= currenty;
end
8'b0:
begin
previousNodeX0[19] <= currentx;
previousNodeY0[19] <= currenty;
end
8'b0:
begin
previousNodeX0[20] <= currentx;
previousNodeY0[20] <= currenty;
end
8'b0:
begin
previousNodeX0[21] <= currentx;
previousNodeY0[21] <= currenty;
end
8'b0:
begin
previousNodeX0[22] <= currentx;
previousNodeY0[22] <= currenty;
end
8'b0:
begin
previousNodeX0[23] <= currentx;
previousNodeY0[23] <= currenty;
end
8'b0:
begin
previousNodeX0[24] <= currentx;
previousNodeY0[24] <= currenty;
end
8'b0:
begin
previousNodeX0[25] <= currentx;
previousNodeY0[25] <= currenty;
end
8'b0:
begin
previousNodeX0[26] <= currentx;
previousNodeY0[26] <= currenty;
end
8'b0:
begin
previousNodeX0[27] <= currentx;
previousNodeY0[27] <= currenty;
end
8'b0:
begin
previousNodeX0[28] <= currentx;
previousNodeY0[28] <= currenty;
end
8'b0:
begin
previousNodeX0[29] <= currentx;
previousNodeY0[29] <= currenty;
end
8'b0:
begin
previousNodeX0[30] <= currentx;
previousNodeY0[30] <= currenty;
end
8'b0:
begin
previousNodeX0[31] <= currentx;
previousNodeY0[31] <= currenty;
end
8'b0:
begin
previousNodeX0[32] <= currentx;
previousNodeY0[32] <= currenty;
end
8'b0:
begin
previousNodeX0[33] <= currentx;
previousNodeY0[33] <= currenty;
end
8'b0:
begin
previousNodeX0[34] <= currentx;
previousNodeY0[34] <= currenty;
end
8'b0:
begin
previousNodeX0[35] <= currentx;
previousNodeY0[35] <= currenty;
end
8'b0:
begin
previousNodeX0[36] <= currentx;
previousNodeY0[36] <= currenty;
end
8'b0:
begin
previousNodeX0[37] <= currentx;
previousNodeY0[37] <= currenty;
end
8'b0:
begin
previousNodeX0[38] <= currentx;
previousNodeY0[38] <= currenty;
end
8'b0:
begin
previousNodeX0[39] <= currentx;
previousNodeY0[39] <= currenty;
end
endcase
end
8'b1:
begin
case(tempneighborx[neighborcounter])
8'b1:
begin
previousNodeX1[0] <= currentx;
previousNodeY1[0] <= currenty;
end
8'b1:
begin
previousNodeX1[1] <= currentx;
previousNodeY1[1] <= currenty;
end
8'b1:
begin
previousNodeX1[2] <= currentx;
previousNodeY1[2] <= currenty;
end
8'b1:
begin
previousNodeX1[3] <= currentx;
previousNodeY1[3] <= currenty;
end
8'b1:
begin
previousNodeX1[4] <= currentx;
previousNodeY1[4] <= currenty;
end
8'b1:
begin
previousNodeX1[5] <= currentx;
previousNodeY1[5] <= currenty;
end
8'b1:
begin
previousNodeX1[6] <= currentx;
previousNodeY1[6] <= currenty;
end
8'b1:
begin
previousNodeX1[7] <= currentx;
previousNodeY1[7] <= currenty;
end
8'b1:
begin
previousNodeX1[8] <= currentx;
previousNodeY1[8] <= currenty;
end
8'b1:
begin
previousNodeX1[9] <= currentx;
previousNodeY1[9] <= currenty;
end
8'b1:
begin
previousNodeX1[10] <= currentx;
previousNodeY1[10] <= currenty;
end
8'b1:
begin
previousNodeX1[11] <= currentx;
previousNodeY1[11] <= currenty;
end
8'b1:
begin
previousNodeX1[12] <= currentx;
previousNodeY1[12] <= currenty;
end
8'b1:
begin
previousNodeX1[13] <= currentx;
previousNodeY1[13] <= currenty;
end
8'b1:
begin
previousNodeX1[14] <= currentx;
previousNodeY1[14] <= currenty;
end
8'b1:
begin
previousNodeX1[15] <= currentx;
previousNodeY1[15] <= currenty;
end
8'b1:
begin
previousNodeX1[16] <= currentx;
previousNodeY1[16] <= currenty;
end
8'b1:
begin
previousNodeX1[17] <= currentx;
previousNodeY1[17] <= currenty;
end
8'b1:
begin
previousNodeX1[18] <= currentx;
previousNodeY1[18] <= currenty;
end
8'b1:
begin
previousNodeX1[19] <= currentx;
previousNodeY1[19] <= currenty;
end
8'b1:
begin
previousNodeX1[20] <= currentx;
previousNodeY1[20] <= currenty;
end
8'b1:
begin
previousNodeX1[21] <= currentx;
previousNodeY1[21] <= currenty;
end
8'b1:
begin
previousNodeX1[22] <= currentx;
previousNodeY1[22] <= currenty;
end
8'b1:
begin
previousNodeX1[23] <= currentx;
previousNodeY1[23] <= currenty;
end
8'b1:
begin
previousNodeX1[24] <= currentx;
previousNodeY1[24] <= currenty;
end
8'b1:
begin
previousNodeX1[25] <= currentx;
previousNodeY1[25] <= currenty;
end
8'b1:
begin
previousNodeX1[26] <= currentx;
previousNodeY1[26] <= currenty;
end
8'b1:
begin
previousNodeX1[27] <= currentx;
previousNodeY1[27] <= currenty;
end
8'b1:
begin
previousNodeX1[28] <= currentx;
previousNodeY1[28] <= currenty;
end
8'b1:
begin
previousNodeX1[29] <= currentx;
previousNodeY1[29] <= currenty;
end
8'b1:
begin
previousNodeX1[30] <= currentx;
previousNodeY1[30] <= currenty;
end
8'b1:
begin
previousNodeX1[31] <= currentx;
previousNodeY1[31] <= currenty;
end
8'b1:
begin
previousNodeX1[32] <= currentx;
previousNodeY1[32] <= currenty;
end
8'b1:
begin
previousNodeX1[33] <= currentx;
previousNodeY1[33] <= currenty;
end
8'b1:
begin
previousNodeX1[34] <= currentx;
previousNodeY1[34] <= currenty;
end
8'b1:
begin
previousNodeX1[35] <= currentx;
previousNodeY1[35] <= currenty;
end
8'b1:
begin
previousNodeX1[36] <= currentx;
previousNodeY1[36] <= currenty;
end
8'b1:
begin
previousNodeX1[37] <= currentx;
previousNodeY1[37] <= currenty;
end
8'b1:
begin
previousNodeX1[38] <= currentx;
previousNodeY1[38] <= currenty;
end
8'b1:
begin
previousNodeX1[39] <= currentx;
previousNodeY1[39] <= currenty;
end
endcase
end
8'b10:
begin
case(tempneighborx[neighborcounter])
8'b10:
begin
previousNodeX2[0] <= currentx;
previousNodeY2[0] <= currenty;
end
8'b10:
begin
previousNodeX2[1] <= currentx;
previousNodeY2[1] <= currenty;
end
8'b10:
begin
previousNodeX2[2] <= currentx;
previousNodeY2[2] <= currenty;
end
8'b10:
begin
previousNodeX2[3] <= currentx;
previousNodeY2[3] <= currenty;
end
8'b10:
begin
previousNodeX2[4] <= currentx;
previousNodeY2[4] <= currenty;
end
8'b10:
begin
previousNodeX2[5] <= currentx;
previousNodeY2[5] <= currenty;
end
8'b10:
begin
previousNodeX2[6] <= currentx;
previousNodeY2[6] <= currenty;
end
8'b10:
begin
previousNodeX2[7] <= currentx;
previousNodeY2[7] <= currenty;
end
8'b10:
begin
previousNodeX2[8] <= currentx;
previousNodeY2[8] <= currenty;
end
8'b10:
begin
previousNodeX2[9] <= currentx;
previousNodeY2[9] <= currenty;
end
8'b10:
begin
previousNodeX2[10] <= currentx;
previousNodeY2[10] <= currenty;
end
8'b10:
begin
previousNodeX2[11] <= currentx;
previousNodeY2[11] <= currenty;
end
8'b10:
begin
previousNodeX2[12] <= currentx;
previousNodeY2[12] <= currenty;
end
8'b10:
begin
previousNodeX2[13] <= currentx;
previousNodeY2[13] <= currenty;
end
8'b10:
begin
previousNodeX2[14] <= currentx;
previousNodeY2[14] <= currenty;
end
8'b10:
begin
previousNodeX2[15] <= currentx;
previousNodeY2[15] <= currenty;
end
8'b10:
begin
previousNodeX2[16] <= currentx;
previousNodeY2[16] <= currenty;
end
8'b10:
begin
previousNodeX2[17] <= currentx;
previousNodeY2[17] <= currenty;
end
8'b10:
begin
previousNodeX2[18] <= currentx;
previousNodeY2[18] <= currenty;
end
8'b10:
begin
previousNodeX2[19] <= currentx;
previousNodeY2[19] <= currenty;
end
8'b10:
begin
previousNodeX2[20] <= currentx;
previousNodeY2[20] <= currenty;
end
8'b10:
begin
previousNodeX2[21] <= currentx;
previousNodeY2[21] <= currenty;
end
8'b10:
begin
previousNodeX2[22] <= currentx;
previousNodeY2[22] <= currenty;
end
8'b10:
begin
previousNodeX2[23] <= currentx;
previousNodeY2[23] <= currenty;
end
8'b10:
begin
previousNodeX2[24] <= currentx;
previousNodeY2[24] <= currenty;
end
8'b10:
begin
previousNodeX2[25] <= currentx;
previousNodeY2[25] <= currenty;
end
8'b10:
begin
previousNodeX2[26] <= currentx;
previousNodeY2[26] <= currenty;
end
8'b10:
begin
previousNodeX2[27] <= currentx;
previousNodeY2[27] <= currenty;
end
8'b10:
begin
previousNodeX2[28] <= currentx;
previousNodeY2[28] <= currenty;
end
8'b10:
begin
previousNodeX2[29] <= currentx;
previousNodeY2[29] <= currenty;
end
8'b10:
begin
previousNodeX2[30] <= currentx;
previousNodeY2[30] <= currenty;
end
8'b10:
begin
previousNodeX2[31] <= currentx;
previousNodeY2[31] <= currenty;
end
8'b10:
begin
previousNodeX2[32] <= currentx;
previousNodeY2[32] <= currenty;
end
8'b10:
begin
previousNodeX2[33] <= currentx;
previousNodeY2[33] <= currenty;
end
8'b10:
begin
previousNodeX2[34] <= currentx;
previousNodeY2[34] <= currenty;
end
8'b10:
begin
previousNodeX2[35] <= currentx;
previousNodeY2[35] <= currenty;
end
8'b10:
begin
previousNodeX2[36] <= currentx;
previousNodeY2[36] <= currenty;
end
8'b10:
begin
previousNodeX2[37] <= currentx;
previousNodeY2[37] <= currenty;
end
8'b10:
begin
previousNodeX2[38] <= currentx;
previousNodeY2[38] <= currenty;
end
8'b10:
begin
previousNodeX2[39] <= currentx;
previousNodeY2[39] <= currenty;
end
endcase
end
8'b11:
begin
case(tempneighborx[neighborcounter])
8'b11:
begin
previousNodeX3[0] <= currentx;
previousNodeY3[0] <= currenty;
end
8'b11:
begin
previousNodeX3[1] <= currentx;
previousNodeY3[1] <= currenty;
end
8'b11:
begin
previousNodeX3[2] <= currentx;
previousNodeY3[2] <= currenty;
end
8'b11:
begin
previousNodeX3[3] <= currentx;
previousNodeY3[3] <= currenty;
end
8'b11:
begin
previousNodeX3[4] <= currentx;
previousNodeY3[4] <= currenty;
end
8'b11:
begin
previousNodeX3[5] <= currentx;
previousNodeY3[5] <= currenty;
end
8'b11:
begin
previousNodeX3[6] <= currentx;
previousNodeY3[6] <= currenty;
end
8'b11:
begin
previousNodeX3[7] <= currentx;
previousNodeY3[7] <= currenty;
end
8'b11:
begin
previousNodeX3[8] <= currentx;
previousNodeY3[8] <= currenty;
end
8'b11:
begin
previousNodeX3[9] <= currentx;
previousNodeY3[9] <= currenty;
end
8'b11:
begin
previousNodeX3[10] <= currentx;
previousNodeY3[10] <= currenty;
end
8'b11:
begin
previousNodeX3[11] <= currentx;
previousNodeY3[11] <= currenty;
end
8'b11:
begin
previousNodeX3[12] <= currentx;
previousNodeY3[12] <= currenty;
end
8'b11:
begin
previousNodeX3[13] <= currentx;
previousNodeY3[13] <= currenty;
end
8'b11:
begin
previousNodeX3[14] <= currentx;
previousNodeY3[14] <= currenty;
end
8'b11:
begin
previousNodeX3[15] <= currentx;
previousNodeY3[15] <= currenty;
end
8'b11:
begin
previousNodeX3[16] <= currentx;
previousNodeY3[16] <= currenty;
end
8'b11:
begin
previousNodeX3[17] <= currentx;
previousNodeY3[17] <= currenty;
end
8'b11:
begin
previousNodeX3[18] <= currentx;
previousNodeY3[18] <= currenty;
end
8'b11:
begin
previousNodeX3[19] <= currentx;
previousNodeY3[19] <= currenty;
end
8'b11:
begin
previousNodeX3[20] <= currentx;
previousNodeY3[20] <= currenty;
end
8'b11:
begin
previousNodeX3[21] <= currentx;
previousNodeY3[21] <= currenty;
end
8'b11:
begin
previousNodeX3[22] <= currentx;
previousNodeY3[22] <= currenty;
end
8'b11:
begin
previousNodeX3[23] <= currentx;
previousNodeY3[23] <= currenty;
end
8'b11:
begin
previousNodeX3[24] <= currentx;
previousNodeY3[24] <= currenty;
end
8'b11:
begin
previousNodeX3[25] <= currentx;
previousNodeY3[25] <= currenty;
end
8'b11:
begin
previousNodeX3[26] <= currentx;
previousNodeY3[26] <= currenty;
end
8'b11:
begin
previousNodeX3[27] <= currentx;
previousNodeY3[27] <= currenty;
end
8'b11:
begin
previousNodeX3[28] <= currentx;
previousNodeY3[28] <= currenty;
end
8'b11:
begin
previousNodeX3[29] <= currentx;
previousNodeY3[29] <= currenty;
end
8'b11:
begin
previousNodeX3[30] <= currentx;
previousNodeY3[30] <= currenty;
end
8'b11:
begin
previousNodeX3[31] <= currentx;
previousNodeY3[31] <= currenty;
end
8'b11:
begin
previousNodeX3[32] <= currentx;
previousNodeY3[32] <= currenty;
end
8'b11:
begin
previousNodeX3[33] <= currentx;
previousNodeY3[33] <= currenty;
end
8'b11:
begin
previousNodeX3[34] <= currentx;
previousNodeY3[34] <= currenty;
end
8'b11:
begin
previousNodeX3[35] <= currentx;
previousNodeY3[35] <= currenty;
end
8'b11:
begin
previousNodeX3[36] <= currentx;
previousNodeY3[36] <= currenty;
end
8'b11:
begin
previousNodeX3[37] <= currentx;
previousNodeY3[37] <= currenty;
end
8'b11:
begin
previousNodeX3[38] <= currentx;
previousNodeY3[38] <= currenty;
end
8'b11:
begin
previousNodeX3[39] <= currentx;
previousNodeY3[39] <= currenty;
end
endcase
end
8'b100:
begin
case(tempneighborx[neighborcounter])
8'b100:
begin
previousNodeX4[0] <= currentx;
previousNodeY4[0] <= currenty;
end
8'b100:
begin
previousNodeX4[1] <= currentx;
previousNodeY4[1] <= currenty;
end
8'b100:
begin
previousNodeX4[2] <= currentx;
previousNodeY4[2] <= currenty;
end
8'b100:
begin
previousNodeX4[3] <= currentx;
previousNodeY4[3] <= currenty;
end
8'b100:
begin
previousNodeX4[4] <= currentx;
previousNodeY4[4] <= currenty;
end
8'b100:
begin
previousNodeX4[5] <= currentx;
previousNodeY4[5] <= currenty;
end
8'b100:
begin
previousNodeX4[6] <= currentx;
previousNodeY4[6] <= currenty;
end
8'b100:
begin
previousNodeX4[7] <= currentx;
previousNodeY4[7] <= currenty;
end
8'b100:
begin
previousNodeX4[8] <= currentx;
previousNodeY4[8] <= currenty;
end
8'b100:
begin
previousNodeX4[9] <= currentx;
previousNodeY4[9] <= currenty;
end
8'b100:
begin
previousNodeX4[10] <= currentx;
previousNodeY4[10] <= currenty;
end
8'b100:
begin
previousNodeX4[11] <= currentx;
previousNodeY4[11] <= currenty;
end
8'b100:
begin
previousNodeX4[12] <= currentx;
previousNodeY4[12] <= currenty;
end
8'b100:
begin
previousNodeX4[13] <= currentx;
previousNodeY4[13] <= currenty;
end
8'b100:
begin
previousNodeX4[14] <= currentx;
previousNodeY4[14] <= currenty;
end
8'b100:
begin
previousNodeX4[15] <= currentx;
previousNodeY4[15] <= currenty;
end
8'b100:
begin
previousNodeX4[16] <= currentx;
previousNodeY4[16] <= currenty;
end
8'b100:
begin
previousNodeX4[17] <= currentx;
previousNodeY4[17] <= currenty;
end
8'b100:
begin
previousNodeX4[18] <= currentx;
previousNodeY4[18] <= currenty;
end
8'b100:
begin
previousNodeX4[19] <= currentx;
previousNodeY4[19] <= currenty;
end
8'b100:
begin
previousNodeX4[20] <= currentx;
previousNodeY4[20] <= currenty;
end
8'b100:
begin
previousNodeX4[21] <= currentx;
previousNodeY4[21] <= currenty;
end
8'b100:
begin
previousNodeX4[22] <= currentx;
previousNodeY4[22] <= currenty;
end
8'b100:
begin
previousNodeX4[23] <= currentx;
previousNodeY4[23] <= currenty;
end
8'b100:
begin
previousNodeX4[24] <= currentx;
previousNodeY4[24] <= currenty;
end
8'b100:
begin
previousNodeX4[25] <= currentx;
previousNodeY4[25] <= currenty;
end
8'b100:
begin
previousNodeX4[26] <= currentx;
previousNodeY4[26] <= currenty;
end
8'b100:
begin
previousNodeX4[27] <= currentx;
previousNodeY4[27] <= currenty;
end
8'b100:
begin
previousNodeX4[28] <= currentx;
previousNodeY4[28] <= currenty;
end
8'b100:
begin
previousNodeX4[29] <= currentx;
previousNodeY4[29] <= currenty;
end
8'b100:
begin
previousNodeX4[30] <= currentx;
previousNodeY4[30] <= currenty;
end
8'b100:
begin
previousNodeX4[31] <= currentx;
previousNodeY4[31] <= currenty;
end
8'b100:
begin
previousNodeX4[32] <= currentx;
previousNodeY4[32] <= currenty;
end
8'b100:
begin
previousNodeX4[33] <= currentx;
previousNodeY4[33] <= currenty;
end
8'b100:
begin
previousNodeX4[34] <= currentx;
previousNodeY4[34] <= currenty;
end
8'b100:
begin
previousNodeX4[35] <= currentx;
previousNodeY4[35] <= currenty;
end
8'b100:
begin
previousNodeX4[36] <= currentx;
previousNodeY4[36] <= currenty;
end
8'b100:
begin
previousNodeX4[37] <= currentx;
previousNodeY4[37] <= currenty;
end
8'b100:
begin
previousNodeX4[38] <= currentx;
previousNodeY4[38] <= currenty;
end
8'b100:
begin
previousNodeX4[39] <= currentx;
previousNodeY4[39] <= currenty;
end
endcase
end
8'b101:
begin
case(tempneighborx[neighborcounter])
8'b101:
begin
previousNodeX5[0] <= currentx;
previousNodeY5[0] <= currenty;
end
8'b101:
begin
previousNodeX5[1] <= currentx;
previousNodeY5[1] <= currenty;
end
8'b101:
begin
previousNodeX5[2] <= currentx;
previousNodeY5[2] <= currenty;
end
8'b101:
begin
previousNodeX5[3] <= currentx;
previousNodeY5[3] <= currenty;
end
8'b101:
begin
previousNodeX5[4] <= currentx;
previousNodeY5[4] <= currenty;
end
8'b101:
begin
previousNodeX5[5] <= currentx;
previousNodeY5[5] <= currenty;
end
8'b101:
begin
previousNodeX5[6] <= currentx;
previousNodeY5[6] <= currenty;
end
8'b101:
begin
previousNodeX5[7] <= currentx;
previousNodeY5[7] <= currenty;
end
8'b101:
begin
previousNodeX5[8] <= currentx;
previousNodeY5[8] <= currenty;
end
8'b101:
begin
previousNodeX5[9] <= currentx;
previousNodeY5[9] <= currenty;
end
8'b101:
begin
previousNodeX5[10] <= currentx;
previousNodeY5[10] <= currenty;
end
8'b101:
begin
previousNodeX5[11] <= currentx;
previousNodeY5[11] <= currenty;
end
8'b101:
begin
previousNodeX5[12] <= currentx;
previousNodeY5[12] <= currenty;
end
8'b101:
begin
previousNodeX5[13] <= currentx;
previousNodeY5[13] <= currenty;
end
8'b101:
begin
previousNodeX5[14] <= currentx;
previousNodeY5[14] <= currenty;
end
8'b101:
begin
previousNodeX5[15] <= currentx;
previousNodeY5[15] <= currenty;
end
8'b101:
begin
previousNodeX5[16] <= currentx;
previousNodeY5[16] <= currenty;
end
8'b101:
begin
previousNodeX5[17] <= currentx;
previousNodeY5[17] <= currenty;
end
8'b101:
begin
previousNodeX5[18] <= currentx;
previousNodeY5[18] <= currenty;
end
8'b101:
begin
previousNodeX5[19] <= currentx;
previousNodeY5[19] <= currenty;
end
8'b101:
begin
previousNodeX5[20] <= currentx;
previousNodeY5[20] <= currenty;
end
8'b101:
begin
previousNodeX5[21] <= currentx;
previousNodeY5[21] <= currenty;
end
8'b101:
begin
previousNodeX5[22] <= currentx;
previousNodeY5[22] <= currenty;
end
8'b101:
begin
previousNodeX5[23] <= currentx;
previousNodeY5[23] <= currenty;
end
8'b101:
begin
previousNodeX5[24] <= currentx;
previousNodeY5[24] <= currenty;
end
8'b101:
begin
previousNodeX5[25] <= currentx;
previousNodeY5[25] <= currenty;
end
8'b101:
begin
previousNodeX5[26] <= currentx;
previousNodeY5[26] <= currenty;
end
8'b101:
begin
previousNodeX5[27] <= currentx;
previousNodeY5[27] <= currenty;
end
8'b101:
begin
previousNodeX5[28] <= currentx;
previousNodeY5[28] <= currenty;
end
8'b101:
begin
previousNodeX5[29] <= currentx;
previousNodeY5[29] <= currenty;
end
8'b101:
begin
previousNodeX5[30] <= currentx;
previousNodeY5[30] <= currenty;
end
8'b101:
begin
previousNodeX5[31] <= currentx;
previousNodeY5[31] <= currenty;
end
8'b101:
begin
previousNodeX5[32] <= currentx;
previousNodeY5[32] <= currenty;
end
8'b101:
begin
previousNodeX5[33] <= currentx;
previousNodeY5[33] <= currenty;
end
8'b101:
begin
previousNodeX5[34] <= currentx;
previousNodeY5[34] <= currenty;
end
8'b101:
begin
previousNodeX5[35] <= currentx;
previousNodeY5[35] <= currenty;
end
8'b101:
begin
previousNodeX5[36] <= currentx;
previousNodeY5[36] <= currenty;
end
8'b101:
begin
previousNodeX5[37] <= currentx;
previousNodeY5[37] <= currenty;
end
8'b101:
begin
previousNodeX5[38] <= currentx;
previousNodeY5[38] <= currenty;
end
8'b101:
begin
previousNodeX5[39] <= currentx;
previousNodeY5[39] <= currenty;
end
endcase
end
8'b110:
begin
case(tempneighborx[neighborcounter])
8'b110:
begin
previousNodeX6[0] <= currentx;
previousNodeY6[0] <= currenty;
end
8'b110:
begin
previousNodeX6[1] <= currentx;
previousNodeY6[1] <= currenty;
end
8'b110:
begin
previousNodeX6[2] <= currentx;
previousNodeY6[2] <= currenty;
end
8'b110:
begin
previousNodeX6[3] <= currentx;
previousNodeY6[3] <= currenty;
end
8'b110:
begin
previousNodeX6[4] <= currentx;
previousNodeY6[4] <= currenty;
end
8'b110:
begin
previousNodeX6[5] <= currentx;
previousNodeY6[5] <= currenty;
end
8'b110:
begin
previousNodeX6[6] <= currentx;
previousNodeY6[6] <= currenty;
end
8'b110:
begin
previousNodeX6[7] <= currentx;
previousNodeY6[7] <= currenty;
end
8'b110:
begin
previousNodeX6[8] <= currentx;
previousNodeY6[8] <= currenty;
end
8'b110:
begin
previousNodeX6[9] <= currentx;
previousNodeY6[9] <= currenty;
end
8'b110:
begin
previousNodeX6[10] <= currentx;
previousNodeY6[10] <= currenty;
end
8'b110:
begin
previousNodeX6[11] <= currentx;
previousNodeY6[11] <= currenty;
end
8'b110:
begin
previousNodeX6[12] <= currentx;
previousNodeY6[12] <= currenty;
end
8'b110:
begin
previousNodeX6[13] <= currentx;
previousNodeY6[13] <= currenty;
end
8'b110:
begin
previousNodeX6[14] <= currentx;
previousNodeY6[14] <= currenty;
end
8'b110:
begin
previousNodeX6[15] <= currentx;
previousNodeY6[15] <= currenty;
end
8'b110:
begin
previousNodeX6[16] <= currentx;
previousNodeY6[16] <= currenty;
end
8'b110:
begin
previousNodeX6[17] <= currentx;
previousNodeY6[17] <= currenty;
end
8'b110:
begin
previousNodeX6[18] <= currentx;
previousNodeY6[18] <= currenty;
end
8'b110:
begin
previousNodeX6[19] <= currentx;
previousNodeY6[19] <= currenty;
end
8'b110:
begin
previousNodeX6[20] <= currentx;
previousNodeY6[20] <= currenty;
end
8'b110:
begin
previousNodeX6[21] <= currentx;
previousNodeY6[21] <= currenty;
end
8'b110:
begin
previousNodeX6[22] <= currentx;
previousNodeY6[22] <= currenty;
end
8'b110:
begin
previousNodeX6[23] <= currentx;
previousNodeY6[23] <= currenty;
end
8'b110:
begin
previousNodeX6[24] <= currentx;
previousNodeY6[24] <= currenty;
end
8'b110:
begin
previousNodeX6[25] <= currentx;
previousNodeY6[25] <= currenty;
end
8'b110:
begin
previousNodeX6[26] <= currentx;
previousNodeY6[26] <= currenty;
end
8'b110:
begin
previousNodeX6[27] <= currentx;
previousNodeY6[27] <= currenty;
end
8'b110:
begin
previousNodeX6[28] <= currentx;
previousNodeY6[28] <= currenty;
end
8'b110:
begin
previousNodeX6[29] <= currentx;
previousNodeY6[29] <= currenty;
end
8'b110:
begin
previousNodeX6[30] <= currentx;
previousNodeY6[30] <= currenty;
end
8'b110:
begin
previousNodeX6[31] <= currentx;
previousNodeY6[31] <= currenty;
end
8'b110:
begin
previousNodeX6[32] <= currentx;
previousNodeY6[32] <= currenty;
end
8'b110:
begin
previousNodeX6[33] <= currentx;
previousNodeY6[33] <= currenty;
end
8'b110:
begin
previousNodeX6[34] <= currentx;
previousNodeY6[34] <= currenty;
end
8'b110:
begin
previousNodeX6[35] <= currentx;
previousNodeY6[35] <= currenty;
end
8'b110:
begin
previousNodeX6[36] <= currentx;
previousNodeY6[36] <= currenty;
end
8'b110:
begin
previousNodeX6[37] <= currentx;
previousNodeY6[37] <= currenty;
end
8'b110:
begin
previousNodeX6[38] <= currentx;
previousNodeY6[38] <= currenty;
end
8'b110:
begin
previousNodeX6[39] <= currentx;
previousNodeY6[39] <= currenty;
end
endcase
end
8'b111:
begin
case(tempneighborx[neighborcounter])
8'b111:
begin
previousNodeX7[0] <= currentx;
previousNodeY7[0] <= currenty;
end
8'b111:
begin
previousNodeX7[1] <= currentx;
previousNodeY7[1] <= currenty;
end
8'b111:
begin
previousNodeX7[2] <= currentx;
previousNodeY7[2] <= currenty;
end
8'b111:
begin
previousNodeX7[3] <= currentx;
previousNodeY7[3] <= currenty;
end
8'b111:
begin
previousNodeX7[4] <= currentx;
previousNodeY7[4] <= currenty;
end
8'b111:
begin
previousNodeX7[5] <= currentx;
previousNodeY7[5] <= currenty;
end
8'b111:
begin
previousNodeX7[6] <= currentx;
previousNodeY7[6] <= currenty;
end
8'b111:
begin
previousNodeX7[7] <= currentx;
previousNodeY7[7] <= currenty;
end
8'b111:
begin
previousNodeX7[8] <= currentx;
previousNodeY7[8] <= currenty;
end
8'b111:
begin
previousNodeX7[9] <= currentx;
previousNodeY7[9] <= currenty;
end
8'b111:
begin
previousNodeX7[10] <= currentx;
previousNodeY7[10] <= currenty;
end
8'b111:
begin
previousNodeX7[11] <= currentx;
previousNodeY7[11] <= currenty;
end
8'b111:
begin
previousNodeX7[12] <= currentx;
previousNodeY7[12] <= currenty;
end
8'b111:
begin
previousNodeX7[13] <= currentx;
previousNodeY7[13] <= currenty;
end
8'b111:
begin
previousNodeX7[14] <= currentx;
previousNodeY7[14] <= currenty;
end
8'b111:
begin
previousNodeX7[15] <= currentx;
previousNodeY7[15] <= currenty;
end
8'b111:
begin
previousNodeX7[16] <= currentx;
previousNodeY7[16] <= currenty;
end
8'b111:
begin
previousNodeX7[17] <= currentx;
previousNodeY7[17] <= currenty;
end
8'b111:
begin
previousNodeX7[18] <= currentx;
previousNodeY7[18] <= currenty;
end
8'b111:
begin
previousNodeX7[19] <= currentx;
previousNodeY7[19] <= currenty;
end
8'b111:
begin
previousNodeX7[20] <= currentx;
previousNodeY7[20] <= currenty;
end
8'b111:
begin
previousNodeX7[21] <= currentx;
previousNodeY7[21] <= currenty;
end
8'b111:
begin
previousNodeX7[22] <= currentx;
previousNodeY7[22] <= currenty;
end
8'b111:
begin
previousNodeX7[23] <= currentx;
previousNodeY7[23] <= currenty;
end
8'b111:
begin
previousNodeX7[24] <= currentx;
previousNodeY7[24] <= currenty;
end
8'b111:
begin
previousNodeX7[25] <= currentx;
previousNodeY7[25] <= currenty;
end
8'b111:
begin
previousNodeX7[26] <= currentx;
previousNodeY7[26] <= currenty;
end
8'b111:
begin
previousNodeX7[27] <= currentx;
previousNodeY7[27] <= currenty;
end
8'b111:
begin
previousNodeX7[28] <= currentx;
previousNodeY7[28] <= currenty;
end
8'b111:
begin
previousNodeX7[29] <= currentx;
previousNodeY7[29] <= currenty;
end
8'b111:
begin
previousNodeX7[30] <= currentx;
previousNodeY7[30] <= currenty;
end
8'b111:
begin
previousNodeX7[31] <= currentx;
previousNodeY7[31] <= currenty;
end
8'b111:
begin
previousNodeX7[32] <= currentx;
previousNodeY7[32] <= currenty;
end
8'b111:
begin
previousNodeX7[33] <= currentx;
previousNodeY7[33] <= currenty;
end
8'b111:
begin
previousNodeX7[34] <= currentx;
previousNodeY7[34] <= currenty;
end
8'b111:
begin
previousNodeX7[35] <= currentx;
previousNodeY7[35] <= currenty;
end
8'b111:
begin
previousNodeX7[36] <= currentx;
previousNodeY7[36] <= currenty;
end
8'b111:
begin
previousNodeX7[37] <= currentx;
previousNodeY7[37] <= currenty;
end
8'b111:
begin
previousNodeX7[38] <= currentx;
previousNodeY7[38] <= currenty;
end
8'b111:
begin
previousNodeX7[39] <= currentx;
previousNodeY7[39] <= currenty;
end
endcase
end
8'b1000:
begin
case(tempneighborx[neighborcounter])
8'b1000:
begin
previousNodeX8[0] <= currentx;
previousNodeY8[0] <= currenty;
end
8'b1000:
begin
previousNodeX8[1] <= currentx;
previousNodeY8[1] <= currenty;
end
8'b1000:
begin
previousNodeX8[2] <= currentx;
previousNodeY8[2] <= currenty;
end
8'b1000:
begin
previousNodeX8[3] <= currentx;
previousNodeY8[3] <= currenty;
end
8'b1000:
begin
previousNodeX8[4] <= currentx;
previousNodeY8[4] <= currenty;
end
8'b1000:
begin
previousNodeX8[5] <= currentx;
previousNodeY8[5] <= currenty;
end
8'b1000:
begin
previousNodeX8[6] <= currentx;
previousNodeY8[6] <= currenty;
end
8'b1000:
begin
previousNodeX8[7] <= currentx;
previousNodeY8[7] <= currenty;
end
8'b1000:
begin
previousNodeX8[8] <= currentx;
previousNodeY8[8] <= currenty;
end
8'b1000:
begin
previousNodeX8[9] <= currentx;
previousNodeY8[9] <= currenty;
end
8'b1000:
begin
previousNodeX8[10] <= currentx;
previousNodeY8[10] <= currenty;
end
8'b1000:
begin
previousNodeX8[11] <= currentx;
previousNodeY8[11] <= currenty;
end
8'b1000:
begin
previousNodeX8[12] <= currentx;
previousNodeY8[12] <= currenty;
end
8'b1000:
begin
previousNodeX8[13] <= currentx;
previousNodeY8[13] <= currenty;
end
8'b1000:
begin
previousNodeX8[14] <= currentx;
previousNodeY8[14] <= currenty;
end
8'b1000:
begin
previousNodeX8[15] <= currentx;
previousNodeY8[15] <= currenty;
end
8'b1000:
begin
previousNodeX8[16] <= currentx;
previousNodeY8[16] <= currenty;
end
8'b1000:
begin
previousNodeX8[17] <= currentx;
previousNodeY8[17] <= currenty;
end
8'b1000:
begin
previousNodeX8[18] <= currentx;
previousNodeY8[18] <= currenty;
end
8'b1000:
begin
previousNodeX8[19] <= currentx;
previousNodeY8[19] <= currenty;
end
8'b1000:
begin
previousNodeX8[20] <= currentx;
previousNodeY8[20] <= currenty;
end
8'b1000:
begin
previousNodeX8[21] <= currentx;
previousNodeY8[21] <= currenty;
end
8'b1000:
begin
previousNodeX8[22] <= currentx;
previousNodeY8[22] <= currenty;
end
8'b1000:
begin
previousNodeX8[23] <= currentx;
previousNodeY8[23] <= currenty;
end
8'b1000:
begin
previousNodeX8[24] <= currentx;
previousNodeY8[24] <= currenty;
end
8'b1000:
begin
previousNodeX8[25] <= currentx;
previousNodeY8[25] <= currenty;
end
8'b1000:
begin
previousNodeX8[26] <= currentx;
previousNodeY8[26] <= currenty;
end
8'b1000:
begin
previousNodeX8[27] <= currentx;
previousNodeY8[27] <= currenty;
end
8'b1000:
begin
previousNodeX8[28] <= currentx;
previousNodeY8[28] <= currenty;
end
8'b1000:
begin
previousNodeX8[29] <= currentx;
previousNodeY8[29] <= currenty;
end
8'b1000:
begin
previousNodeX8[30] <= currentx;
previousNodeY8[30] <= currenty;
end
8'b1000:
begin
previousNodeX8[31] <= currentx;
previousNodeY8[31] <= currenty;
end
8'b1000:
begin
previousNodeX8[32] <= currentx;
previousNodeY8[32] <= currenty;
end
8'b1000:
begin
previousNodeX8[33] <= currentx;
previousNodeY8[33] <= currenty;
end
8'b1000:
begin
previousNodeX8[34] <= currentx;
previousNodeY8[34] <= currenty;
end
8'b1000:
begin
previousNodeX8[35] <= currentx;
previousNodeY8[35] <= currenty;
end
8'b1000:
begin
previousNodeX8[36] <= currentx;
previousNodeY8[36] <= currenty;
end
8'b1000:
begin
previousNodeX8[37] <= currentx;
previousNodeY8[37] <= currenty;
end
8'b1000:
begin
previousNodeX8[38] <= currentx;
previousNodeY8[38] <= currenty;
end
8'b1000:
begin
previousNodeX8[39] <= currentx;
previousNodeY8[39] <= currenty;
end
endcase
end
8'b1001:
begin
case(tempneighborx[neighborcounter])
8'b1001:
begin
previousNodeX9[0] <= currentx;
previousNodeY9[0] <= currenty;
end
8'b1001:
begin
previousNodeX9[1] <= currentx;
previousNodeY9[1] <= currenty;
end
8'b1001:
begin
previousNodeX9[2] <= currentx;
previousNodeY9[2] <= currenty;
end
8'b1001:
begin
previousNodeX9[3] <= currentx;
previousNodeY9[3] <= currenty;
end
8'b1001:
begin
previousNodeX9[4] <= currentx;
previousNodeY9[4] <= currenty;
end
8'b1001:
begin
previousNodeX9[5] <= currentx;
previousNodeY9[5] <= currenty;
end
8'b1001:
begin
previousNodeX9[6] <= currentx;
previousNodeY9[6] <= currenty;
end
8'b1001:
begin
previousNodeX9[7] <= currentx;
previousNodeY9[7] <= currenty;
end
8'b1001:
begin
previousNodeX9[8] <= currentx;
previousNodeY9[8] <= currenty;
end
8'b1001:
begin
previousNodeX9[9] <= currentx;
previousNodeY9[9] <= currenty;
end
8'b1001:
begin
previousNodeX9[10] <= currentx;
previousNodeY9[10] <= currenty;
end
8'b1001:
begin
previousNodeX9[11] <= currentx;
previousNodeY9[11] <= currenty;
end
8'b1001:
begin
previousNodeX9[12] <= currentx;
previousNodeY9[12] <= currenty;
end
8'b1001:
begin
previousNodeX9[13] <= currentx;
previousNodeY9[13] <= currenty;
end
8'b1001:
begin
previousNodeX9[14] <= currentx;
previousNodeY9[14] <= currenty;
end
8'b1001:
begin
previousNodeX9[15] <= currentx;
previousNodeY9[15] <= currenty;
end
8'b1001:
begin
previousNodeX9[16] <= currentx;
previousNodeY9[16] <= currenty;
end
8'b1001:
begin
previousNodeX9[17] <= currentx;
previousNodeY9[17] <= currenty;
end
8'b1001:
begin
previousNodeX9[18] <= currentx;
previousNodeY9[18] <= currenty;
end
8'b1001:
begin
previousNodeX9[19] <= currentx;
previousNodeY9[19] <= currenty;
end
8'b1001:
begin
previousNodeX9[20] <= currentx;
previousNodeY9[20] <= currenty;
end
8'b1001:
begin
previousNodeX9[21] <= currentx;
previousNodeY9[21] <= currenty;
end
8'b1001:
begin
previousNodeX9[22] <= currentx;
previousNodeY9[22] <= currenty;
end
8'b1001:
begin
previousNodeX9[23] <= currentx;
previousNodeY9[23] <= currenty;
end
8'b1001:
begin
previousNodeX9[24] <= currentx;
previousNodeY9[24] <= currenty;
end
8'b1001:
begin
previousNodeX9[25] <= currentx;
previousNodeY9[25] <= currenty;
end
8'b1001:
begin
previousNodeX9[26] <= currentx;
previousNodeY9[26] <= currenty;
end
8'b1001:
begin
previousNodeX9[27] <= currentx;
previousNodeY9[27] <= currenty;
end
8'b1001:
begin
previousNodeX9[28] <= currentx;
previousNodeY9[28] <= currenty;
end
8'b1001:
begin
previousNodeX9[29] <= currentx;
previousNodeY9[29] <= currenty;
end
8'b1001:
begin
previousNodeX9[30] <= currentx;
previousNodeY9[30] <= currenty;
end
8'b1001:
begin
previousNodeX9[31] <= currentx;
previousNodeY9[31] <= currenty;
end
8'b1001:
begin
previousNodeX9[32] <= currentx;
previousNodeY9[32] <= currenty;
end
8'b1001:
begin
previousNodeX9[33] <= currentx;
previousNodeY9[33] <= currenty;
end
8'b1001:
begin
previousNodeX9[34] <= currentx;
previousNodeY9[34] <= currenty;
end
8'b1001:
begin
previousNodeX9[35] <= currentx;
previousNodeY9[35] <= currenty;
end
8'b1001:
begin
previousNodeX9[36] <= currentx;
previousNodeY9[36] <= currenty;
end
8'b1001:
begin
previousNodeX9[37] <= currentx;
previousNodeY9[37] <= currenty;
end
8'b1001:
begin
previousNodeX9[38] <= currentx;
previousNodeY9[38] <= currenty;
end
8'b1001:
begin
previousNodeX9[39] <= currentx;
previousNodeY9[39] <= currenty;
end
endcase
end
8'b1010:
begin
case(tempneighborx[neighborcounter])
8'b1010:
begin
previousNodeX10[0] <= currentx;
previousNodeY10[0] <= currenty;
end
8'b1010:
begin
previousNodeX10[1] <= currentx;
previousNodeY10[1] <= currenty;
end
8'b1010:
begin
previousNodeX10[2] <= currentx;
previousNodeY10[2] <= currenty;
end
8'b1010:
begin
previousNodeX10[3] <= currentx;
previousNodeY10[3] <= currenty;
end
8'b1010:
begin
previousNodeX10[4] <= currentx;
previousNodeY10[4] <= currenty;
end
8'b1010:
begin
previousNodeX10[5] <= currentx;
previousNodeY10[5] <= currenty;
end
8'b1010:
begin
previousNodeX10[6] <= currentx;
previousNodeY10[6] <= currenty;
end
8'b1010:
begin
previousNodeX10[7] <= currentx;
previousNodeY10[7] <= currenty;
end
8'b1010:
begin
previousNodeX10[8] <= currentx;
previousNodeY10[8] <= currenty;
end
8'b1010:
begin
previousNodeX10[9] <= currentx;
previousNodeY10[9] <= currenty;
end
8'b1010:
begin
previousNodeX10[10] <= currentx;
previousNodeY10[10] <= currenty;
end
8'b1010:
begin
previousNodeX10[11] <= currentx;
previousNodeY10[11] <= currenty;
end
8'b1010:
begin
previousNodeX10[12] <= currentx;
previousNodeY10[12] <= currenty;
end
8'b1010:
begin
previousNodeX10[13] <= currentx;
previousNodeY10[13] <= currenty;
end
8'b1010:
begin
previousNodeX10[14] <= currentx;
previousNodeY10[14] <= currenty;
end
8'b1010:
begin
previousNodeX10[15] <= currentx;
previousNodeY10[15] <= currenty;
end
8'b1010:
begin
previousNodeX10[16] <= currentx;
previousNodeY10[16] <= currenty;
end
8'b1010:
begin
previousNodeX10[17] <= currentx;
previousNodeY10[17] <= currenty;
end
8'b1010:
begin
previousNodeX10[18] <= currentx;
previousNodeY10[18] <= currenty;
end
8'b1010:
begin
previousNodeX10[19] <= currentx;
previousNodeY10[19] <= currenty;
end
8'b1010:
begin
previousNodeX10[20] <= currentx;
previousNodeY10[20] <= currenty;
end
8'b1010:
begin
previousNodeX10[21] <= currentx;
previousNodeY10[21] <= currenty;
end
8'b1010:
begin
previousNodeX10[22] <= currentx;
previousNodeY10[22] <= currenty;
end
8'b1010:
begin
previousNodeX10[23] <= currentx;
previousNodeY10[23] <= currenty;
end
8'b1010:
begin
previousNodeX10[24] <= currentx;
previousNodeY10[24] <= currenty;
end
8'b1010:
begin
previousNodeX10[25] <= currentx;
previousNodeY10[25] <= currenty;
end
8'b1010:
begin
previousNodeX10[26] <= currentx;
previousNodeY10[26] <= currenty;
end
8'b1010:
begin
previousNodeX10[27] <= currentx;
previousNodeY10[27] <= currenty;
end
8'b1010:
begin
previousNodeX10[28] <= currentx;
previousNodeY10[28] <= currenty;
end
8'b1010:
begin
previousNodeX10[29] <= currentx;
previousNodeY10[29] <= currenty;
end
8'b1010:
begin
previousNodeX10[30] <= currentx;
previousNodeY10[30] <= currenty;
end
8'b1010:
begin
previousNodeX10[31] <= currentx;
previousNodeY10[31] <= currenty;
end
8'b1010:
begin
previousNodeX10[32] <= currentx;
previousNodeY10[32] <= currenty;
end
8'b1010:
begin
previousNodeX10[33] <= currentx;
previousNodeY10[33] <= currenty;
end
8'b1010:
begin
previousNodeX10[34] <= currentx;
previousNodeY10[34] <= currenty;
end
8'b1010:
begin
previousNodeX10[35] <= currentx;
previousNodeY10[35] <= currenty;
end
8'b1010:
begin
previousNodeX10[36] <= currentx;
previousNodeY10[36] <= currenty;
end
8'b1010:
begin
previousNodeX10[37] <= currentx;
previousNodeY10[37] <= currenty;
end
8'b1010:
begin
previousNodeX10[38] <= currentx;
previousNodeY10[38] <= currenty;
end
8'b1010:
begin
previousNodeX10[39] <= currentx;
previousNodeY10[39] <= currenty;
end
endcase
end
8'b1011:
begin
case(tempneighborx[neighborcounter])
8'b1011:
begin
previousNodeX11[0] <= currentx;
previousNodeY11[0] <= currenty;
end
8'b1011:
begin
previousNodeX11[1] <= currentx;
previousNodeY11[1] <= currenty;
end
8'b1011:
begin
previousNodeX11[2] <= currentx;
previousNodeY11[2] <= currenty;
end
8'b1011:
begin
previousNodeX11[3] <= currentx;
previousNodeY11[3] <= currenty;
end
8'b1011:
begin
previousNodeX11[4] <= currentx;
previousNodeY11[4] <= currenty;
end
8'b1011:
begin
previousNodeX11[5] <= currentx;
previousNodeY11[5] <= currenty;
end
8'b1011:
begin
previousNodeX11[6] <= currentx;
previousNodeY11[6] <= currenty;
end
8'b1011:
begin
previousNodeX11[7] <= currentx;
previousNodeY11[7] <= currenty;
end
8'b1011:
begin
previousNodeX11[8] <= currentx;
previousNodeY11[8] <= currenty;
end
8'b1011:
begin
previousNodeX11[9] <= currentx;
previousNodeY11[9] <= currenty;
end
8'b1011:
begin
previousNodeX11[10] <= currentx;
previousNodeY11[10] <= currenty;
end
8'b1011:
begin
previousNodeX11[11] <= currentx;
previousNodeY11[11] <= currenty;
end
8'b1011:
begin
previousNodeX11[12] <= currentx;
previousNodeY11[12] <= currenty;
end
8'b1011:
begin
previousNodeX11[13] <= currentx;
previousNodeY11[13] <= currenty;
end
8'b1011:
begin
previousNodeX11[14] <= currentx;
previousNodeY11[14] <= currenty;
end
8'b1011:
begin
previousNodeX11[15] <= currentx;
previousNodeY11[15] <= currenty;
end
8'b1011:
begin
previousNodeX11[16] <= currentx;
previousNodeY11[16] <= currenty;
end
8'b1011:
begin
previousNodeX11[17] <= currentx;
previousNodeY11[17] <= currenty;
end
8'b1011:
begin
previousNodeX11[18] <= currentx;
previousNodeY11[18] <= currenty;
end
8'b1011:
begin
previousNodeX11[19] <= currentx;
previousNodeY11[19] <= currenty;
end
8'b1011:
begin
previousNodeX11[20] <= currentx;
previousNodeY11[20] <= currenty;
end
8'b1011:
begin
previousNodeX11[21] <= currentx;
previousNodeY11[21] <= currenty;
end
8'b1011:
begin
previousNodeX11[22] <= currentx;
previousNodeY11[22] <= currenty;
end
8'b1011:
begin
previousNodeX11[23] <= currentx;
previousNodeY11[23] <= currenty;
end
8'b1011:
begin
previousNodeX11[24] <= currentx;
previousNodeY11[24] <= currenty;
end
8'b1011:
begin
previousNodeX11[25] <= currentx;
previousNodeY11[25] <= currenty;
end
8'b1011:
begin
previousNodeX11[26] <= currentx;
previousNodeY11[26] <= currenty;
end
8'b1011:
begin
previousNodeX11[27] <= currentx;
previousNodeY11[27] <= currenty;
end
8'b1011:
begin
previousNodeX11[28] <= currentx;
previousNodeY11[28] <= currenty;
end
8'b1011:
begin
previousNodeX11[29] <= currentx;
previousNodeY11[29] <= currenty;
end
8'b1011:
begin
previousNodeX11[30] <= currentx;
previousNodeY11[30] <= currenty;
end
8'b1011:
begin
previousNodeX11[31] <= currentx;
previousNodeY11[31] <= currenty;
end
8'b1011:
begin
previousNodeX11[32] <= currentx;
previousNodeY11[32] <= currenty;
end
8'b1011:
begin
previousNodeX11[33] <= currentx;
previousNodeY11[33] <= currenty;
end
8'b1011:
begin
previousNodeX11[34] <= currentx;
previousNodeY11[34] <= currenty;
end
8'b1011:
begin
previousNodeX11[35] <= currentx;
previousNodeY11[35] <= currenty;
end
8'b1011:
begin
previousNodeX11[36] <= currentx;
previousNodeY11[36] <= currenty;
end
8'b1011:
begin
previousNodeX11[37] <= currentx;
previousNodeY11[37] <= currenty;
end
8'b1011:
begin
previousNodeX11[38] <= currentx;
previousNodeY11[38] <= currenty;
end
8'b1011:
begin
previousNodeX11[39] <= currentx;
previousNodeY11[39] <= currenty;
end
endcase
end
8'b1100:
begin
case(tempneighborx[neighborcounter])
8'b1100:
begin
previousNodeX12[0] <= currentx;
previousNodeY12[0] <= currenty;
end
8'b1100:
begin
previousNodeX12[1] <= currentx;
previousNodeY12[1] <= currenty;
end
8'b1100:
begin
previousNodeX12[2] <= currentx;
previousNodeY12[2] <= currenty;
end
8'b1100:
begin
previousNodeX12[3] <= currentx;
previousNodeY12[3] <= currenty;
end
8'b1100:
begin
previousNodeX12[4] <= currentx;
previousNodeY12[4] <= currenty;
end
8'b1100:
begin
previousNodeX12[5] <= currentx;
previousNodeY12[5] <= currenty;
end
8'b1100:
begin
previousNodeX12[6] <= currentx;
previousNodeY12[6] <= currenty;
end
8'b1100:
begin
previousNodeX12[7] <= currentx;
previousNodeY12[7] <= currenty;
end
8'b1100:
begin
previousNodeX12[8] <= currentx;
previousNodeY12[8] <= currenty;
end
8'b1100:
begin
previousNodeX12[9] <= currentx;
previousNodeY12[9] <= currenty;
end
8'b1100:
begin
previousNodeX12[10] <= currentx;
previousNodeY12[10] <= currenty;
end
8'b1100:
begin
previousNodeX12[11] <= currentx;
previousNodeY12[11] <= currenty;
end
8'b1100:
begin
previousNodeX12[12] <= currentx;
previousNodeY12[12] <= currenty;
end
8'b1100:
begin
previousNodeX12[13] <= currentx;
previousNodeY12[13] <= currenty;
end
8'b1100:
begin
previousNodeX12[14] <= currentx;
previousNodeY12[14] <= currenty;
end
8'b1100:
begin
previousNodeX12[15] <= currentx;
previousNodeY12[15] <= currenty;
end
8'b1100:
begin
previousNodeX12[16] <= currentx;
previousNodeY12[16] <= currenty;
end
8'b1100:
begin
previousNodeX12[17] <= currentx;
previousNodeY12[17] <= currenty;
end
8'b1100:
begin
previousNodeX12[18] <= currentx;
previousNodeY12[18] <= currenty;
end
8'b1100:
begin
previousNodeX12[19] <= currentx;
previousNodeY12[19] <= currenty;
end
8'b1100:
begin
previousNodeX12[20] <= currentx;
previousNodeY12[20] <= currenty;
end
8'b1100:
begin
previousNodeX12[21] <= currentx;
previousNodeY12[21] <= currenty;
end
8'b1100:
begin
previousNodeX12[22] <= currentx;
previousNodeY12[22] <= currenty;
end
8'b1100:
begin
previousNodeX12[23] <= currentx;
previousNodeY12[23] <= currenty;
end
8'b1100:
begin
previousNodeX12[24] <= currentx;
previousNodeY12[24] <= currenty;
end
8'b1100:
begin
previousNodeX12[25] <= currentx;
previousNodeY12[25] <= currenty;
end
8'b1100:
begin
previousNodeX12[26] <= currentx;
previousNodeY12[26] <= currenty;
end
8'b1100:
begin
previousNodeX12[27] <= currentx;
previousNodeY12[27] <= currenty;
end
8'b1100:
begin
previousNodeX12[28] <= currentx;
previousNodeY12[28] <= currenty;
end
8'b1100:
begin
previousNodeX12[29] <= currentx;
previousNodeY12[29] <= currenty;
end
8'b1100:
begin
previousNodeX12[30] <= currentx;
previousNodeY12[30] <= currenty;
end
8'b1100:
begin
previousNodeX12[31] <= currentx;
previousNodeY12[31] <= currenty;
end
8'b1100:
begin
previousNodeX12[32] <= currentx;
previousNodeY12[32] <= currenty;
end
8'b1100:
begin
previousNodeX12[33] <= currentx;
previousNodeY12[33] <= currenty;
end
8'b1100:
begin
previousNodeX12[34] <= currentx;
previousNodeY12[34] <= currenty;
end
8'b1100:
begin
previousNodeX12[35] <= currentx;
previousNodeY12[35] <= currenty;
end
8'b1100:
begin
previousNodeX12[36] <= currentx;
previousNodeY12[36] <= currenty;
end
8'b1100:
begin
previousNodeX12[37] <= currentx;
previousNodeY12[37] <= currenty;
end
8'b1100:
begin
previousNodeX12[38] <= currentx;
previousNodeY12[38] <= currenty;
end
8'b1100:
begin
previousNodeX12[39] <= currentx;
previousNodeY12[39] <= currenty;
end
endcase
end
8'b1101:
begin
case(tempneighborx[neighborcounter])
8'b1101:
begin
previousNodeX13[0] <= currentx;
previousNodeY13[0] <= currenty;
end
8'b1101:
begin
previousNodeX13[1] <= currentx;
previousNodeY13[1] <= currenty;
end
8'b1101:
begin
previousNodeX13[2] <= currentx;
previousNodeY13[2] <= currenty;
end
8'b1101:
begin
previousNodeX13[3] <= currentx;
previousNodeY13[3] <= currenty;
end
8'b1101:
begin
previousNodeX13[4] <= currentx;
previousNodeY13[4] <= currenty;
end
8'b1101:
begin
previousNodeX13[5] <= currentx;
previousNodeY13[5] <= currenty;
end
8'b1101:
begin
previousNodeX13[6] <= currentx;
previousNodeY13[6] <= currenty;
end
8'b1101:
begin
previousNodeX13[7] <= currentx;
previousNodeY13[7] <= currenty;
end
8'b1101:
begin
previousNodeX13[8] <= currentx;
previousNodeY13[8] <= currenty;
end
8'b1101:
begin
previousNodeX13[9] <= currentx;
previousNodeY13[9] <= currenty;
end
8'b1101:
begin
previousNodeX13[10] <= currentx;
previousNodeY13[10] <= currenty;
end
8'b1101:
begin
previousNodeX13[11] <= currentx;
previousNodeY13[11] <= currenty;
end
8'b1101:
begin
previousNodeX13[12] <= currentx;
previousNodeY13[12] <= currenty;
end
8'b1101:
begin
previousNodeX13[13] <= currentx;
previousNodeY13[13] <= currenty;
end
8'b1101:
begin
previousNodeX13[14] <= currentx;
previousNodeY13[14] <= currenty;
end
8'b1101:
begin
previousNodeX13[15] <= currentx;
previousNodeY13[15] <= currenty;
end
8'b1101:
begin
previousNodeX13[16] <= currentx;
previousNodeY13[16] <= currenty;
end
8'b1101:
begin
previousNodeX13[17] <= currentx;
previousNodeY13[17] <= currenty;
end
8'b1101:
begin
previousNodeX13[18] <= currentx;
previousNodeY13[18] <= currenty;
end
8'b1101:
begin
previousNodeX13[19] <= currentx;
previousNodeY13[19] <= currenty;
end
8'b1101:
begin
previousNodeX13[20] <= currentx;
previousNodeY13[20] <= currenty;
end
8'b1101:
begin
previousNodeX13[21] <= currentx;
previousNodeY13[21] <= currenty;
end
8'b1101:
begin
previousNodeX13[22] <= currentx;
previousNodeY13[22] <= currenty;
end
8'b1101:
begin
previousNodeX13[23] <= currentx;
previousNodeY13[23] <= currenty;
end
8'b1101:
begin
previousNodeX13[24] <= currentx;
previousNodeY13[24] <= currenty;
end
8'b1101:
begin
previousNodeX13[25] <= currentx;
previousNodeY13[25] <= currenty;
end
8'b1101:
begin
previousNodeX13[26] <= currentx;
previousNodeY13[26] <= currenty;
end
8'b1101:
begin
previousNodeX13[27] <= currentx;
previousNodeY13[27] <= currenty;
end
8'b1101:
begin
previousNodeX13[28] <= currentx;
previousNodeY13[28] <= currenty;
end
8'b1101:
begin
previousNodeX13[29] <= currentx;
previousNodeY13[29] <= currenty;
end
8'b1101:
begin
previousNodeX13[30] <= currentx;
previousNodeY13[30] <= currenty;
end
8'b1101:
begin
previousNodeX13[31] <= currentx;
previousNodeY13[31] <= currenty;
end
8'b1101:
begin
previousNodeX13[32] <= currentx;
previousNodeY13[32] <= currenty;
end
8'b1101:
begin
previousNodeX13[33] <= currentx;
previousNodeY13[33] <= currenty;
end
8'b1101:
begin
previousNodeX13[34] <= currentx;
previousNodeY13[34] <= currenty;
end
8'b1101:
begin
previousNodeX13[35] <= currentx;
previousNodeY13[35] <= currenty;
end
8'b1101:
begin
previousNodeX13[36] <= currentx;
previousNodeY13[36] <= currenty;
end
8'b1101:
begin
previousNodeX13[37] <= currentx;
previousNodeY13[37] <= currenty;
end
8'b1101:
begin
previousNodeX13[38] <= currentx;
previousNodeY13[38] <= currenty;
end
8'b1101:
begin
previousNodeX13[39] <= currentx;
previousNodeY13[39] <= currenty;
end
endcase
end
8'b1110:
begin
case(tempneighborx[neighborcounter])
8'b1110:
begin
previousNodeX14[0] <= currentx;
previousNodeY14[0] <= currenty;
end
8'b1110:
begin
previousNodeX14[1] <= currentx;
previousNodeY14[1] <= currenty;
end
8'b1110:
begin
previousNodeX14[2] <= currentx;
previousNodeY14[2] <= currenty;
end
8'b1110:
begin
previousNodeX14[3] <= currentx;
previousNodeY14[3] <= currenty;
end
8'b1110:
begin
previousNodeX14[4] <= currentx;
previousNodeY14[4] <= currenty;
end
8'b1110:
begin
previousNodeX14[5] <= currentx;
previousNodeY14[5] <= currenty;
end
8'b1110:
begin
previousNodeX14[6] <= currentx;
previousNodeY14[6] <= currenty;
end
8'b1110:
begin
previousNodeX14[7] <= currentx;
previousNodeY14[7] <= currenty;
end
8'b1110:
begin
previousNodeX14[8] <= currentx;
previousNodeY14[8] <= currenty;
end
8'b1110:
begin
previousNodeX14[9] <= currentx;
previousNodeY14[9] <= currenty;
end
8'b1110:
begin
previousNodeX14[10] <= currentx;
previousNodeY14[10] <= currenty;
end
8'b1110:
begin
previousNodeX14[11] <= currentx;
previousNodeY14[11] <= currenty;
end
8'b1110:
begin
previousNodeX14[12] <= currentx;
previousNodeY14[12] <= currenty;
end
8'b1110:
begin
previousNodeX14[13] <= currentx;
previousNodeY14[13] <= currenty;
end
8'b1110:
begin
previousNodeX14[14] <= currentx;
previousNodeY14[14] <= currenty;
end
8'b1110:
begin
previousNodeX14[15] <= currentx;
previousNodeY14[15] <= currenty;
end
8'b1110:
begin
previousNodeX14[16] <= currentx;
previousNodeY14[16] <= currenty;
end
8'b1110:
begin
previousNodeX14[17] <= currentx;
previousNodeY14[17] <= currenty;
end
8'b1110:
begin
previousNodeX14[18] <= currentx;
previousNodeY14[18] <= currenty;
end
8'b1110:
begin
previousNodeX14[19] <= currentx;
previousNodeY14[19] <= currenty;
end
8'b1110:
begin
previousNodeX14[20] <= currentx;
previousNodeY14[20] <= currenty;
end
8'b1110:
begin
previousNodeX14[21] <= currentx;
previousNodeY14[21] <= currenty;
end
8'b1110:
begin
previousNodeX14[22] <= currentx;
previousNodeY14[22] <= currenty;
end
8'b1110:
begin
previousNodeX14[23] <= currentx;
previousNodeY14[23] <= currenty;
end
8'b1110:
begin
previousNodeX14[24] <= currentx;
previousNodeY14[24] <= currenty;
end
8'b1110:
begin
previousNodeX14[25] <= currentx;
previousNodeY14[25] <= currenty;
end
8'b1110:
begin
previousNodeX14[26] <= currentx;
previousNodeY14[26] <= currenty;
end
8'b1110:
begin
previousNodeX14[27] <= currentx;
previousNodeY14[27] <= currenty;
end
8'b1110:
begin
previousNodeX14[28] <= currentx;
previousNodeY14[28] <= currenty;
end
8'b1110:
begin
previousNodeX14[29] <= currentx;
previousNodeY14[29] <= currenty;
end
8'b1110:
begin
previousNodeX14[30] <= currentx;
previousNodeY14[30] <= currenty;
end
8'b1110:
begin
previousNodeX14[31] <= currentx;
previousNodeY14[31] <= currenty;
end
8'b1110:
begin
previousNodeX14[32] <= currentx;
previousNodeY14[32] <= currenty;
end
8'b1110:
begin
previousNodeX14[33] <= currentx;
previousNodeY14[33] <= currenty;
end
8'b1110:
begin
previousNodeX14[34] <= currentx;
previousNodeY14[34] <= currenty;
end
8'b1110:
begin
previousNodeX14[35] <= currentx;
previousNodeY14[35] <= currenty;
end
8'b1110:
begin
previousNodeX14[36] <= currentx;
previousNodeY14[36] <= currenty;
end
8'b1110:
begin
previousNodeX14[37] <= currentx;
previousNodeY14[37] <= currenty;
end
8'b1110:
begin
previousNodeX14[38] <= currentx;
previousNodeY14[38] <= currenty;
end
8'b1110:
begin
previousNodeX14[39] <= currentx;
previousNodeY14[39] <= currenty;
end
endcase
end
8'b1111:
begin
case(tempneighborx[neighborcounter])
8'b1111:
begin
previousNodeX15[0] <= currentx;
previousNodeY15[0] <= currenty;
end
8'b1111:
begin
previousNodeX15[1] <= currentx;
previousNodeY15[1] <= currenty;
end
8'b1111:
begin
previousNodeX15[2] <= currentx;
previousNodeY15[2] <= currenty;
end
8'b1111:
begin
previousNodeX15[3] <= currentx;
previousNodeY15[3] <= currenty;
end
8'b1111:
begin
previousNodeX15[4] <= currentx;
previousNodeY15[4] <= currenty;
end
8'b1111:
begin
previousNodeX15[5] <= currentx;
previousNodeY15[5] <= currenty;
end
8'b1111:
begin
previousNodeX15[6] <= currentx;
previousNodeY15[6] <= currenty;
end
8'b1111:
begin
previousNodeX15[7] <= currentx;
previousNodeY15[7] <= currenty;
end
8'b1111:
begin
previousNodeX15[8] <= currentx;
previousNodeY15[8] <= currenty;
end
8'b1111:
begin
previousNodeX15[9] <= currentx;
previousNodeY15[9] <= currenty;
end
8'b1111:
begin
previousNodeX15[10] <= currentx;
previousNodeY15[10] <= currenty;
end
8'b1111:
begin
previousNodeX15[11] <= currentx;
previousNodeY15[11] <= currenty;
end
8'b1111:
begin
previousNodeX15[12] <= currentx;
previousNodeY15[12] <= currenty;
end
8'b1111:
begin
previousNodeX15[13] <= currentx;
previousNodeY15[13] <= currenty;
end
8'b1111:
begin
previousNodeX15[14] <= currentx;
previousNodeY15[14] <= currenty;
end
8'b1111:
begin
previousNodeX15[15] <= currentx;
previousNodeY15[15] <= currenty;
end
8'b1111:
begin
previousNodeX15[16] <= currentx;
previousNodeY15[16] <= currenty;
end
8'b1111:
begin
previousNodeX15[17] <= currentx;
previousNodeY15[17] <= currenty;
end
8'b1111:
begin
previousNodeX15[18] <= currentx;
previousNodeY15[18] <= currenty;
end
8'b1111:
begin
previousNodeX15[19] <= currentx;
previousNodeY15[19] <= currenty;
end
8'b1111:
begin
previousNodeX15[20] <= currentx;
previousNodeY15[20] <= currenty;
end
8'b1111:
begin
previousNodeX15[21] <= currentx;
previousNodeY15[21] <= currenty;
end
8'b1111:
begin
previousNodeX15[22] <= currentx;
previousNodeY15[22] <= currenty;
end
8'b1111:
begin
previousNodeX15[23] <= currentx;
previousNodeY15[23] <= currenty;
end
8'b1111:
begin
previousNodeX15[24] <= currentx;
previousNodeY15[24] <= currenty;
end
8'b1111:
begin
previousNodeX15[25] <= currentx;
previousNodeY15[25] <= currenty;
end
8'b1111:
begin
previousNodeX15[26] <= currentx;
previousNodeY15[26] <= currenty;
end
8'b1111:
begin
previousNodeX15[27] <= currentx;
previousNodeY15[27] <= currenty;
end
8'b1111:
begin
previousNodeX15[28] <= currentx;
previousNodeY15[28] <= currenty;
end
8'b1111:
begin
previousNodeX15[29] <= currentx;
previousNodeY15[29] <= currenty;
end
8'b1111:
begin
previousNodeX15[30] <= currentx;
previousNodeY15[30] <= currenty;
end
8'b1111:
begin
previousNodeX15[31] <= currentx;
previousNodeY15[31] <= currenty;
end
8'b1111:
begin
previousNodeX15[32] <= currentx;
previousNodeY15[32] <= currenty;
end
8'b1111:
begin
previousNodeX15[33] <= currentx;
previousNodeY15[33] <= currenty;
end
8'b1111:
begin
previousNodeX15[34] <= currentx;
previousNodeY15[34] <= currenty;
end
8'b1111:
begin
previousNodeX15[35] <= currentx;
previousNodeY15[35] <= currenty;
end
8'b1111:
begin
previousNodeX15[36] <= currentx;
previousNodeY15[36] <= currenty;
end
8'b1111:
begin
previousNodeX15[37] <= currentx;
previousNodeY15[37] <= currenty;
end
8'b1111:
begin
previousNodeX15[38] <= currentx;
previousNodeY15[38] <= currenty;
end
8'b1111:
begin
previousNodeX15[39] <= currentx;
previousNodeY15[39] <= currenty;
end
endcase
end
8'b10000:
begin
case(tempneighborx[neighborcounter])
8'b10000:
begin
previousNodeX16[0] <= currentx;
previousNodeY16[0] <= currenty;
end
8'b10000:
begin
previousNodeX16[1] <= currentx;
previousNodeY16[1] <= currenty;
end
8'b10000:
begin
previousNodeX16[2] <= currentx;
previousNodeY16[2] <= currenty;
end
8'b10000:
begin
previousNodeX16[3] <= currentx;
previousNodeY16[3] <= currenty;
end
8'b10000:
begin
previousNodeX16[4] <= currentx;
previousNodeY16[4] <= currenty;
end
8'b10000:
begin
previousNodeX16[5] <= currentx;
previousNodeY16[5] <= currenty;
end
8'b10000:
begin
previousNodeX16[6] <= currentx;
previousNodeY16[6] <= currenty;
end
8'b10000:
begin
previousNodeX16[7] <= currentx;
previousNodeY16[7] <= currenty;
end
8'b10000:
begin
previousNodeX16[8] <= currentx;
previousNodeY16[8] <= currenty;
end
8'b10000:
begin
previousNodeX16[9] <= currentx;
previousNodeY16[9] <= currenty;
end
8'b10000:
begin
previousNodeX16[10] <= currentx;
previousNodeY16[10] <= currenty;
end
8'b10000:
begin
previousNodeX16[11] <= currentx;
previousNodeY16[11] <= currenty;
end
8'b10000:
begin
previousNodeX16[12] <= currentx;
previousNodeY16[12] <= currenty;
end
8'b10000:
begin
previousNodeX16[13] <= currentx;
previousNodeY16[13] <= currenty;
end
8'b10000:
begin
previousNodeX16[14] <= currentx;
previousNodeY16[14] <= currenty;
end
8'b10000:
begin
previousNodeX16[15] <= currentx;
previousNodeY16[15] <= currenty;
end
8'b10000:
begin
previousNodeX16[16] <= currentx;
previousNodeY16[16] <= currenty;
end
8'b10000:
begin
previousNodeX16[17] <= currentx;
previousNodeY16[17] <= currenty;
end
8'b10000:
begin
previousNodeX16[18] <= currentx;
previousNodeY16[18] <= currenty;
end
8'b10000:
begin
previousNodeX16[19] <= currentx;
previousNodeY16[19] <= currenty;
end
8'b10000:
begin
previousNodeX16[20] <= currentx;
previousNodeY16[20] <= currenty;
end
8'b10000:
begin
previousNodeX16[21] <= currentx;
previousNodeY16[21] <= currenty;
end
8'b10000:
begin
previousNodeX16[22] <= currentx;
previousNodeY16[22] <= currenty;
end
8'b10000:
begin
previousNodeX16[23] <= currentx;
previousNodeY16[23] <= currenty;
end
8'b10000:
begin
previousNodeX16[24] <= currentx;
previousNodeY16[24] <= currenty;
end
8'b10000:
begin
previousNodeX16[25] <= currentx;
previousNodeY16[25] <= currenty;
end
8'b10000:
begin
previousNodeX16[26] <= currentx;
previousNodeY16[26] <= currenty;
end
8'b10000:
begin
previousNodeX16[27] <= currentx;
previousNodeY16[27] <= currenty;
end
8'b10000:
begin
previousNodeX16[28] <= currentx;
previousNodeY16[28] <= currenty;
end
8'b10000:
begin
previousNodeX16[29] <= currentx;
previousNodeY16[29] <= currenty;
end
8'b10000:
begin
previousNodeX16[30] <= currentx;
previousNodeY16[30] <= currenty;
end
8'b10000:
begin
previousNodeX16[31] <= currentx;
previousNodeY16[31] <= currenty;
end
8'b10000:
begin
previousNodeX16[32] <= currentx;
previousNodeY16[32] <= currenty;
end
8'b10000:
begin
previousNodeX16[33] <= currentx;
previousNodeY16[33] <= currenty;
end
8'b10000:
begin
previousNodeX16[34] <= currentx;
previousNodeY16[34] <= currenty;
end
8'b10000:
begin
previousNodeX16[35] <= currentx;
previousNodeY16[35] <= currenty;
end
8'b10000:
begin
previousNodeX16[36] <= currentx;
previousNodeY16[36] <= currenty;
end
8'b10000:
begin
previousNodeX16[37] <= currentx;
previousNodeY16[37] <= currenty;
end
8'b10000:
begin
previousNodeX16[38] <= currentx;
previousNodeY16[38] <= currenty;
end
8'b10000:
begin
previousNodeX16[39] <= currentx;
previousNodeY16[39] <= currenty;
end
endcase
end
8'b10001:
begin
case(tempneighborx[neighborcounter])
8'b10001:
begin
previousNodeX17[0] <= currentx;
previousNodeY17[0] <= currenty;
end
8'b10001:
begin
previousNodeX17[1] <= currentx;
previousNodeY17[1] <= currenty;
end
8'b10001:
begin
previousNodeX17[2] <= currentx;
previousNodeY17[2] <= currenty;
end
8'b10001:
begin
previousNodeX17[3] <= currentx;
previousNodeY17[3] <= currenty;
end
8'b10001:
begin
previousNodeX17[4] <= currentx;
previousNodeY17[4] <= currenty;
end
8'b10001:
begin
previousNodeX17[5] <= currentx;
previousNodeY17[5] <= currenty;
end
8'b10001:
begin
previousNodeX17[6] <= currentx;
previousNodeY17[6] <= currenty;
end
8'b10001:
begin
previousNodeX17[7] <= currentx;
previousNodeY17[7] <= currenty;
end
8'b10001:
begin
previousNodeX17[8] <= currentx;
previousNodeY17[8] <= currenty;
end
8'b10001:
begin
previousNodeX17[9] <= currentx;
previousNodeY17[9] <= currenty;
end
8'b10001:
begin
previousNodeX17[10] <= currentx;
previousNodeY17[10] <= currenty;
end
8'b10001:
begin
previousNodeX17[11] <= currentx;
previousNodeY17[11] <= currenty;
end
8'b10001:
begin
previousNodeX17[12] <= currentx;
previousNodeY17[12] <= currenty;
end
8'b10001:
begin
previousNodeX17[13] <= currentx;
previousNodeY17[13] <= currenty;
end
8'b10001:
begin
previousNodeX17[14] <= currentx;
previousNodeY17[14] <= currenty;
end
8'b10001:
begin
previousNodeX17[15] <= currentx;
previousNodeY17[15] <= currenty;
end
8'b10001:
begin
previousNodeX17[16] <= currentx;
previousNodeY17[16] <= currenty;
end
8'b10001:
begin
previousNodeX17[17] <= currentx;
previousNodeY17[17] <= currenty;
end
8'b10001:
begin
previousNodeX17[18] <= currentx;
previousNodeY17[18] <= currenty;
end
8'b10001:
begin
previousNodeX17[19] <= currentx;
previousNodeY17[19] <= currenty;
end
8'b10001:
begin
previousNodeX17[20] <= currentx;
previousNodeY17[20] <= currenty;
end
8'b10001:
begin
previousNodeX17[21] <= currentx;
previousNodeY17[21] <= currenty;
end
8'b10001:
begin
previousNodeX17[22] <= currentx;
previousNodeY17[22] <= currenty;
end
8'b10001:
begin
previousNodeX17[23] <= currentx;
previousNodeY17[23] <= currenty;
end
8'b10001:
begin
previousNodeX17[24] <= currentx;
previousNodeY17[24] <= currenty;
end
8'b10001:
begin
previousNodeX17[25] <= currentx;
previousNodeY17[25] <= currenty;
end
8'b10001:
begin
previousNodeX17[26] <= currentx;
previousNodeY17[26] <= currenty;
end
8'b10001:
begin
previousNodeX17[27] <= currentx;
previousNodeY17[27] <= currenty;
end
8'b10001:
begin
previousNodeX17[28] <= currentx;
previousNodeY17[28] <= currenty;
end
8'b10001:
begin
previousNodeX17[29] <= currentx;
previousNodeY17[29] <= currenty;
end
8'b10001:
begin
previousNodeX17[30] <= currentx;
previousNodeY17[30] <= currenty;
end
8'b10001:
begin
previousNodeX17[31] <= currentx;
previousNodeY17[31] <= currenty;
end
8'b10001:
begin
previousNodeX17[32] <= currentx;
previousNodeY17[32] <= currenty;
end
8'b10001:
begin
previousNodeX17[33] <= currentx;
previousNodeY17[33] <= currenty;
end
8'b10001:
begin
previousNodeX17[34] <= currentx;
previousNodeY17[34] <= currenty;
end
8'b10001:
begin
previousNodeX17[35] <= currentx;
previousNodeY17[35] <= currenty;
end
8'b10001:
begin
previousNodeX17[36] <= currentx;
previousNodeY17[36] <= currenty;
end
8'b10001:
begin
previousNodeX17[37] <= currentx;
previousNodeY17[37] <= currenty;
end
8'b10001:
begin
previousNodeX17[38] <= currentx;
previousNodeY17[38] <= currenty;
end
8'b10001:
begin
previousNodeX17[39] <= currentx;
previousNodeY17[39] <= currenty;
end
endcase
end
8'b10010:
begin
case(tempneighborx[neighborcounter])
8'b10010:
begin
previousNodeX18[0] <= currentx;
previousNodeY18[0] <= currenty;
end
8'b10010:
begin
previousNodeX18[1] <= currentx;
previousNodeY18[1] <= currenty;
end
8'b10010:
begin
previousNodeX18[2] <= currentx;
previousNodeY18[2] <= currenty;
end
8'b10010:
begin
previousNodeX18[3] <= currentx;
previousNodeY18[3] <= currenty;
end
8'b10010:
begin
previousNodeX18[4] <= currentx;
previousNodeY18[4] <= currenty;
end
8'b10010:
begin
previousNodeX18[5] <= currentx;
previousNodeY18[5] <= currenty;
end
8'b10010:
begin
previousNodeX18[6] <= currentx;
previousNodeY18[6] <= currenty;
end
8'b10010:
begin
previousNodeX18[7] <= currentx;
previousNodeY18[7] <= currenty;
end
8'b10010:
begin
previousNodeX18[8] <= currentx;
previousNodeY18[8] <= currenty;
end
8'b10010:
begin
previousNodeX18[9] <= currentx;
previousNodeY18[9] <= currenty;
end
8'b10010:
begin
previousNodeX18[10] <= currentx;
previousNodeY18[10] <= currenty;
end
8'b10010:
begin
previousNodeX18[11] <= currentx;
previousNodeY18[11] <= currenty;
end
8'b10010:
begin
previousNodeX18[12] <= currentx;
previousNodeY18[12] <= currenty;
end
8'b10010:
begin
previousNodeX18[13] <= currentx;
previousNodeY18[13] <= currenty;
end
8'b10010:
begin
previousNodeX18[14] <= currentx;
previousNodeY18[14] <= currenty;
end
8'b10010:
begin
previousNodeX18[15] <= currentx;
previousNodeY18[15] <= currenty;
end
8'b10010:
begin
previousNodeX18[16] <= currentx;
previousNodeY18[16] <= currenty;
end
8'b10010:
begin
previousNodeX18[17] <= currentx;
previousNodeY18[17] <= currenty;
end
8'b10010:
begin
previousNodeX18[18] <= currentx;
previousNodeY18[18] <= currenty;
end
8'b10010:
begin
previousNodeX18[19] <= currentx;
previousNodeY18[19] <= currenty;
end
8'b10010:
begin
previousNodeX18[20] <= currentx;
previousNodeY18[20] <= currenty;
end
8'b10010:
begin
previousNodeX18[21] <= currentx;
previousNodeY18[21] <= currenty;
end
8'b10010:
begin
previousNodeX18[22] <= currentx;
previousNodeY18[22] <= currenty;
end
8'b10010:
begin
previousNodeX18[23] <= currentx;
previousNodeY18[23] <= currenty;
end
8'b10010:
begin
previousNodeX18[24] <= currentx;
previousNodeY18[24] <= currenty;
end
8'b10010:
begin
previousNodeX18[25] <= currentx;
previousNodeY18[25] <= currenty;
end
8'b10010:
begin
previousNodeX18[26] <= currentx;
previousNodeY18[26] <= currenty;
end
8'b10010:
begin
previousNodeX18[27] <= currentx;
previousNodeY18[27] <= currenty;
end
8'b10010:
begin
previousNodeX18[28] <= currentx;
previousNodeY18[28] <= currenty;
end
8'b10010:
begin
previousNodeX18[29] <= currentx;
previousNodeY18[29] <= currenty;
end
8'b10010:
begin
previousNodeX18[30] <= currentx;
previousNodeY18[30] <= currenty;
end
8'b10010:
begin
previousNodeX18[31] <= currentx;
previousNodeY18[31] <= currenty;
end
8'b10010:
begin
previousNodeX18[32] <= currentx;
previousNodeY18[32] <= currenty;
end
8'b10010:
begin
previousNodeX18[33] <= currentx;
previousNodeY18[33] <= currenty;
end
8'b10010:
begin
previousNodeX18[34] <= currentx;
previousNodeY18[34] <= currenty;
end
8'b10010:
begin
previousNodeX18[35] <= currentx;
previousNodeY18[35] <= currenty;
end
8'b10010:
begin
previousNodeX18[36] <= currentx;
previousNodeY18[36] <= currenty;
end
8'b10010:
begin
previousNodeX18[37] <= currentx;
previousNodeY18[37] <= currenty;
end
8'b10010:
begin
previousNodeX18[38] <= currentx;
previousNodeY18[38] <= currenty;
end
8'b10010:
begin
previousNodeX18[39] <= currentx;
previousNodeY18[39] <= currenty;
end
endcase
end
8'b10011:
begin
case(tempneighborx[neighborcounter])
8'b10011:
begin
previousNodeX19[0] <= currentx;
previousNodeY19[0] <= currenty;
end
8'b10011:
begin
previousNodeX19[1] <= currentx;
previousNodeY19[1] <= currenty;
end
8'b10011:
begin
previousNodeX19[2] <= currentx;
previousNodeY19[2] <= currenty;
end
8'b10011:
begin
previousNodeX19[3] <= currentx;
previousNodeY19[3] <= currenty;
end
8'b10011:
begin
previousNodeX19[4] <= currentx;
previousNodeY19[4] <= currenty;
end
8'b10011:
begin
previousNodeX19[5] <= currentx;
previousNodeY19[5] <= currenty;
end
8'b10011:
begin
previousNodeX19[6] <= currentx;
previousNodeY19[6] <= currenty;
end
8'b10011:
begin
previousNodeX19[7] <= currentx;
previousNodeY19[7] <= currenty;
end
8'b10011:
begin
previousNodeX19[8] <= currentx;
previousNodeY19[8] <= currenty;
end
8'b10011:
begin
previousNodeX19[9] <= currentx;
previousNodeY19[9] <= currenty;
end
8'b10011:
begin
previousNodeX19[10] <= currentx;
previousNodeY19[10] <= currenty;
end
8'b10011:
begin
previousNodeX19[11] <= currentx;
previousNodeY19[11] <= currenty;
end
8'b10011:
begin
previousNodeX19[12] <= currentx;
previousNodeY19[12] <= currenty;
end
8'b10011:
begin
previousNodeX19[13] <= currentx;
previousNodeY19[13] <= currenty;
end
8'b10011:
begin
previousNodeX19[14] <= currentx;
previousNodeY19[14] <= currenty;
end
8'b10011:
begin
previousNodeX19[15] <= currentx;
previousNodeY19[15] <= currenty;
end
8'b10011:
begin
previousNodeX19[16] <= currentx;
previousNodeY19[16] <= currenty;
end
8'b10011:
begin
previousNodeX19[17] <= currentx;
previousNodeY19[17] <= currenty;
end
8'b10011:
begin
previousNodeX19[18] <= currentx;
previousNodeY19[18] <= currenty;
end
8'b10011:
begin
previousNodeX19[19] <= currentx;
previousNodeY19[19] <= currenty;
end
8'b10011:
begin
previousNodeX19[20] <= currentx;
previousNodeY19[20] <= currenty;
end
8'b10011:
begin
previousNodeX19[21] <= currentx;
previousNodeY19[21] <= currenty;
end
8'b10011:
begin
previousNodeX19[22] <= currentx;
previousNodeY19[22] <= currenty;
end
8'b10011:
begin
previousNodeX19[23] <= currentx;
previousNodeY19[23] <= currenty;
end
8'b10011:
begin
previousNodeX19[24] <= currentx;
previousNodeY19[24] <= currenty;
end
8'b10011:
begin
previousNodeX19[25] <= currentx;
previousNodeY19[25] <= currenty;
end
8'b10011:
begin
previousNodeX19[26] <= currentx;
previousNodeY19[26] <= currenty;
end
8'b10011:
begin
previousNodeX19[27] <= currentx;
previousNodeY19[27] <= currenty;
end
8'b10011:
begin
previousNodeX19[28] <= currentx;
previousNodeY19[28] <= currenty;
end
8'b10011:
begin
previousNodeX19[29] <= currentx;
previousNodeY19[29] <= currenty;
end
8'b10011:
begin
previousNodeX19[30] <= currentx;
previousNodeY19[30] <= currenty;
end
8'b10011:
begin
previousNodeX19[31] <= currentx;
previousNodeY19[31] <= currenty;
end
8'b10011:
begin
previousNodeX19[32] <= currentx;
previousNodeY19[32] <= currenty;
end
8'b10011:
begin
previousNodeX19[33] <= currentx;
previousNodeY19[33] <= currenty;
end
8'b10011:
begin
previousNodeX19[34] <= currentx;
previousNodeY19[34] <= currenty;
end
8'b10011:
begin
previousNodeX19[35] <= currentx;
previousNodeY19[35] <= currenty;
end
8'b10011:
begin
previousNodeX19[36] <= currentx;
previousNodeY19[36] <= currenty;
end
8'b10011:
begin
previousNodeX19[37] <= currentx;
previousNodeY19[37] <= currenty;
end
8'b10011:
begin
previousNodeX19[38] <= currentx;
previousNodeY19[38] <= currenty;
end
8'b10011:
begin
previousNodeX19[39] <= currentx;
previousNodeY19[39] <= currenty;
end
endcase
end
8'b10100:
begin
case(tempneighborx[neighborcounter])
8'b10100:
begin
previousNodeX20[0] <= currentx;
previousNodeY20[0] <= currenty;
end
8'b10100:
begin
previousNodeX20[1] <= currentx;
previousNodeY20[1] <= currenty;
end
8'b10100:
begin
previousNodeX20[2] <= currentx;
previousNodeY20[2] <= currenty;
end
8'b10100:
begin
previousNodeX20[3] <= currentx;
previousNodeY20[3] <= currenty;
end
8'b10100:
begin
previousNodeX20[4] <= currentx;
previousNodeY20[4] <= currenty;
end
8'b10100:
begin
previousNodeX20[5] <= currentx;
previousNodeY20[5] <= currenty;
end
8'b10100:
begin
previousNodeX20[6] <= currentx;
previousNodeY20[6] <= currenty;
end
8'b10100:
begin
previousNodeX20[7] <= currentx;
previousNodeY20[7] <= currenty;
end
8'b10100:
begin
previousNodeX20[8] <= currentx;
previousNodeY20[8] <= currenty;
end
8'b10100:
begin
previousNodeX20[9] <= currentx;
previousNodeY20[9] <= currenty;
end
8'b10100:
begin
previousNodeX20[10] <= currentx;
previousNodeY20[10] <= currenty;
end
8'b10100:
begin
previousNodeX20[11] <= currentx;
previousNodeY20[11] <= currenty;
end
8'b10100:
begin
previousNodeX20[12] <= currentx;
previousNodeY20[12] <= currenty;
end
8'b10100:
begin
previousNodeX20[13] <= currentx;
previousNodeY20[13] <= currenty;
end
8'b10100:
begin
previousNodeX20[14] <= currentx;
previousNodeY20[14] <= currenty;
end
8'b10100:
begin
previousNodeX20[15] <= currentx;
previousNodeY20[15] <= currenty;
end
8'b10100:
begin
previousNodeX20[16] <= currentx;
previousNodeY20[16] <= currenty;
end
8'b10100:
begin
previousNodeX20[17] <= currentx;
previousNodeY20[17] <= currenty;
end
8'b10100:
begin
previousNodeX20[18] <= currentx;
previousNodeY20[18] <= currenty;
end
8'b10100:
begin
previousNodeX20[19] <= currentx;
previousNodeY20[19] <= currenty;
end
8'b10100:
begin
previousNodeX20[20] <= currentx;
previousNodeY20[20] <= currenty;
end
8'b10100:
begin
previousNodeX20[21] <= currentx;
previousNodeY20[21] <= currenty;
end
8'b10100:
begin
previousNodeX20[22] <= currentx;
previousNodeY20[22] <= currenty;
end
8'b10100:
begin
previousNodeX20[23] <= currentx;
previousNodeY20[23] <= currenty;
end
8'b10100:
begin
previousNodeX20[24] <= currentx;
previousNodeY20[24] <= currenty;
end
8'b10100:
begin
previousNodeX20[25] <= currentx;
previousNodeY20[25] <= currenty;
end
8'b10100:
begin
previousNodeX20[26] <= currentx;
previousNodeY20[26] <= currenty;
end
8'b10100:
begin
previousNodeX20[27] <= currentx;
previousNodeY20[27] <= currenty;
end
8'b10100:
begin
previousNodeX20[28] <= currentx;
previousNodeY20[28] <= currenty;
end
8'b10100:
begin
previousNodeX20[29] <= currentx;
previousNodeY20[29] <= currenty;
end
8'b10100:
begin
previousNodeX20[30] <= currentx;
previousNodeY20[30] <= currenty;
end
8'b10100:
begin
previousNodeX20[31] <= currentx;
previousNodeY20[31] <= currenty;
end
8'b10100:
begin
previousNodeX20[32] <= currentx;
previousNodeY20[32] <= currenty;
end
8'b10100:
begin
previousNodeX20[33] <= currentx;
previousNodeY20[33] <= currenty;
end
8'b10100:
begin
previousNodeX20[34] <= currentx;
previousNodeY20[34] <= currenty;
end
8'b10100:
begin
previousNodeX20[35] <= currentx;
previousNodeY20[35] <= currenty;
end
8'b10100:
begin
previousNodeX20[36] <= currentx;
previousNodeY20[36] <= currenty;
end
8'b10100:
begin
previousNodeX20[37] <= currentx;
previousNodeY20[37] <= currenty;
end
8'b10100:
begin
previousNodeX20[38] <= currentx;
previousNodeY20[38] <= currenty;
end
8'b10100:
begin
previousNodeX20[39] <= currentx;
previousNodeY20[39] <= currenty;
end
endcase
end
8'b10101:
begin
case(tempneighborx[neighborcounter])
8'b10101:
begin
previousNodeX21[0] <= currentx;
previousNodeY21[0] <= currenty;
end
8'b10101:
begin
previousNodeX21[1] <= currentx;
previousNodeY21[1] <= currenty;
end
8'b10101:
begin
previousNodeX21[2] <= currentx;
previousNodeY21[2] <= currenty;
end
8'b10101:
begin
previousNodeX21[3] <= currentx;
previousNodeY21[3] <= currenty;
end
8'b10101:
begin
previousNodeX21[4] <= currentx;
previousNodeY21[4] <= currenty;
end
8'b10101:
begin
previousNodeX21[5] <= currentx;
previousNodeY21[5] <= currenty;
end
8'b10101:
begin
previousNodeX21[6] <= currentx;
previousNodeY21[6] <= currenty;
end
8'b10101:
begin
previousNodeX21[7] <= currentx;
previousNodeY21[7] <= currenty;
end
8'b10101:
begin
previousNodeX21[8] <= currentx;
previousNodeY21[8] <= currenty;
end
8'b10101:
begin
previousNodeX21[9] <= currentx;
previousNodeY21[9] <= currenty;
end
8'b10101:
begin
previousNodeX21[10] <= currentx;
previousNodeY21[10] <= currenty;
end
8'b10101:
begin
previousNodeX21[11] <= currentx;
previousNodeY21[11] <= currenty;
end
8'b10101:
begin
previousNodeX21[12] <= currentx;
previousNodeY21[12] <= currenty;
end
8'b10101:
begin
previousNodeX21[13] <= currentx;
previousNodeY21[13] <= currenty;
end
8'b10101:
begin
previousNodeX21[14] <= currentx;
previousNodeY21[14] <= currenty;
end
8'b10101:
begin
previousNodeX21[15] <= currentx;
previousNodeY21[15] <= currenty;
end
8'b10101:
begin
previousNodeX21[16] <= currentx;
previousNodeY21[16] <= currenty;
end
8'b10101:
begin
previousNodeX21[17] <= currentx;
previousNodeY21[17] <= currenty;
end
8'b10101:
begin
previousNodeX21[18] <= currentx;
previousNodeY21[18] <= currenty;
end
8'b10101:
begin
previousNodeX21[19] <= currentx;
previousNodeY21[19] <= currenty;
end
8'b10101:
begin
previousNodeX21[20] <= currentx;
previousNodeY21[20] <= currenty;
end
8'b10101:
begin
previousNodeX21[21] <= currentx;
previousNodeY21[21] <= currenty;
end
8'b10101:
begin
previousNodeX21[22] <= currentx;
previousNodeY21[22] <= currenty;
end
8'b10101:
begin
previousNodeX21[23] <= currentx;
previousNodeY21[23] <= currenty;
end
8'b10101:
begin
previousNodeX21[24] <= currentx;
previousNodeY21[24] <= currenty;
end
8'b10101:
begin
previousNodeX21[25] <= currentx;
previousNodeY21[25] <= currenty;
end
8'b10101:
begin
previousNodeX21[26] <= currentx;
previousNodeY21[26] <= currenty;
end
8'b10101:
begin
previousNodeX21[27] <= currentx;
previousNodeY21[27] <= currenty;
end
8'b10101:
begin
previousNodeX21[28] <= currentx;
previousNodeY21[28] <= currenty;
end
8'b10101:
begin
previousNodeX21[29] <= currentx;
previousNodeY21[29] <= currenty;
end
8'b10101:
begin
previousNodeX21[30] <= currentx;
previousNodeY21[30] <= currenty;
end
8'b10101:
begin
previousNodeX21[31] <= currentx;
previousNodeY21[31] <= currenty;
end
8'b10101:
begin
previousNodeX21[32] <= currentx;
previousNodeY21[32] <= currenty;
end
8'b10101:
begin
previousNodeX21[33] <= currentx;
previousNodeY21[33] <= currenty;
end
8'b10101:
begin
previousNodeX21[34] <= currentx;
previousNodeY21[34] <= currenty;
end
8'b10101:
begin
previousNodeX21[35] <= currentx;
previousNodeY21[35] <= currenty;
end
8'b10101:
begin
previousNodeX21[36] <= currentx;
previousNodeY21[36] <= currenty;
end
8'b10101:
begin
previousNodeX21[37] <= currentx;
previousNodeY21[37] <= currenty;
end
8'b10101:
begin
previousNodeX21[38] <= currentx;
previousNodeY21[38] <= currenty;
end
8'b10101:
begin
previousNodeX21[39] <= currentx;
previousNodeY21[39] <= currenty;
end
endcase
end
8'b10110:
begin
case(tempneighborx[neighborcounter])
8'b10110:
begin
previousNodeX22[0] <= currentx;
previousNodeY22[0] <= currenty;
end
8'b10110:
begin
previousNodeX22[1] <= currentx;
previousNodeY22[1] <= currenty;
end
8'b10110:
begin
previousNodeX22[2] <= currentx;
previousNodeY22[2] <= currenty;
end
8'b10110:
begin
previousNodeX22[3] <= currentx;
previousNodeY22[3] <= currenty;
end
8'b10110:
begin
previousNodeX22[4] <= currentx;
previousNodeY22[4] <= currenty;
end
8'b10110:
begin
previousNodeX22[5] <= currentx;
previousNodeY22[5] <= currenty;
end
8'b10110:
begin
previousNodeX22[6] <= currentx;
previousNodeY22[6] <= currenty;
end
8'b10110:
begin
previousNodeX22[7] <= currentx;
previousNodeY22[7] <= currenty;
end
8'b10110:
begin
previousNodeX22[8] <= currentx;
previousNodeY22[8] <= currenty;
end
8'b10110:
begin
previousNodeX22[9] <= currentx;
previousNodeY22[9] <= currenty;
end
8'b10110:
begin
previousNodeX22[10] <= currentx;
previousNodeY22[10] <= currenty;
end
8'b10110:
begin
previousNodeX22[11] <= currentx;
previousNodeY22[11] <= currenty;
end
8'b10110:
begin
previousNodeX22[12] <= currentx;
previousNodeY22[12] <= currenty;
end
8'b10110:
begin
previousNodeX22[13] <= currentx;
previousNodeY22[13] <= currenty;
end
8'b10110:
begin
previousNodeX22[14] <= currentx;
previousNodeY22[14] <= currenty;
end
8'b10110:
begin
previousNodeX22[15] <= currentx;
previousNodeY22[15] <= currenty;
end
8'b10110:
begin
previousNodeX22[16] <= currentx;
previousNodeY22[16] <= currenty;
end
8'b10110:
begin
previousNodeX22[17] <= currentx;
previousNodeY22[17] <= currenty;
end
8'b10110:
begin
previousNodeX22[18] <= currentx;
previousNodeY22[18] <= currenty;
end
8'b10110:
begin
previousNodeX22[19] <= currentx;
previousNodeY22[19] <= currenty;
end
8'b10110:
begin
previousNodeX22[20] <= currentx;
previousNodeY22[20] <= currenty;
end
8'b10110:
begin
previousNodeX22[21] <= currentx;
previousNodeY22[21] <= currenty;
end
8'b10110:
begin
previousNodeX22[22] <= currentx;
previousNodeY22[22] <= currenty;
end
8'b10110:
begin
previousNodeX22[23] <= currentx;
previousNodeY22[23] <= currenty;
end
8'b10110:
begin
previousNodeX22[24] <= currentx;
previousNodeY22[24] <= currenty;
end
8'b10110:
begin
previousNodeX22[25] <= currentx;
previousNodeY22[25] <= currenty;
end
8'b10110:
begin
previousNodeX22[26] <= currentx;
previousNodeY22[26] <= currenty;
end
8'b10110:
begin
previousNodeX22[27] <= currentx;
previousNodeY22[27] <= currenty;
end
8'b10110:
begin
previousNodeX22[28] <= currentx;
previousNodeY22[28] <= currenty;
end
8'b10110:
begin
previousNodeX22[29] <= currentx;
previousNodeY22[29] <= currenty;
end
8'b10110:
begin
previousNodeX22[30] <= currentx;
previousNodeY22[30] <= currenty;
end
8'b10110:
begin
previousNodeX22[31] <= currentx;
previousNodeY22[31] <= currenty;
end
8'b10110:
begin
previousNodeX22[32] <= currentx;
previousNodeY22[32] <= currenty;
end
8'b10110:
begin
previousNodeX22[33] <= currentx;
previousNodeY22[33] <= currenty;
end
8'b10110:
begin
previousNodeX22[34] <= currentx;
previousNodeY22[34] <= currenty;
end
8'b10110:
begin
previousNodeX22[35] <= currentx;
previousNodeY22[35] <= currenty;
end
8'b10110:
begin
previousNodeX22[36] <= currentx;
previousNodeY22[36] <= currenty;
end
8'b10110:
begin
previousNodeX22[37] <= currentx;
previousNodeY22[37] <= currenty;
end
8'b10110:
begin
previousNodeX22[38] <= currentx;
previousNodeY22[38] <= currenty;
end
8'b10110:
begin
previousNodeX22[39] <= currentx;
previousNodeY22[39] <= currenty;
end
endcase
end
8'b10111:
begin
case(tempneighborx[neighborcounter])
8'b10111:
begin
previousNodeX23[0] <= currentx;
previousNodeY23[0] <= currenty;
end
8'b10111:
begin
previousNodeX23[1] <= currentx;
previousNodeY23[1] <= currenty;
end
8'b10111:
begin
previousNodeX23[2] <= currentx;
previousNodeY23[2] <= currenty;
end
8'b10111:
begin
previousNodeX23[3] <= currentx;
previousNodeY23[3] <= currenty;
end
8'b10111:
begin
previousNodeX23[4] <= currentx;
previousNodeY23[4] <= currenty;
end
8'b10111:
begin
previousNodeX23[5] <= currentx;
previousNodeY23[5] <= currenty;
end
8'b10111:
begin
previousNodeX23[6] <= currentx;
previousNodeY23[6] <= currenty;
end
8'b10111:
begin
previousNodeX23[7] <= currentx;
previousNodeY23[7] <= currenty;
end
8'b10111:
begin
previousNodeX23[8] <= currentx;
previousNodeY23[8] <= currenty;
end
8'b10111:
begin
previousNodeX23[9] <= currentx;
previousNodeY23[9] <= currenty;
end
8'b10111:
begin
previousNodeX23[10] <= currentx;
previousNodeY23[10] <= currenty;
end
8'b10111:
begin
previousNodeX23[11] <= currentx;
previousNodeY23[11] <= currenty;
end
8'b10111:
begin
previousNodeX23[12] <= currentx;
previousNodeY23[12] <= currenty;
end
8'b10111:
begin
previousNodeX23[13] <= currentx;
previousNodeY23[13] <= currenty;
end
8'b10111:
begin
previousNodeX23[14] <= currentx;
previousNodeY23[14] <= currenty;
end
8'b10111:
begin
previousNodeX23[15] <= currentx;
previousNodeY23[15] <= currenty;
end
8'b10111:
begin
previousNodeX23[16] <= currentx;
previousNodeY23[16] <= currenty;
end
8'b10111:
begin
previousNodeX23[17] <= currentx;
previousNodeY23[17] <= currenty;
end
8'b10111:
begin
previousNodeX23[18] <= currentx;
previousNodeY23[18] <= currenty;
end
8'b10111:
begin
previousNodeX23[19] <= currentx;
previousNodeY23[19] <= currenty;
end
8'b10111:
begin
previousNodeX23[20] <= currentx;
previousNodeY23[20] <= currenty;
end
8'b10111:
begin
previousNodeX23[21] <= currentx;
previousNodeY23[21] <= currenty;
end
8'b10111:
begin
previousNodeX23[22] <= currentx;
previousNodeY23[22] <= currenty;
end
8'b10111:
begin
previousNodeX23[23] <= currentx;
previousNodeY23[23] <= currenty;
end
8'b10111:
begin
previousNodeX23[24] <= currentx;
previousNodeY23[24] <= currenty;
end
8'b10111:
begin
previousNodeX23[25] <= currentx;
previousNodeY23[25] <= currenty;
end
8'b10111:
begin
previousNodeX23[26] <= currentx;
previousNodeY23[26] <= currenty;
end
8'b10111:
begin
previousNodeX23[27] <= currentx;
previousNodeY23[27] <= currenty;
end
8'b10111:
begin
previousNodeX23[28] <= currentx;
previousNodeY23[28] <= currenty;
end
8'b10111:
begin
previousNodeX23[29] <= currentx;
previousNodeY23[29] <= currenty;
end
8'b10111:
begin
previousNodeX23[30] <= currentx;
previousNodeY23[30] <= currenty;
end
8'b10111:
begin
previousNodeX23[31] <= currentx;
previousNodeY23[31] <= currenty;
end
8'b10111:
begin
previousNodeX23[32] <= currentx;
previousNodeY23[32] <= currenty;
end
8'b10111:
begin
previousNodeX23[33] <= currentx;
previousNodeY23[33] <= currenty;
end
8'b10111:
begin
previousNodeX23[34] <= currentx;
previousNodeY23[34] <= currenty;
end
8'b10111:
begin
previousNodeX23[35] <= currentx;
previousNodeY23[35] <= currenty;
end
8'b10111:
begin
previousNodeX23[36] <= currentx;
previousNodeY23[36] <= currenty;
end
8'b10111:
begin
previousNodeX23[37] <= currentx;
previousNodeY23[37] <= currenty;
end
8'b10111:
begin
previousNodeX23[38] <= currentx;
previousNodeY23[38] <= currenty;
end
8'b10111:
begin
previousNodeX23[39] <= currentx;
previousNodeY23[39] <= currenty;
end
endcase
end
8'b11000:
begin
case(tempneighborx[neighborcounter])
8'b11000:
begin
previousNodeX24[0] <= currentx;
previousNodeY24[0] <= currenty;
end
8'b11000:
begin
previousNodeX24[1] <= currentx;
previousNodeY24[1] <= currenty;
end
8'b11000:
begin
previousNodeX24[2] <= currentx;
previousNodeY24[2] <= currenty;
end
8'b11000:
begin
previousNodeX24[3] <= currentx;
previousNodeY24[3] <= currenty;
end
8'b11000:
begin
previousNodeX24[4] <= currentx;
previousNodeY24[4] <= currenty;
end
8'b11000:
begin
previousNodeX24[5] <= currentx;
previousNodeY24[5] <= currenty;
end
8'b11000:
begin
previousNodeX24[6] <= currentx;
previousNodeY24[6] <= currenty;
end
8'b11000:
begin
previousNodeX24[7] <= currentx;
previousNodeY24[7] <= currenty;
end
8'b11000:
begin
previousNodeX24[8] <= currentx;
previousNodeY24[8] <= currenty;
end
8'b11000:
begin
previousNodeX24[9] <= currentx;
previousNodeY24[9] <= currenty;
end
8'b11000:
begin
previousNodeX24[10] <= currentx;
previousNodeY24[10] <= currenty;
end
8'b11000:
begin
previousNodeX24[11] <= currentx;
previousNodeY24[11] <= currenty;
end
8'b11000:
begin
previousNodeX24[12] <= currentx;
previousNodeY24[12] <= currenty;
end
8'b11000:
begin
previousNodeX24[13] <= currentx;
previousNodeY24[13] <= currenty;
end
8'b11000:
begin
previousNodeX24[14] <= currentx;
previousNodeY24[14] <= currenty;
end
8'b11000:
begin
previousNodeX24[15] <= currentx;
previousNodeY24[15] <= currenty;
end
8'b11000:
begin
previousNodeX24[16] <= currentx;
previousNodeY24[16] <= currenty;
end
8'b11000:
begin
previousNodeX24[17] <= currentx;
previousNodeY24[17] <= currenty;
end
8'b11000:
begin
previousNodeX24[18] <= currentx;
previousNodeY24[18] <= currenty;
end
8'b11000:
begin
previousNodeX24[19] <= currentx;
previousNodeY24[19] <= currenty;
end
8'b11000:
begin
previousNodeX24[20] <= currentx;
previousNodeY24[20] <= currenty;
end
8'b11000:
begin
previousNodeX24[21] <= currentx;
previousNodeY24[21] <= currenty;
end
8'b11000:
begin
previousNodeX24[22] <= currentx;
previousNodeY24[22] <= currenty;
end
8'b11000:
begin
previousNodeX24[23] <= currentx;
previousNodeY24[23] <= currenty;
end
8'b11000:
begin
previousNodeX24[24] <= currentx;
previousNodeY24[24] <= currenty;
end
8'b11000:
begin
previousNodeX24[25] <= currentx;
previousNodeY24[25] <= currenty;
end
8'b11000:
begin
previousNodeX24[26] <= currentx;
previousNodeY24[26] <= currenty;
end
8'b11000:
begin
previousNodeX24[27] <= currentx;
previousNodeY24[27] <= currenty;
end
8'b11000:
begin
previousNodeX24[28] <= currentx;
previousNodeY24[28] <= currenty;
end
8'b11000:
begin
previousNodeX24[29] <= currentx;
previousNodeY24[29] <= currenty;
end
8'b11000:
begin
previousNodeX24[30] <= currentx;
previousNodeY24[30] <= currenty;
end
8'b11000:
begin
previousNodeX24[31] <= currentx;
previousNodeY24[31] <= currenty;
end
8'b11000:
begin
previousNodeX24[32] <= currentx;
previousNodeY24[32] <= currenty;
end
8'b11000:
begin
previousNodeX24[33] <= currentx;
previousNodeY24[33] <= currenty;
end
8'b11000:
begin
previousNodeX24[34] <= currentx;
previousNodeY24[34] <= currenty;
end
8'b11000:
begin
previousNodeX24[35] <= currentx;
previousNodeY24[35] <= currenty;
end
8'b11000:
begin
previousNodeX24[36] <= currentx;
previousNodeY24[36] <= currenty;
end
8'b11000:
begin
previousNodeX24[37] <= currentx;
previousNodeY24[37] <= currenty;
end
8'b11000:
begin
previousNodeX24[38] <= currentx;
previousNodeY24[38] <= currenty;
end
8'b11000:
begin
previousNodeX24[39] <= currentx;
previousNodeY24[39] <= currenty;
end
endcase
end
8'b11001:
begin
case(tempneighborx[neighborcounter])
8'b11001:
begin
previousNodeX25[0] <= currentx;
previousNodeY25[0] <= currenty;
end
8'b11001:
begin
previousNodeX25[1] <= currentx;
previousNodeY25[1] <= currenty;
end
8'b11001:
begin
previousNodeX25[2] <= currentx;
previousNodeY25[2] <= currenty;
end
8'b11001:
begin
previousNodeX25[3] <= currentx;
previousNodeY25[3] <= currenty;
end
8'b11001:
begin
previousNodeX25[4] <= currentx;
previousNodeY25[4] <= currenty;
end
8'b11001:
begin
previousNodeX25[5] <= currentx;
previousNodeY25[5] <= currenty;
end
8'b11001:
begin
previousNodeX25[6] <= currentx;
previousNodeY25[6] <= currenty;
end
8'b11001:
begin
previousNodeX25[7] <= currentx;
previousNodeY25[7] <= currenty;
end
8'b11001:
begin
previousNodeX25[8] <= currentx;
previousNodeY25[8] <= currenty;
end
8'b11001:
begin
previousNodeX25[9] <= currentx;
previousNodeY25[9] <= currenty;
end
8'b11001:
begin
previousNodeX25[10] <= currentx;
previousNodeY25[10] <= currenty;
end
8'b11001:
begin
previousNodeX25[11] <= currentx;
previousNodeY25[11] <= currenty;
end
8'b11001:
begin
previousNodeX25[12] <= currentx;
previousNodeY25[12] <= currenty;
end
8'b11001:
begin
previousNodeX25[13] <= currentx;
previousNodeY25[13] <= currenty;
end
8'b11001:
begin
previousNodeX25[14] <= currentx;
previousNodeY25[14] <= currenty;
end
8'b11001:
begin
previousNodeX25[15] <= currentx;
previousNodeY25[15] <= currenty;
end
8'b11001:
begin
previousNodeX25[16] <= currentx;
previousNodeY25[16] <= currenty;
end
8'b11001:
begin
previousNodeX25[17] <= currentx;
previousNodeY25[17] <= currenty;
end
8'b11001:
begin
previousNodeX25[18] <= currentx;
previousNodeY25[18] <= currenty;
end
8'b11001:
begin
previousNodeX25[19] <= currentx;
previousNodeY25[19] <= currenty;
end
8'b11001:
begin
previousNodeX25[20] <= currentx;
previousNodeY25[20] <= currenty;
end
8'b11001:
begin
previousNodeX25[21] <= currentx;
previousNodeY25[21] <= currenty;
end
8'b11001:
begin
previousNodeX25[22] <= currentx;
previousNodeY25[22] <= currenty;
end
8'b11001:
begin
previousNodeX25[23] <= currentx;
previousNodeY25[23] <= currenty;
end
8'b11001:
begin
previousNodeX25[24] <= currentx;
previousNodeY25[24] <= currenty;
end
8'b11001:
begin
previousNodeX25[25] <= currentx;
previousNodeY25[25] <= currenty;
end
8'b11001:
begin
previousNodeX25[26] <= currentx;
previousNodeY25[26] <= currenty;
end
8'b11001:
begin
previousNodeX25[27] <= currentx;
previousNodeY25[27] <= currenty;
end
8'b11001:
begin
previousNodeX25[28] <= currentx;
previousNodeY25[28] <= currenty;
end
8'b11001:
begin
previousNodeX25[29] <= currentx;
previousNodeY25[29] <= currenty;
end
8'b11001:
begin
previousNodeX25[30] <= currentx;
previousNodeY25[30] <= currenty;
end
8'b11001:
begin
previousNodeX25[31] <= currentx;
previousNodeY25[31] <= currenty;
end
8'b11001:
begin
previousNodeX25[32] <= currentx;
previousNodeY25[32] <= currenty;
end
8'b11001:
begin
previousNodeX25[33] <= currentx;
previousNodeY25[33] <= currenty;
end
8'b11001:
begin
previousNodeX25[34] <= currentx;
previousNodeY25[34] <= currenty;
end
8'b11001:
begin
previousNodeX25[35] <= currentx;
previousNodeY25[35] <= currenty;
end
8'b11001:
begin
previousNodeX25[36] <= currentx;
previousNodeY25[36] <= currenty;
end
8'b11001:
begin
previousNodeX25[37] <= currentx;
previousNodeY25[37] <= currenty;
end
8'b11001:
begin
previousNodeX25[38] <= currentx;
previousNodeY25[38] <= currenty;
end
8'b11001:
begin
previousNodeX25[39] <= currentx;
previousNodeY25[39] <= currenty;
end
endcase
end
8'b11010:
begin
case(tempneighborx[neighborcounter])
8'b11010:
begin
previousNodeX26[0] <= currentx;
previousNodeY26[0] <= currenty;
end
8'b11010:
begin
previousNodeX26[1] <= currentx;
previousNodeY26[1] <= currenty;
end
8'b11010:
begin
previousNodeX26[2] <= currentx;
previousNodeY26[2] <= currenty;
end
8'b11010:
begin
previousNodeX26[3] <= currentx;
previousNodeY26[3] <= currenty;
end
8'b11010:
begin
previousNodeX26[4] <= currentx;
previousNodeY26[4] <= currenty;
end
8'b11010:
begin
previousNodeX26[5] <= currentx;
previousNodeY26[5] <= currenty;
end
8'b11010:
begin
previousNodeX26[6] <= currentx;
previousNodeY26[6] <= currenty;
end
8'b11010:
begin
previousNodeX26[7] <= currentx;
previousNodeY26[7] <= currenty;
end
8'b11010:
begin
previousNodeX26[8] <= currentx;
previousNodeY26[8] <= currenty;
end
8'b11010:
begin
previousNodeX26[9] <= currentx;
previousNodeY26[9] <= currenty;
end
8'b11010:
begin
previousNodeX26[10] <= currentx;
previousNodeY26[10] <= currenty;
end
8'b11010:
begin
previousNodeX26[11] <= currentx;
previousNodeY26[11] <= currenty;
end
8'b11010:
begin
previousNodeX26[12] <= currentx;
previousNodeY26[12] <= currenty;
end
8'b11010:
begin
previousNodeX26[13] <= currentx;
previousNodeY26[13] <= currenty;
end
8'b11010:
begin
previousNodeX26[14] <= currentx;
previousNodeY26[14] <= currenty;
end
8'b11010:
begin
previousNodeX26[15] <= currentx;
previousNodeY26[15] <= currenty;
end
8'b11010:
begin
previousNodeX26[16] <= currentx;
previousNodeY26[16] <= currenty;
end
8'b11010:
begin
previousNodeX26[17] <= currentx;
previousNodeY26[17] <= currenty;
end
8'b11010:
begin
previousNodeX26[18] <= currentx;
previousNodeY26[18] <= currenty;
end
8'b11010:
begin
previousNodeX26[19] <= currentx;
previousNodeY26[19] <= currenty;
end
8'b11010:
begin
previousNodeX26[20] <= currentx;
previousNodeY26[20] <= currenty;
end
8'b11010:
begin
previousNodeX26[21] <= currentx;
previousNodeY26[21] <= currenty;
end
8'b11010:
begin
previousNodeX26[22] <= currentx;
previousNodeY26[22] <= currenty;
end
8'b11010:
begin
previousNodeX26[23] <= currentx;
previousNodeY26[23] <= currenty;
end
8'b11010:
begin
previousNodeX26[24] <= currentx;
previousNodeY26[24] <= currenty;
end
8'b11010:
begin
previousNodeX26[25] <= currentx;
previousNodeY26[25] <= currenty;
end
8'b11010:
begin
previousNodeX26[26] <= currentx;
previousNodeY26[26] <= currenty;
end
8'b11010:
begin
previousNodeX26[27] <= currentx;
previousNodeY26[27] <= currenty;
end
8'b11010:
begin
previousNodeX26[28] <= currentx;
previousNodeY26[28] <= currenty;
end
8'b11010:
begin
previousNodeX26[29] <= currentx;
previousNodeY26[29] <= currenty;
end
8'b11010:
begin
previousNodeX26[30] <= currentx;
previousNodeY26[30] <= currenty;
end
8'b11010:
begin
previousNodeX26[31] <= currentx;
previousNodeY26[31] <= currenty;
end
8'b11010:
begin
previousNodeX26[32] <= currentx;
previousNodeY26[32] <= currenty;
end
8'b11010:
begin
previousNodeX26[33] <= currentx;
previousNodeY26[33] <= currenty;
end
8'b11010:
begin
previousNodeX26[34] <= currentx;
previousNodeY26[34] <= currenty;
end
8'b11010:
begin
previousNodeX26[35] <= currentx;
previousNodeY26[35] <= currenty;
end
8'b11010:
begin
previousNodeX26[36] <= currentx;
previousNodeY26[36] <= currenty;
end
8'b11010:
begin
previousNodeX26[37] <= currentx;
previousNodeY26[37] <= currenty;
end
8'b11010:
begin
previousNodeX26[38] <= currentx;
previousNodeY26[38] <= currenty;
end
8'b11010:
begin
previousNodeX26[39] <= currentx;
previousNodeY26[39] <= currenty;
end
endcase
end
8'b11011:
begin
case(tempneighborx[neighborcounter])
8'b11011:
begin
previousNodeX27[0] <= currentx;
previousNodeY27[0] <= currenty;
end
8'b11011:
begin
previousNodeX27[1] <= currentx;
previousNodeY27[1] <= currenty;
end
8'b11011:
begin
previousNodeX27[2] <= currentx;
previousNodeY27[2] <= currenty;
end
8'b11011:
begin
previousNodeX27[3] <= currentx;
previousNodeY27[3] <= currenty;
end
8'b11011:
begin
previousNodeX27[4] <= currentx;
previousNodeY27[4] <= currenty;
end
8'b11011:
begin
previousNodeX27[5] <= currentx;
previousNodeY27[5] <= currenty;
end
8'b11011:
begin
previousNodeX27[6] <= currentx;
previousNodeY27[6] <= currenty;
end
8'b11011:
begin
previousNodeX27[7] <= currentx;
previousNodeY27[7] <= currenty;
end
8'b11011:
begin
previousNodeX27[8] <= currentx;
previousNodeY27[8] <= currenty;
end
8'b11011:
begin
previousNodeX27[9] <= currentx;
previousNodeY27[9] <= currenty;
end
8'b11011:
begin
previousNodeX27[10] <= currentx;
previousNodeY27[10] <= currenty;
end
8'b11011:
begin
previousNodeX27[11] <= currentx;
previousNodeY27[11] <= currenty;
end
8'b11011:
begin
previousNodeX27[12] <= currentx;
previousNodeY27[12] <= currenty;
end
8'b11011:
begin
previousNodeX27[13] <= currentx;
previousNodeY27[13] <= currenty;
end
8'b11011:
begin
previousNodeX27[14] <= currentx;
previousNodeY27[14] <= currenty;
end
8'b11011:
begin
previousNodeX27[15] <= currentx;
previousNodeY27[15] <= currenty;
end
8'b11011:
begin
previousNodeX27[16] <= currentx;
previousNodeY27[16] <= currenty;
end
8'b11011:
begin
previousNodeX27[17] <= currentx;
previousNodeY27[17] <= currenty;
end
8'b11011:
begin
previousNodeX27[18] <= currentx;
previousNodeY27[18] <= currenty;
end
8'b11011:
begin
previousNodeX27[19] <= currentx;
previousNodeY27[19] <= currenty;
end
8'b11011:
begin
previousNodeX27[20] <= currentx;
previousNodeY27[20] <= currenty;
end
8'b11011:
begin
previousNodeX27[21] <= currentx;
previousNodeY27[21] <= currenty;
end
8'b11011:
begin
previousNodeX27[22] <= currentx;
previousNodeY27[22] <= currenty;
end
8'b11011:
begin
previousNodeX27[23] <= currentx;
previousNodeY27[23] <= currenty;
end
8'b11011:
begin
previousNodeX27[24] <= currentx;
previousNodeY27[24] <= currenty;
end
8'b11011:
begin
previousNodeX27[25] <= currentx;
previousNodeY27[25] <= currenty;
end
8'b11011:
begin
previousNodeX27[26] <= currentx;
previousNodeY27[26] <= currenty;
end
8'b11011:
begin
previousNodeX27[27] <= currentx;
previousNodeY27[27] <= currenty;
end
8'b11011:
begin
previousNodeX27[28] <= currentx;
previousNodeY27[28] <= currenty;
end
8'b11011:
begin
previousNodeX27[29] <= currentx;
previousNodeY27[29] <= currenty;
end
8'b11011:
begin
previousNodeX27[30] <= currentx;
previousNodeY27[30] <= currenty;
end
8'b11011:
begin
previousNodeX27[31] <= currentx;
previousNodeY27[31] <= currenty;
end
8'b11011:
begin
previousNodeX27[32] <= currentx;
previousNodeY27[32] <= currenty;
end
8'b11011:
begin
previousNodeX27[33] <= currentx;
previousNodeY27[33] <= currenty;
end
8'b11011:
begin
previousNodeX27[34] <= currentx;
previousNodeY27[34] <= currenty;
end
8'b11011:
begin
previousNodeX27[35] <= currentx;
previousNodeY27[35] <= currenty;
end
8'b11011:
begin
previousNodeX27[36] <= currentx;
previousNodeY27[36] <= currenty;
end
8'b11011:
begin
previousNodeX27[37] <= currentx;
previousNodeY27[37] <= currenty;
end
8'b11011:
begin
previousNodeX27[38] <= currentx;
previousNodeY27[38] <= currenty;
end
8'b11011:
begin
previousNodeX27[39] <= currentx;
previousNodeY27[39] <= currenty;
end
endcase
end
8'b11100:
begin
case(tempneighborx[neighborcounter])
8'b11100:
begin
previousNodeX28[0] <= currentx;
previousNodeY28[0] <= currenty;
end
8'b11100:
begin
previousNodeX28[1] <= currentx;
previousNodeY28[1] <= currenty;
end
8'b11100:
begin
previousNodeX28[2] <= currentx;
previousNodeY28[2] <= currenty;
end
8'b11100:
begin
previousNodeX28[3] <= currentx;
previousNodeY28[3] <= currenty;
end
8'b11100:
begin
previousNodeX28[4] <= currentx;
previousNodeY28[4] <= currenty;
end
8'b11100:
begin
previousNodeX28[5] <= currentx;
previousNodeY28[5] <= currenty;
end
8'b11100:
begin
previousNodeX28[6] <= currentx;
previousNodeY28[6] <= currenty;
end
8'b11100:
begin
previousNodeX28[7] <= currentx;
previousNodeY28[7] <= currenty;
end
8'b11100:
begin
previousNodeX28[8] <= currentx;
previousNodeY28[8] <= currenty;
end
8'b11100:
begin
previousNodeX28[9] <= currentx;
previousNodeY28[9] <= currenty;
end
8'b11100:
begin
previousNodeX28[10] <= currentx;
previousNodeY28[10] <= currenty;
end
8'b11100:
begin
previousNodeX28[11] <= currentx;
previousNodeY28[11] <= currenty;
end
8'b11100:
begin
previousNodeX28[12] <= currentx;
previousNodeY28[12] <= currenty;
end
8'b11100:
begin
previousNodeX28[13] <= currentx;
previousNodeY28[13] <= currenty;
end
8'b11100:
begin
previousNodeX28[14] <= currentx;
previousNodeY28[14] <= currenty;
end
8'b11100:
begin
previousNodeX28[15] <= currentx;
previousNodeY28[15] <= currenty;
end
8'b11100:
begin
previousNodeX28[16] <= currentx;
previousNodeY28[16] <= currenty;
end
8'b11100:
begin
previousNodeX28[17] <= currentx;
previousNodeY28[17] <= currenty;
end
8'b11100:
begin
previousNodeX28[18] <= currentx;
previousNodeY28[18] <= currenty;
end
8'b11100:
begin
previousNodeX28[19] <= currentx;
previousNodeY28[19] <= currenty;
end
8'b11100:
begin
previousNodeX28[20] <= currentx;
previousNodeY28[20] <= currenty;
end
8'b11100:
begin
previousNodeX28[21] <= currentx;
previousNodeY28[21] <= currenty;
end
8'b11100:
begin
previousNodeX28[22] <= currentx;
previousNodeY28[22] <= currenty;
end
8'b11100:
begin
previousNodeX28[23] <= currentx;
previousNodeY28[23] <= currenty;
end
8'b11100:
begin
previousNodeX28[24] <= currentx;
previousNodeY28[24] <= currenty;
end
8'b11100:
begin
previousNodeX28[25] <= currentx;
previousNodeY28[25] <= currenty;
end
8'b11100:
begin
previousNodeX28[26] <= currentx;
previousNodeY28[26] <= currenty;
end
8'b11100:
begin
previousNodeX28[27] <= currentx;
previousNodeY28[27] <= currenty;
end
8'b11100:
begin
previousNodeX28[28] <= currentx;
previousNodeY28[28] <= currenty;
end
8'b11100:
begin
previousNodeX28[29] <= currentx;
previousNodeY28[29] <= currenty;
end
8'b11100:
begin
previousNodeX28[30] <= currentx;
previousNodeY28[30] <= currenty;
end
8'b11100:
begin
previousNodeX28[31] <= currentx;
previousNodeY28[31] <= currenty;
end
8'b11100:
begin
previousNodeX28[32] <= currentx;
previousNodeY28[32] <= currenty;
end
8'b11100:
begin
previousNodeX28[33] <= currentx;
previousNodeY28[33] <= currenty;
end
8'b11100:
begin
previousNodeX28[34] <= currentx;
previousNodeY28[34] <= currenty;
end
8'b11100:
begin
previousNodeX28[35] <= currentx;
previousNodeY28[35] <= currenty;
end
8'b11100:
begin
previousNodeX28[36] <= currentx;
previousNodeY28[36] <= currenty;
end
8'b11100:
begin
previousNodeX28[37] <= currentx;
previousNodeY28[37] <= currenty;
end
8'b11100:
begin
previousNodeX28[38] <= currentx;
previousNodeY28[38] <= currenty;
end
8'b11100:
begin
previousNodeX28[39] <= currentx;
previousNodeY28[39] <= currenty;
end
endcase
end
8'b11101:
begin
case(tempneighborx[neighborcounter])
8'b11101:
begin
previousNodeX29[0] <= currentx;
previousNodeY29[0] <= currenty;
end
8'b11101:
begin
previousNodeX29[1] <= currentx;
previousNodeY29[1] <= currenty;
end
8'b11101:
begin
previousNodeX29[2] <= currentx;
previousNodeY29[2] <= currenty;
end
8'b11101:
begin
previousNodeX29[3] <= currentx;
previousNodeY29[3] <= currenty;
end
8'b11101:
begin
previousNodeX29[4] <= currentx;
previousNodeY29[4] <= currenty;
end
8'b11101:
begin
previousNodeX29[5] <= currentx;
previousNodeY29[5] <= currenty;
end
8'b11101:
begin
previousNodeX29[6] <= currentx;
previousNodeY29[6] <= currenty;
end
8'b11101:
begin
previousNodeX29[7] <= currentx;
previousNodeY29[7] <= currenty;
end
8'b11101:
begin
previousNodeX29[8] <= currentx;
previousNodeY29[8] <= currenty;
end
8'b11101:
begin
previousNodeX29[9] <= currentx;
previousNodeY29[9] <= currenty;
end
8'b11101:
begin
previousNodeX29[10] <= currentx;
previousNodeY29[10] <= currenty;
end
8'b11101:
begin
previousNodeX29[11] <= currentx;
previousNodeY29[11] <= currenty;
end
8'b11101:
begin
previousNodeX29[12] <= currentx;
previousNodeY29[12] <= currenty;
end
8'b11101:
begin
previousNodeX29[13] <= currentx;
previousNodeY29[13] <= currenty;
end
8'b11101:
begin
previousNodeX29[14] <= currentx;
previousNodeY29[14] <= currenty;
end
8'b11101:
begin
previousNodeX29[15] <= currentx;
previousNodeY29[15] <= currenty;
end
8'b11101:
begin
previousNodeX29[16] <= currentx;
previousNodeY29[16] <= currenty;
end
8'b11101:
begin
previousNodeX29[17] <= currentx;
previousNodeY29[17] <= currenty;
end
8'b11101:
begin
previousNodeX29[18] <= currentx;
previousNodeY29[18] <= currenty;
end
8'b11101:
begin
previousNodeX29[19] <= currentx;
previousNodeY29[19] <= currenty;
end
8'b11101:
begin
previousNodeX29[20] <= currentx;
previousNodeY29[20] <= currenty;
end
8'b11101:
begin
previousNodeX29[21] <= currentx;
previousNodeY29[21] <= currenty;
end
8'b11101:
begin
previousNodeX29[22] <= currentx;
previousNodeY29[22] <= currenty;
end
8'b11101:
begin
previousNodeX29[23] <= currentx;
previousNodeY29[23] <= currenty;
end
8'b11101:
begin
previousNodeX29[24] <= currentx;
previousNodeY29[24] <= currenty;
end
8'b11101:
begin
previousNodeX29[25] <= currentx;
previousNodeY29[25] <= currenty;
end
8'b11101:
begin
previousNodeX29[26] <= currentx;
previousNodeY29[26] <= currenty;
end
8'b11101:
begin
previousNodeX29[27] <= currentx;
previousNodeY29[27] <= currenty;
end
8'b11101:
begin
previousNodeX29[28] <= currentx;
previousNodeY29[28] <= currenty;
end
8'b11101:
begin
previousNodeX29[29] <= currentx;
previousNodeY29[29] <= currenty;
end
8'b11101:
begin
previousNodeX29[30] <= currentx;
previousNodeY29[30] <= currenty;
end
8'b11101:
begin
previousNodeX29[31] <= currentx;
previousNodeY29[31] <= currenty;
end
8'b11101:
begin
previousNodeX29[32] <= currentx;
previousNodeY29[32] <= currenty;
end
8'b11101:
begin
previousNodeX29[33] <= currentx;
previousNodeY29[33] <= currenty;
end
8'b11101:
begin
previousNodeX29[34] <= currentx;
previousNodeY29[34] <= currenty;
end
8'b11101:
begin
previousNodeX29[35] <= currentx;
previousNodeY29[35] <= currenty;
end
8'b11101:
begin
previousNodeX29[36] <= currentx;
previousNodeY29[36] <= currenty;
end
8'b11101:
begin
previousNodeX29[37] <= currentx;
previousNodeY29[37] <= currenty;
end
8'b11101:
begin
previousNodeX29[38] <= currentx;
previousNodeY29[38] <= currenty;
end
8'b11101:
begin
previousNodeX29[39] <= currentx;
previousNodeY29[39] <= currenty;
end
endcase
end
8'b11110:
begin
case(tempneighborx[neighborcounter])
8'b11110:
begin
previousNodeX30[0] <= currentx;
previousNodeY30[0] <= currenty;
end
8'b11110:
begin
previousNodeX30[1] <= currentx;
previousNodeY30[1] <= currenty;
end
8'b11110:
begin
previousNodeX30[2] <= currentx;
previousNodeY30[2] <= currenty;
end
8'b11110:
begin
previousNodeX30[3] <= currentx;
previousNodeY30[3] <= currenty;
end
8'b11110:
begin
previousNodeX30[4] <= currentx;
previousNodeY30[4] <= currenty;
end
8'b11110:
begin
previousNodeX30[5] <= currentx;
previousNodeY30[5] <= currenty;
end
8'b11110:
begin
previousNodeX30[6] <= currentx;
previousNodeY30[6] <= currenty;
end
8'b11110:
begin
previousNodeX30[7] <= currentx;
previousNodeY30[7] <= currenty;
end
8'b11110:
begin
previousNodeX30[8] <= currentx;
previousNodeY30[8] <= currenty;
end
8'b11110:
begin
previousNodeX30[9] <= currentx;
previousNodeY30[9] <= currenty;
end
8'b11110:
begin
previousNodeX30[10] <= currentx;
previousNodeY30[10] <= currenty;
end
8'b11110:
begin
previousNodeX30[11] <= currentx;
previousNodeY30[11] <= currenty;
end
8'b11110:
begin
previousNodeX30[12] <= currentx;
previousNodeY30[12] <= currenty;
end
8'b11110:
begin
previousNodeX30[13] <= currentx;
previousNodeY30[13] <= currenty;
end
8'b11110:
begin
previousNodeX30[14] <= currentx;
previousNodeY30[14] <= currenty;
end
8'b11110:
begin
previousNodeX30[15] <= currentx;
previousNodeY30[15] <= currenty;
end
8'b11110:
begin
previousNodeX30[16] <= currentx;
previousNodeY30[16] <= currenty;
end
8'b11110:
begin
previousNodeX30[17] <= currentx;
previousNodeY30[17] <= currenty;
end
8'b11110:
begin
previousNodeX30[18] <= currentx;
previousNodeY30[18] <= currenty;
end
8'b11110:
begin
previousNodeX30[19] <= currentx;
previousNodeY30[19] <= currenty;
end
8'b11110:
begin
previousNodeX30[20] <= currentx;
previousNodeY30[20] <= currenty;
end
8'b11110:
begin
previousNodeX30[21] <= currentx;
previousNodeY30[21] <= currenty;
end
8'b11110:
begin
previousNodeX30[22] <= currentx;
previousNodeY30[22] <= currenty;
end
8'b11110:
begin
previousNodeX30[23] <= currentx;
previousNodeY30[23] <= currenty;
end
8'b11110:
begin
previousNodeX30[24] <= currentx;
previousNodeY30[24] <= currenty;
end
8'b11110:
begin
previousNodeX30[25] <= currentx;
previousNodeY30[25] <= currenty;
end
8'b11110:
begin
previousNodeX30[26] <= currentx;
previousNodeY30[26] <= currenty;
end
8'b11110:
begin
previousNodeX30[27] <= currentx;
previousNodeY30[27] <= currenty;
end
8'b11110:
begin
previousNodeX30[28] <= currentx;
previousNodeY30[28] <= currenty;
end
8'b11110:
begin
previousNodeX30[29] <= currentx;
previousNodeY30[29] <= currenty;
end
8'b11110:
begin
previousNodeX30[30] <= currentx;
previousNodeY30[30] <= currenty;
end
8'b11110:
begin
previousNodeX30[31] <= currentx;
previousNodeY30[31] <= currenty;
end
8'b11110:
begin
previousNodeX30[32] <= currentx;
previousNodeY30[32] <= currenty;
end
8'b11110:
begin
previousNodeX30[33] <= currentx;
previousNodeY30[33] <= currenty;
end
8'b11110:
begin
previousNodeX30[34] <= currentx;
previousNodeY30[34] <= currenty;
end
8'b11110:
begin
previousNodeX30[35] <= currentx;
previousNodeY30[35] <= currenty;
end
8'b11110:
begin
previousNodeX30[36] <= currentx;
previousNodeY30[36] <= currenty;
end
8'b11110:
begin
previousNodeX30[37] <= currentx;
previousNodeY30[37] <= currenty;
end
8'b11110:
begin
previousNodeX30[38] <= currentx;
previousNodeY30[38] <= currenty;
end
8'b11110:
begin
previousNodeX30[39] <= currentx;
previousNodeY30[39] <= currenty;
end
endcase
end
8'b11111:
begin
case(tempneighborx[neighborcounter])
8'b11111:
begin
previousNodeX31[0] <= currentx;
previousNodeY31[0] <= currenty;
end
8'b11111:
begin
previousNodeX31[1] <= currentx;
previousNodeY31[1] <= currenty;
end
8'b11111:
begin
previousNodeX31[2] <= currentx;
previousNodeY31[2] <= currenty;
end
8'b11111:
begin
previousNodeX31[3] <= currentx;
previousNodeY31[3] <= currenty;
end
8'b11111:
begin
previousNodeX31[4] <= currentx;
previousNodeY31[4] <= currenty;
end
8'b11111:
begin
previousNodeX31[5] <= currentx;
previousNodeY31[5] <= currenty;
end
8'b11111:
begin
previousNodeX31[6] <= currentx;
previousNodeY31[6] <= currenty;
end
8'b11111:
begin
previousNodeX31[7] <= currentx;
previousNodeY31[7] <= currenty;
end
8'b11111:
begin
previousNodeX31[8] <= currentx;
previousNodeY31[8] <= currenty;
end
8'b11111:
begin
previousNodeX31[9] <= currentx;
previousNodeY31[9] <= currenty;
end
8'b11111:
begin
previousNodeX31[10] <= currentx;
previousNodeY31[10] <= currenty;
end
8'b11111:
begin
previousNodeX31[11] <= currentx;
previousNodeY31[11] <= currenty;
end
8'b11111:
begin
previousNodeX31[12] <= currentx;
previousNodeY31[12] <= currenty;
end
8'b11111:
begin
previousNodeX31[13] <= currentx;
previousNodeY31[13] <= currenty;
end
8'b11111:
begin
previousNodeX31[14] <= currentx;
previousNodeY31[14] <= currenty;
end
8'b11111:
begin
previousNodeX31[15] <= currentx;
previousNodeY31[15] <= currenty;
end
8'b11111:
begin
previousNodeX31[16] <= currentx;
previousNodeY31[16] <= currenty;
end
8'b11111:
begin
previousNodeX31[17] <= currentx;
previousNodeY31[17] <= currenty;
end
8'b11111:
begin
previousNodeX31[18] <= currentx;
previousNodeY31[18] <= currenty;
end
8'b11111:
begin
previousNodeX31[19] <= currentx;
previousNodeY31[19] <= currenty;
end
8'b11111:
begin
previousNodeX31[20] <= currentx;
previousNodeY31[20] <= currenty;
end
8'b11111:
begin
previousNodeX31[21] <= currentx;
previousNodeY31[21] <= currenty;
end
8'b11111:
begin
previousNodeX31[22] <= currentx;
previousNodeY31[22] <= currenty;
end
8'b11111:
begin
previousNodeX31[23] <= currentx;
previousNodeY31[23] <= currenty;
end
8'b11111:
begin
previousNodeX31[24] <= currentx;
previousNodeY31[24] <= currenty;
end
8'b11111:
begin
previousNodeX31[25] <= currentx;
previousNodeY31[25] <= currenty;
end
8'b11111:
begin
previousNodeX31[26] <= currentx;
previousNodeY31[26] <= currenty;
end
8'b11111:
begin
previousNodeX31[27] <= currentx;
previousNodeY31[27] <= currenty;
end
8'b11111:
begin
previousNodeX31[28] <= currentx;
previousNodeY31[28] <= currenty;
end
8'b11111:
begin
previousNodeX31[29] <= currentx;
previousNodeY31[29] <= currenty;
end
8'b11111:
begin
previousNodeX31[30] <= currentx;
previousNodeY31[30] <= currenty;
end
8'b11111:
begin
previousNodeX31[31] <= currentx;
previousNodeY31[31] <= currenty;
end
8'b11111:
begin
previousNodeX31[32] <= currentx;
previousNodeY31[32] <= currenty;
end
8'b11111:
begin
previousNodeX31[33] <= currentx;
previousNodeY31[33] <= currenty;
end
8'b11111:
begin
previousNodeX31[34] <= currentx;
previousNodeY31[34] <= currenty;
end
8'b11111:
begin
previousNodeX31[35] <= currentx;
previousNodeY31[35] <= currenty;
end
8'b11111:
begin
previousNodeX31[36] <= currentx;
previousNodeY31[36] <= currenty;
end
8'b11111:
begin
previousNodeX31[37] <= currentx;
previousNodeY31[37] <= currenty;
end
8'b11111:
begin
previousNodeX31[38] <= currentx;
previousNodeY31[38] <= currenty;
end
8'b11111:
begin
previousNodeX31[39] <= currentx;
previousNodeY31[39] <= currenty;
end
endcase
end
8'b100000:
begin
case(tempneighborx[neighborcounter])
8'b100000:
begin
previousNodeX32[0] <= currentx;
previousNodeY32[0] <= currenty;
end
8'b100000:
begin
previousNodeX32[1] <= currentx;
previousNodeY32[1] <= currenty;
end
8'b100000:
begin
previousNodeX32[2] <= currentx;
previousNodeY32[2] <= currenty;
end
8'b100000:
begin
previousNodeX32[3] <= currentx;
previousNodeY32[3] <= currenty;
end
8'b100000:
begin
previousNodeX32[4] <= currentx;
previousNodeY32[4] <= currenty;
end
8'b100000:
begin
previousNodeX32[5] <= currentx;
previousNodeY32[5] <= currenty;
end
8'b100000:
begin
previousNodeX32[6] <= currentx;
previousNodeY32[6] <= currenty;
end
8'b100000:
begin
previousNodeX32[7] <= currentx;
previousNodeY32[7] <= currenty;
end
8'b100000:
begin
previousNodeX32[8] <= currentx;
previousNodeY32[8] <= currenty;
end
8'b100000:
begin
previousNodeX32[9] <= currentx;
previousNodeY32[9] <= currenty;
end
8'b100000:
begin
previousNodeX32[10] <= currentx;
previousNodeY32[10] <= currenty;
end
8'b100000:
begin
previousNodeX32[11] <= currentx;
previousNodeY32[11] <= currenty;
end
8'b100000:
begin
previousNodeX32[12] <= currentx;
previousNodeY32[12] <= currenty;
end
8'b100000:
begin
previousNodeX32[13] <= currentx;
previousNodeY32[13] <= currenty;
end
8'b100000:
begin
previousNodeX32[14] <= currentx;
previousNodeY32[14] <= currenty;
end
8'b100000:
begin
previousNodeX32[15] <= currentx;
previousNodeY32[15] <= currenty;
end
8'b100000:
begin
previousNodeX32[16] <= currentx;
previousNodeY32[16] <= currenty;
end
8'b100000:
begin
previousNodeX32[17] <= currentx;
previousNodeY32[17] <= currenty;
end
8'b100000:
begin
previousNodeX32[18] <= currentx;
previousNodeY32[18] <= currenty;
end
8'b100000:
begin
previousNodeX32[19] <= currentx;
previousNodeY32[19] <= currenty;
end
8'b100000:
begin
previousNodeX32[20] <= currentx;
previousNodeY32[20] <= currenty;
end
8'b100000:
begin
previousNodeX32[21] <= currentx;
previousNodeY32[21] <= currenty;
end
8'b100000:
begin
previousNodeX32[22] <= currentx;
previousNodeY32[22] <= currenty;
end
8'b100000:
begin
previousNodeX32[23] <= currentx;
previousNodeY32[23] <= currenty;
end
8'b100000:
begin
previousNodeX32[24] <= currentx;
previousNodeY32[24] <= currenty;
end
8'b100000:
begin
previousNodeX32[25] <= currentx;
previousNodeY32[25] <= currenty;
end
8'b100000:
begin
previousNodeX32[26] <= currentx;
previousNodeY32[26] <= currenty;
end
8'b100000:
begin
previousNodeX32[27] <= currentx;
previousNodeY32[27] <= currenty;
end
8'b100000:
begin
previousNodeX32[28] <= currentx;
previousNodeY32[28] <= currenty;
end
8'b100000:
begin
previousNodeX32[29] <= currentx;
previousNodeY32[29] <= currenty;
end
8'b100000:
begin
previousNodeX32[30] <= currentx;
previousNodeY32[30] <= currenty;
end
8'b100000:
begin
previousNodeX32[31] <= currentx;
previousNodeY32[31] <= currenty;
end
8'b100000:
begin
previousNodeX32[32] <= currentx;
previousNodeY32[32] <= currenty;
end
8'b100000:
begin
previousNodeX32[33] <= currentx;
previousNodeY32[33] <= currenty;
end
8'b100000:
begin
previousNodeX32[34] <= currentx;
previousNodeY32[34] <= currenty;
end
8'b100000:
begin
previousNodeX32[35] <= currentx;
previousNodeY32[35] <= currenty;
end
8'b100000:
begin
previousNodeX32[36] <= currentx;
previousNodeY32[36] <= currenty;
end
8'b100000:
begin
previousNodeX32[37] <= currentx;
previousNodeY32[37] <= currenty;
end
8'b100000:
begin
previousNodeX32[38] <= currentx;
previousNodeY32[38] <= currenty;
end
8'b100000:
begin
previousNodeX32[39] <= currentx;
previousNodeY32[39] <= currenty;
end
endcase
end
8'b100001:
begin
case(tempneighborx[neighborcounter])
8'b100001:
begin
previousNodeX33[0] <= currentx;
previousNodeY33[0] <= currenty;
end
8'b100001:
begin
previousNodeX33[1] <= currentx;
previousNodeY33[1] <= currenty;
end
8'b100001:
begin
previousNodeX33[2] <= currentx;
previousNodeY33[2] <= currenty;
end
8'b100001:
begin
previousNodeX33[3] <= currentx;
previousNodeY33[3] <= currenty;
end
8'b100001:
begin
previousNodeX33[4] <= currentx;
previousNodeY33[4] <= currenty;
end
8'b100001:
begin
previousNodeX33[5] <= currentx;
previousNodeY33[5] <= currenty;
end
8'b100001:
begin
previousNodeX33[6] <= currentx;
previousNodeY33[6] <= currenty;
end
8'b100001:
begin
previousNodeX33[7] <= currentx;
previousNodeY33[7] <= currenty;
end
8'b100001:
begin
previousNodeX33[8] <= currentx;
previousNodeY33[8] <= currenty;
end
8'b100001:
begin
previousNodeX33[9] <= currentx;
previousNodeY33[9] <= currenty;
end
8'b100001:
begin
previousNodeX33[10] <= currentx;
previousNodeY33[10] <= currenty;
end
8'b100001:
begin
previousNodeX33[11] <= currentx;
previousNodeY33[11] <= currenty;
end
8'b100001:
begin
previousNodeX33[12] <= currentx;
previousNodeY33[12] <= currenty;
end
8'b100001:
begin
previousNodeX33[13] <= currentx;
previousNodeY33[13] <= currenty;
end
8'b100001:
begin
previousNodeX33[14] <= currentx;
previousNodeY33[14] <= currenty;
end
8'b100001:
begin
previousNodeX33[15] <= currentx;
previousNodeY33[15] <= currenty;
end
8'b100001:
begin
previousNodeX33[16] <= currentx;
previousNodeY33[16] <= currenty;
end
8'b100001:
begin
previousNodeX33[17] <= currentx;
previousNodeY33[17] <= currenty;
end
8'b100001:
begin
previousNodeX33[18] <= currentx;
previousNodeY33[18] <= currenty;
end
8'b100001:
begin
previousNodeX33[19] <= currentx;
previousNodeY33[19] <= currenty;
end
8'b100001:
begin
previousNodeX33[20] <= currentx;
previousNodeY33[20] <= currenty;
end
8'b100001:
begin
previousNodeX33[21] <= currentx;
previousNodeY33[21] <= currenty;
end
8'b100001:
begin
previousNodeX33[22] <= currentx;
previousNodeY33[22] <= currenty;
end
8'b100001:
begin
previousNodeX33[23] <= currentx;
previousNodeY33[23] <= currenty;
end
8'b100001:
begin
previousNodeX33[24] <= currentx;
previousNodeY33[24] <= currenty;
end
8'b100001:
begin
previousNodeX33[25] <= currentx;
previousNodeY33[25] <= currenty;
end
8'b100001:
begin
previousNodeX33[26] <= currentx;
previousNodeY33[26] <= currenty;
end
8'b100001:
begin
previousNodeX33[27] <= currentx;
previousNodeY33[27] <= currenty;
end
8'b100001:
begin
previousNodeX33[28] <= currentx;
previousNodeY33[28] <= currenty;
end
8'b100001:
begin
previousNodeX33[29] <= currentx;
previousNodeY33[29] <= currenty;
end
8'b100001:
begin
previousNodeX33[30] <= currentx;
previousNodeY33[30] <= currenty;
end
8'b100001:
begin
previousNodeX33[31] <= currentx;
previousNodeY33[31] <= currenty;
end
8'b100001:
begin
previousNodeX33[32] <= currentx;
previousNodeY33[32] <= currenty;
end
8'b100001:
begin
previousNodeX33[33] <= currentx;
previousNodeY33[33] <= currenty;
end
8'b100001:
begin
previousNodeX33[34] <= currentx;
previousNodeY33[34] <= currenty;
end
8'b100001:
begin
previousNodeX33[35] <= currentx;
previousNodeY33[35] <= currenty;
end
8'b100001:
begin
previousNodeX33[36] <= currentx;
previousNodeY33[36] <= currenty;
end
8'b100001:
begin
previousNodeX33[37] <= currentx;
previousNodeY33[37] <= currenty;
end
8'b100001:
begin
previousNodeX33[38] <= currentx;
previousNodeY33[38] <= currenty;
end
8'b100001:
begin
previousNodeX33[39] <= currentx;
previousNodeY33[39] <= currenty;
end
endcase
end
8'b100010:
begin
case(tempneighborx[neighborcounter])
8'b100010:
begin
previousNodeX34[0] <= currentx;
previousNodeY34[0] <= currenty;
end
8'b100010:
begin
previousNodeX34[1] <= currentx;
previousNodeY34[1] <= currenty;
end
8'b100010:
begin
previousNodeX34[2] <= currentx;
previousNodeY34[2] <= currenty;
end
8'b100010:
begin
previousNodeX34[3] <= currentx;
previousNodeY34[3] <= currenty;
end
8'b100010:
begin
previousNodeX34[4] <= currentx;
previousNodeY34[4] <= currenty;
end
8'b100010:
begin
previousNodeX34[5] <= currentx;
previousNodeY34[5] <= currenty;
end
8'b100010:
begin
previousNodeX34[6] <= currentx;
previousNodeY34[6] <= currenty;
end
8'b100010:
begin
previousNodeX34[7] <= currentx;
previousNodeY34[7] <= currenty;
end
8'b100010:
begin
previousNodeX34[8] <= currentx;
previousNodeY34[8] <= currenty;
end
8'b100010:
begin
previousNodeX34[9] <= currentx;
previousNodeY34[9] <= currenty;
end
8'b100010:
begin
previousNodeX34[10] <= currentx;
previousNodeY34[10] <= currenty;
end
8'b100010:
begin
previousNodeX34[11] <= currentx;
previousNodeY34[11] <= currenty;
end
8'b100010:
begin
previousNodeX34[12] <= currentx;
previousNodeY34[12] <= currenty;
end
8'b100010:
begin
previousNodeX34[13] <= currentx;
previousNodeY34[13] <= currenty;
end
8'b100010:
begin
previousNodeX34[14] <= currentx;
previousNodeY34[14] <= currenty;
end
8'b100010:
begin
previousNodeX34[15] <= currentx;
previousNodeY34[15] <= currenty;
end
8'b100010:
begin
previousNodeX34[16] <= currentx;
previousNodeY34[16] <= currenty;
end
8'b100010:
begin
previousNodeX34[17] <= currentx;
previousNodeY34[17] <= currenty;
end
8'b100010:
begin
previousNodeX34[18] <= currentx;
previousNodeY34[18] <= currenty;
end
8'b100010:
begin
previousNodeX34[19] <= currentx;
previousNodeY34[19] <= currenty;
end
8'b100010:
begin
previousNodeX34[20] <= currentx;
previousNodeY34[20] <= currenty;
end
8'b100010:
begin
previousNodeX34[21] <= currentx;
previousNodeY34[21] <= currenty;
end
8'b100010:
begin
previousNodeX34[22] <= currentx;
previousNodeY34[22] <= currenty;
end
8'b100010:
begin
previousNodeX34[23] <= currentx;
previousNodeY34[23] <= currenty;
end
8'b100010:
begin
previousNodeX34[24] <= currentx;
previousNodeY34[24] <= currenty;
end
8'b100010:
begin
previousNodeX34[25] <= currentx;
previousNodeY34[25] <= currenty;
end
8'b100010:
begin
previousNodeX34[26] <= currentx;
previousNodeY34[26] <= currenty;
end
8'b100010:
begin
previousNodeX34[27] <= currentx;
previousNodeY34[27] <= currenty;
end
8'b100010:
begin
previousNodeX34[28] <= currentx;
previousNodeY34[28] <= currenty;
end
8'b100010:
begin
previousNodeX34[29] <= currentx;
previousNodeY34[29] <= currenty;
end
8'b100010:
begin
previousNodeX34[30] <= currentx;
previousNodeY34[30] <= currenty;
end
8'b100010:
begin
previousNodeX34[31] <= currentx;
previousNodeY34[31] <= currenty;
end
8'b100010:
begin
previousNodeX34[32] <= currentx;
previousNodeY34[32] <= currenty;
end
8'b100010:
begin
previousNodeX34[33] <= currentx;
previousNodeY34[33] <= currenty;
end
8'b100010:
begin
previousNodeX34[34] <= currentx;
previousNodeY34[34] <= currenty;
end
8'b100010:
begin
previousNodeX34[35] <= currentx;
previousNodeY34[35] <= currenty;
end
8'b100010:
begin
previousNodeX34[36] <= currentx;
previousNodeY34[36] <= currenty;
end
8'b100010:
begin
previousNodeX34[37] <= currentx;
previousNodeY34[37] <= currenty;
end
8'b100010:
begin
previousNodeX34[38] <= currentx;
previousNodeY34[38] <= currenty;
end
8'b100010:
begin
previousNodeX34[39] <= currentx;
previousNodeY34[39] <= currenty;
end
endcase
end
8'b100011:
begin
case(tempneighborx[neighborcounter])
8'b100011:
begin
previousNodeX35[0] <= currentx;
previousNodeY35[0] <= currenty;
end
8'b100011:
begin
previousNodeX35[1] <= currentx;
previousNodeY35[1] <= currenty;
end
8'b100011:
begin
previousNodeX35[2] <= currentx;
previousNodeY35[2] <= currenty;
end
8'b100011:
begin
previousNodeX35[3] <= currentx;
previousNodeY35[3] <= currenty;
end
8'b100011:
begin
previousNodeX35[4] <= currentx;
previousNodeY35[4] <= currenty;
end
8'b100011:
begin
previousNodeX35[5] <= currentx;
previousNodeY35[5] <= currenty;
end
8'b100011:
begin
previousNodeX35[6] <= currentx;
previousNodeY35[6] <= currenty;
end
8'b100011:
begin
previousNodeX35[7] <= currentx;
previousNodeY35[7] <= currenty;
end
8'b100011:
begin
previousNodeX35[8] <= currentx;
previousNodeY35[8] <= currenty;
end
8'b100011:
begin
previousNodeX35[9] <= currentx;
previousNodeY35[9] <= currenty;
end
8'b100011:
begin
previousNodeX35[10] <= currentx;
previousNodeY35[10] <= currenty;
end
8'b100011:
begin
previousNodeX35[11] <= currentx;
previousNodeY35[11] <= currenty;
end
8'b100011:
begin
previousNodeX35[12] <= currentx;
previousNodeY35[12] <= currenty;
end
8'b100011:
begin
previousNodeX35[13] <= currentx;
previousNodeY35[13] <= currenty;
end
8'b100011:
begin
previousNodeX35[14] <= currentx;
previousNodeY35[14] <= currenty;
end
8'b100011:
begin
previousNodeX35[15] <= currentx;
previousNodeY35[15] <= currenty;
end
8'b100011:
begin
previousNodeX35[16] <= currentx;
previousNodeY35[16] <= currenty;
end
8'b100011:
begin
previousNodeX35[17] <= currentx;
previousNodeY35[17] <= currenty;
end
8'b100011:
begin
previousNodeX35[18] <= currentx;
previousNodeY35[18] <= currenty;
end
8'b100011:
begin
previousNodeX35[19] <= currentx;
previousNodeY35[19] <= currenty;
end
8'b100011:
begin
previousNodeX35[20] <= currentx;
previousNodeY35[20] <= currenty;
end
8'b100011:
begin
previousNodeX35[21] <= currentx;
previousNodeY35[21] <= currenty;
end
8'b100011:
begin
previousNodeX35[22] <= currentx;
previousNodeY35[22] <= currenty;
end
8'b100011:
begin
previousNodeX35[23] <= currentx;
previousNodeY35[23] <= currenty;
end
8'b100011:
begin
previousNodeX35[24] <= currentx;
previousNodeY35[24] <= currenty;
end
8'b100011:
begin
previousNodeX35[25] <= currentx;
previousNodeY35[25] <= currenty;
end
8'b100011:
begin
previousNodeX35[26] <= currentx;
previousNodeY35[26] <= currenty;
end
8'b100011:
begin
previousNodeX35[27] <= currentx;
previousNodeY35[27] <= currenty;
end
8'b100011:
begin
previousNodeX35[28] <= currentx;
previousNodeY35[28] <= currenty;
end
8'b100011:
begin
previousNodeX35[29] <= currentx;
previousNodeY35[29] <= currenty;
end
8'b100011:
begin
previousNodeX35[30] <= currentx;
previousNodeY35[30] <= currenty;
end
8'b100011:
begin
previousNodeX35[31] <= currentx;
previousNodeY35[31] <= currenty;
end
8'b100011:
begin
previousNodeX35[32] <= currentx;
previousNodeY35[32] <= currenty;
end
8'b100011:
begin
previousNodeX35[33] <= currentx;
previousNodeY35[33] <= currenty;
end
8'b100011:
begin
previousNodeX35[34] <= currentx;
previousNodeY35[34] <= currenty;
end
8'b100011:
begin
previousNodeX35[35] <= currentx;
previousNodeY35[35] <= currenty;
end
8'b100011:
begin
previousNodeX35[36] <= currentx;
previousNodeY35[36] <= currenty;
end
8'b100011:
begin
previousNodeX35[37] <= currentx;
previousNodeY35[37] <= currenty;
end
8'b100011:
begin
previousNodeX35[38] <= currentx;
previousNodeY35[38] <= currenty;
end
8'b100011:
begin
previousNodeX35[39] <= currentx;
previousNodeY35[39] <= currenty;
end
endcase
end
8'b100100:
begin
case(tempneighborx[neighborcounter])
8'b100100:
begin
previousNodeX36[0] <= currentx;
previousNodeY36[0] <= currenty;
end
8'b100100:
begin
previousNodeX36[1] <= currentx;
previousNodeY36[1] <= currenty;
end
8'b100100:
begin
previousNodeX36[2] <= currentx;
previousNodeY36[2] <= currenty;
end
8'b100100:
begin
previousNodeX36[3] <= currentx;
previousNodeY36[3] <= currenty;
end
8'b100100:
begin
previousNodeX36[4] <= currentx;
previousNodeY36[4] <= currenty;
end
8'b100100:
begin
previousNodeX36[5] <= currentx;
previousNodeY36[5] <= currenty;
end
8'b100100:
begin
previousNodeX36[6] <= currentx;
previousNodeY36[6] <= currenty;
end
8'b100100:
begin
previousNodeX36[7] <= currentx;
previousNodeY36[7] <= currenty;
end
8'b100100:
begin
previousNodeX36[8] <= currentx;
previousNodeY36[8] <= currenty;
end
8'b100100:
begin
previousNodeX36[9] <= currentx;
previousNodeY36[9] <= currenty;
end
8'b100100:
begin
previousNodeX36[10] <= currentx;
previousNodeY36[10] <= currenty;
end
8'b100100:
begin
previousNodeX36[11] <= currentx;
previousNodeY36[11] <= currenty;
end
8'b100100:
begin
previousNodeX36[12] <= currentx;
previousNodeY36[12] <= currenty;
end
8'b100100:
begin
previousNodeX36[13] <= currentx;
previousNodeY36[13] <= currenty;
end
8'b100100:
begin
previousNodeX36[14] <= currentx;
previousNodeY36[14] <= currenty;
end
8'b100100:
begin
previousNodeX36[15] <= currentx;
previousNodeY36[15] <= currenty;
end
8'b100100:
begin
previousNodeX36[16] <= currentx;
previousNodeY36[16] <= currenty;
end
8'b100100:
begin
previousNodeX36[17] <= currentx;
previousNodeY36[17] <= currenty;
end
8'b100100:
begin
previousNodeX36[18] <= currentx;
previousNodeY36[18] <= currenty;
end
8'b100100:
begin
previousNodeX36[19] <= currentx;
previousNodeY36[19] <= currenty;
end
8'b100100:
begin
previousNodeX36[20] <= currentx;
previousNodeY36[20] <= currenty;
end
8'b100100:
begin
previousNodeX36[21] <= currentx;
previousNodeY36[21] <= currenty;
end
8'b100100:
begin
previousNodeX36[22] <= currentx;
previousNodeY36[22] <= currenty;
end
8'b100100:
begin
previousNodeX36[23] <= currentx;
previousNodeY36[23] <= currenty;
end
8'b100100:
begin
previousNodeX36[24] <= currentx;
previousNodeY36[24] <= currenty;
end
8'b100100:
begin
previousNodeX36[25] <= currentx;
previousNodeY36[25] <= currenty;
end
8'b100100:
begin
previousNodeX36[26] <= currentx;
previousNodeY36[26] <= currenty;
end
8'b100100:
begin
previousNodeX36[27] <= currentx;
previousNodeY36[27] <= currenty;
end
8'b100100:
begin
previousNodeX36[28] <= currentx;
previousNodeY36[28] <= currenty;
end
8'b100100:
begin
previousNodeX36[29] <= currentx;
previousNodeY36[29] <= currenty;
end
8'b100100:
begin
previousNodeX36[30] <= currentx;
previousNodeY36[30] <= currenty;
end
8'b100100:
begin
previousNodeX36[31] <= currentx;
previousNodeY36[31] <= currenty;
end
8'b100100:
begin
previousNodeX36[32] <= currentx;
previousNodeY36[32] <= currenty;
end
8'b100100:
begin
previousNodeX36[33] <= currentx;
previousNodeY36[33] <= currenty;
end
8'b100100:
begin
previousNodeX36[34] <= currentx;
previousNodeY36[34] <= currenty;
end
8'b100100:
begin
previousNodeX36[35] <= currentx;
previousNodeY36[35] <= currenty;
end
8'b100100:
begin
previousNodeX36[36] <= currentx;
previousNodeY36[36] <= currenty;
end
8'b100100:
begin
previousNodeX36[37] <= currentx;
previousNodeY36[37] <= currenty;
end
8'b100100:
begin
previousNodeX36[38] <= currentx;
previousNodeY36[38] <= currenty;
end
8'b100100:
begin
previousNodeX36[39] <= currentx;
previousNodeY36[39] <= currenty;
end
endcase
end
8'b100101:
begin
case(tempneighborx[neighborcounter])
8'b100101:
begin
previousNodeX37[0] <= currentx;
previousNodeY37[0] <= currenty;
end
8'b100101:
begin
previousNodeX37[1] <= currentx;
previousNodeY37[1] <= currenty;
end
8'b100101:
begin
previousNodeX37[2] <= currentx;
previousNodeY37[2] <= currenty;
end
8'b100101:
begin
previousNodeX37[3] <= currentx;
previousNodeY37[3] <= currenty;
end
8'b100101:
begin
previousNodeX37[4] <= currentx;
previousNodeY37[4] <= currenty;
end
8'b100101:
begin
previousNodeX37[5] <= currentx;
previousNodeY37[5] <= currenty;
end
8'b100101:
begin
previousNodeX37[6] <= currentx;
previousNodeY37[6] <= currenty;
end
8'b100101:
begin
previousNodeX37[7] <= currentx;
previousNodeY37[7] <= currenty;
end
8'b100101:
begin
previousNodeX37[8] <= currentx;
previousNodeY37[8] <= currenty;
end
8'b100101:
begin
previousNodeX37[9] <= currentx;
previousNodeY37[9] <= currenty;
end
8'b100101:
begin
previousNodeX37[10] <= currentx;
previousNodeY37[10] <= currenty;
end
8'b100101:
begin
previousNodeX37[11] <= currentx;
previousNodeY37[11] <= currenty;
end
8'b100101:
begin
previousNodeX37[12] <= currentx;
previousNodeY37[12] <= currenty;
end
8'b100101:
begin
previousNodeX37[13] <= currentx;
previousNodeY37[13] <= currenty;
end
8'b100101:
begin
previousNodeX37[14] <= currentx;
previousNodeY37[14] <= currenty;
end
8'b100101:
begin
previousNodeX37[15] <= currentx;
previousNodeY37[15] <= currenty;
end
8'b100101:
begin
previousNodeX37[16] <= currentx;
previousNodeY37[16] <= currenty;
end
8'b100101:
begin
previousNodeX37[17] <= currentx;
previousNodeY37[17] <= currenty;
end
8'b100101:
begin
previousNodeX37[18] <= currentx;
previousNodeY37[18] <= currenty;
end
8'b100101:
begin
previousNodeX37[19] <= currentx;
previousNodeY37[19] <= currenty;
end
8'b100101:
begin
previousNodeX37[20] <= currentx;
previousNodeY37[20] <= currenty;
end
8'b100101:
begin
previousNodeX37[21] <= currentx;
previousNodeY37[21] <= currenty;
end
8'b100101:
begin
previousNodeX37[22] <= currentx;
previousNodeY37[22] <= currenty;
end
8'b100101:
begin
previousNodeX37[23] <= currentx;
previousNodeY37[23] <= currenty;
end
8'b100101:
begin
previousNodeX37[24] <= currentx;
previousNodeY37[24] <= currenty;
end
8'b100101:
begin
previousNodeX37[25] <= currentx;
previousNodeY37[25] <= currenty;
end
8'b100101:
begin
previousNodeX37[26] <= currentx;
previousNodeY37[26] <= currenty;
end
8'b100101:
begin
previousNodeX37[27] <= currentx;
previousNodeY37[27] <= currenty;
end
8'b100101:
begin
previousNodeX37[28] <= currentx;
previousNodeY37[28] <= currenty;
end
8'b100101:
begin
previousNodeX37[29] <= currentx;
previousNodeY37[29] <= currenty;
end
8'b100101:
begin
previousNodeX37[30] <= currentx;
previousNodeY37[30] <= currenty;
end
8'b100101:
begin
previousNodeX37[31] <= currentx;
previousNodeY37[31] <= currenty;
end
8'b100101:
begin
previousNodeX37[32] <= currentx;
previousNodeY37[32] <= currenty;
end
8'b100101:
begin
previousNodeX37[33] <= currentx;
previousNodeY37[33] <= currenty;
end
8'b100101:
begin
previousNodeX37[34] <= currentx;
previousNodeY37[34] <= currenty;
end
8'b100101:
begin
previousNodeX37[35] <= currentx;
previousNodeY37[35] <= currenty;
end
8'b100101:
begin
previousNodeX37[36] <= currentx;
previousNodeY37[36] <= currenty;
end
8'b100101:
begin
previousNodeX37[37] <= currentx;
previousNodeY37[37] <= currenty;
end
8'b100101:
begin
previousNodeX37[38] <= currentx;
previousNodeY37[38] <= currenty;
end
8'b100101:
begin
previousNodeX37[39] <= currentx;
previousNodeY37[39] <= currenty;
end
endcase
end
8'b100110:
begin
case(tempneighborx[neighborcounter])
8'b100110:
begin
previousNodeX38[0] <= currentx;
previousNodeY38[0] <= currenty;
end
8'b100110:
begin
previousNodeX38[1] <= currentx;
previousNodeY38[1] <= currenty;
end
8'b100110:
begin
previousNodeX38[2] <= currentx;
previousNodeY38[2] <= currenty;
end
8'b100110:
begin
previousNodeX38[3] <= currentx;
previousNodeY38[3] <= currenty;
end
8'b100110:
begin
previousNodeX38[4] <= currentx;
previousNodeY38[4] <= currenty;
end
8'b100110:
begin
previousNodeX38[5] <= currentx;
previousNodeY38[5] <= currenty;
end
8'b100110:
begin
previousNodeX38[6] <= currentx;
previousNodeY38[6] <= currenty;
end
8'b100110:
begin
previousNodeX38[7] <= currentx;
previousNodeY38[7] <= currenty;
end
8'b100110:
begin
previousNodeX38[8] <= currentx;
previousNodeY38[8] <= currenty;
end
8'b100110:
begin
previousNodeX38[9] <= currentx;
previousNodeY38[9] <= currenty;
end
8'b100110:
begin
previousNodeX38[10] <= currentx;
previousNodeY38[10] <= currenty;
end
8'b100110:
begin
previousNodeX38[11] <= currentx;
previousNodeY38[11] <= currenty;
end
8'b100110:
begin
previousNodeX38[12] <= currentx;
previousNodeY38[12] <= currenty;
end
8'b100110:
begin
previousNodeX38[13] <= currentx;
previousNodeY38[13] <= currenty;
end
8'b100110:
begin
previousNodeX38[14] <= currentx;
previousNodeY38[14] <= currenty;
end
8'b100110:
begin
previousNodeX38[15] <= currentx;
previousNodeY38[15] <= currenty;
end
8'b100110:
begin
previousNodeX38[16] <= currentx;
previousNodeY38[16] <= currenty;
end
8'b100110:
begin
previousNodeX38[17] <= currentx;
previousNodeY38[17] <= currenty;
end
8'b100110:
begin
previousNodeX38[18] <= currentx;
previousNodeY38[18] <= currenty;
end
8'b100110:
begin
previousNodeX38[19] <= currentx;
previousNodeY38[19] <= currenty;
end
8'b100110:
begin
previousNodeX38[20] <= currentx;
previousNodeY38[20] <= currenty;
end
8'b100110:
begin
previousNodeX38[21] <= currentx;
previousNodeY38[21] <= currenty;
end
8'b100110:
begin
previousNodeX38[22] <= currentx;
previousNodeY38[22] <= currenty;
end
8'b100110:
begin
previousNodeX38[23] <= currentx;
previousNodeY38[23] <= currenty;
end
8'b100110:
begin
previousNodeX38[24] <= currentx;
previousNodeY38[24] <= currenty;
end
8'b100110:
begin
previousNodeX38[25] <= currentx;
previousNodeY38[25] <= currenty;
end
8'b100110:
begin
previousNodeX38[26] <= currentx;
previousNodeY38[26] <= currenty;
end
8'b100110:
begin
previousNodeX38[27] <= currentx;
previousNodeY38[27] <= currenty;
end
8'b100110:
begin
previousNodeX38[28] <= currentx;
previousNodeY38[28] <= currenty;
end
8'b100110:
begin
previousNodeX38[29] <= currentx;
previousNodeY38[29] <= currenty;
end
8'b100110:
begin
previousNodeX38[30] <= currentx;
previousNodeY38[30] <= currenty;
end
8'b100110:
begin
previousNodeX38[31] <= currentx;
previousNodeY38[31] <= currenty;
end
8'b100110:
begin
previousNodeX38[32] <= currentx;
previousNodeY38[32] <= currenty;
end
8'b100110:
begin
previousNodeX38[33] <= currentx;
previousNodeY38[33] <= currenty;
end
8'b100110:
begin
previousNodeX38[34] <= currentx;
previousNodeY38[34] <= currenty;
end
8'b100110:
begin
previousNodeX38[35] <= currentx;
previousNodeY38[35] <= currenty;
end
8'b100110:
begin
previousNodeX38[36] <= currentx;
previousNodeY38[36] <= currenty;
end
8'b100110:
begin
previousNodeX38[37] <= currentx;
previousNodeY38[37] <= currenty;
end
8'b100110:
begin
previousNodeX38[38] <= currentx;
previousNodeY38[38] <= currenty;
end
8'b100110:
begin
previousNodeX38[39] <= currentx;
previousNodeY38[39] <= currenty;
end
endcase
end
8'b100111:
begin
case(tempneighborx[neighborcounter])
8'b100111:
begin
previousNodeX39[0] <= currentx;
previousNodeY39[0] <= currenty;
end
8'b100111:
begin
previousNodeX39[1] <= currentx;
previousNodeY39[1] <= currenty;
end
8'b100111:
begin
previousNodeX39[2] <= currentx;
previousNodeY39[2] <= currenty;
end
8'b100111:
begin
previousNodeX39[3] <= currentx;
previousNodeY39[3] <= currenty;
end
8'b100111:
begin
previousNodeX39[4] <= currentx;
previousNodeY39[4] <= currenty;
end
8'b100111:
begin
previousNodeX39[5] <= currentx;
previousNodeY39[5] <= currenty;
end
8'b100111:
begin
previousNodeX39[6] <= currentx;
previousNodeY39[6] <= currenty;
end
8'b100111:
begin
previousNodeX39[7] <= currentx;
previousNodeY39[7] <= currenty;
end
8'b100111:
begin
previousNodeX39[8] <= currentx;
previousNodeY39[8] <= currenty;
end
8'b100111:
begin
previousNodeX39[9] <= currentx;
previousNodeY39[9] <= currenty;
end
8'b100111:
begin
previousNodeX39[10] <= currentx;
previousNodeY39[10] <= currenty;
end
8'b100111:
begin
previousNodeX39[11] <= currentx;
previousNodeY39[11] <= currenty;
end
8'b100111:
begin
previousNodeX39[12] <= currentx;
previousNodeY39[12] <= currenty;
end
8'b100111:
begin
previousNodeX39[13] <= currentx;
previousNodeY39[13] <= currenty;
end
8'b100111:
begin
previousNodeX39[14] <= currentx;
previousNodeY39[14] <= currenty;
end
8'b100111:
begin
previousNodeX39[15] <= currentx;
previousNodeY39[15] <= currenty;
end
8'b100111:
begin
previousNodeX39[16] <= currentx;
previousNodeY39[16] <= currenty;
end
8'b100111:
begin
previousNodeX39[17] <= currentx;
previousNodeY39[17] <= currenty;
end
8'b100111:
begin
previousNodeX39[18] <= currentx;
previousNodeY39[18] <= currenty;
end
8'b100111:
begin
previousNodeX39[19] <= currentx;
previousNodeY39[19] <= currenty;
end
8'b100111:
begin
previousNodeX39[20] <= currentx;
previousNodeY39[20] <= currenty;
end
8'b100111:
begin
previousNodeX39[21] <= currentx;
previousNodeY39[21] <= currenty;
end
8'b100111:
begin
previousNodeX39[22] <= currentx;
previousNodeY39[22] <= currenty;
end
8'b100111:
begin
previousNodeX39[23] <= currentx;
previousNodeY39[23] <= currenty;
end
8'b100111:
begin
previousNodeX39[24] <= currentx;
previousNodeY39[24] <= currenty;
end
8'b100111:
begin
previousNodeX39[25] <= currentx;
previousNodeY39[25] <= currenty;
end
8'b100111:
begin
previousNodeX39[26] <= currentx;
previousNodeY39[26] <= currenty;
end
8'b100111:
begin
previousNodeX39[27] <= currentx;
previousNodeY39[27] <= currenty;
end
8'b100111:
begin
previousNodeX39[28] <= currentx;
previousNodeY39[28] <= currenty;
end
8'b100111:
begin
previousNodeX39[29] <= currentx;
previousNodeY39[29] <= currenty;
end
8'b100111:
begin
previousNodeX39[30] <= currentx;
previousNodeY39[30] <= currenty;
end
8'b100111:
begin
previousNodeX39[31] <= currentx;
previousNodeY39[31] <= currenty;
end
8'b100111:
begin
previousNodeX39[32] <= currentx;
previousNodeY39[32] <= currenty;
end
8'b100111:
begin
previousNodeX39[33] <= currentx;
previousNodeY39[33] <= currenty;
end
8'b100111:
begin
previousNodeX39[34] <= currentx;
previousNodeY39[34] <= currenty;
end
8'b100111:
begin
previousNodeX39[35] <= currentx;
previousNodeY39[35] <= currenty;
end
8'b100111:
begin
previousNodeX39[36] <= currentx;
previousNodeY39[36] <= currenty;
end
8'b100111:
begin
previousNodeX39[37] <= currentx;
previousNodeY39[37] <= currenty;
end
8'b100111:
begin
previousNodeX39[38] <= currentx;
previousNodeY39[38] <= currenty;
end
8'b100111:
begin
previousNodeX39[39] <= currentx;
previousNodeY39[39] <= currenty;
end
endcase
end






    
    
    endcase
    
    
    
end


//if there are no neighbors, be sure to set state to check done













//COPY PASTED CODE HERE!!!!!!!!
      
	     
		 	       CHECK_IF_IN_CLOSED:
		 begin 
		    $display("STATE: CHECK_IF_IN_CLOSED");
		    search_index <= 9'b0;
		    found <= 1'b0;
		    state <= SEARCH_CLOSED_COMPARE;
		 end
			
	       SEARCH_CLOSED_COMPARE:
		 begin
		   $display("STATE: SEARCH_CLOSED_COMPARE");
		    if(closex[search_index] == checkx && closey[search_index] == checky)
		      begin
			 found <= 1'b1;
			 state <= SEARCH_CLOSED_DONE_FOUND; //Go to next section
		      end
		    else
		      begin
			 search_index <= search_index + 1;
			 state <= SEARCH_CLOSED_NEXT;
		      end
		 end
	       SEARCH_CLOSED_NEXT:
		 begin
		   	       $display("STATE: SEARCH_CLOSED_NEXT");
		    if(search_index == closecounter)//equals 399
		      begin
			 found <=1'b0;
			 state <= SEARCH_CLOSED_DONE_NOT_FOUND; // Not found, go to next section
		      end
		    else
		      begin
			 state <=SEARCH_CLOSED_COMPARE;
		      end
		 end // case: NEXT
			SEARCH_CLOSED_DONE_FOUND:
			begin
				state <= NEIGHBOR_CHECK_LOOP;
				$display("STATE: SEARCH_CLOSED_DONE_FOUND");
			end
	       SEARCH_CLOSED_DONE_NOT_FOUND:
		 begin
state <= CHECK_IF_IN_OPEN;

	       $display("STATE: SEARCH_CLOSED_DONE_NOT_FOUND");
	       neighborcounter <= neighborcounter + 1;
		 end
		 
		    CHECK_IF_IN_OPEN:
		 begin 
		    $display("STATE: CHECK_IF_IN_OPEN");
		    search_index <= 9'b0;
		    found <= 1'b0;
		    state <= SEARCH_OPEN_COMPARE;
		 end
			
	       SEARCH_OPEN_COMPARE:
		 begin
		    $display("STATE: SEARCH_OPEN_COMPARE");
		    if(openx[search_index] == checkx && openy[search_index] == checky)
		      begin
			 found <= 1'b1;
			 state <= SEARCH_OPEN_DONE_FOUND; //Go to next section
		      end
		    else
		      begin
			 search_index <= search_index + 1;
			 state <= SEARCH_OPEN_NEXT;
		      end
		 end
	       SEARCH_OPEN_NEXT:
		 begin
		    $display("STATE: SEARCH_OPEN_NEXT");
		    if(search_index == opencounter)//equals 399
		      begin
			 found <=1'b0;
			 state <= SEARCH_OPEN_DONE_NOT_FOUND; // Not found, go to next section
		      end
		    else
		      begin
			 state <=SEARCH_OPEN_COMPARE;
		      end
		 end // case: NEXT\
			SEARCH_OPEN_DONE_FOUND:
			begin
			   $display("STATE: SEARCH_OPEN_DONE_FOUND");
				state <= CHECK_IF_NEIGHBOR_IS_BETTER;
				
			end
	       SEARCH_OPEN_DONE_NOT_FOUND:
		 begin
		    $display("STATE: SEARCH_OPEN_DONE_NOT_FOUND");
			state <= NEIGHBOR_IS_BETTER;
		 end

      SORT_QUEUE:
	begin
	  $display("STATE: SORT_QUEUE");
	  state <= BUBBLE_SORT;
	   sort_count = 10'b0;
	   did_swap <= 1'b0;
	   done <= 1'b0;
	end
      
        
//GET FIRST, DISTANCE
      BUBBLE_SORT:
	begin
	   $display("STATE: BUBBLE_SORT");
	 //  temp1 <=((openx[sort_count] - goalx < openy[sort_count] - goaly)?openy[sort_count]-goaly:openx[sort_count]-goalx);
	//temp2 <= ((openy[sort_count] - goaly < 0)? -1*(openy[sort_count]-goaly):openy[sort_count]-goaly) + ((openx[sort_count]-goalx < 0)? -1 *(openx[sort_count]-goalx):openx[sort_count]-goalx);
	
	total1 <= 1.41421 * ((openx[sort_count] - goalx < openy[sort_count] - goaly)?openy[sort_count]-goaly:openx[sort_count]-goalx) + (((openy[sort_count] - goaly < 0)? -1*(openy[sort_count]-goaly):openy[sort_count]-goaly) + ((openx[sort_count]-goalx < 0)? -1 *(openx[sort_count]-goalx):openx[sort_count]-goalx) - 2 * ((openx[sort_count] - goalx < openy[sort_count] - goaly)?openy[sort_count]-goaly:openx[sort_count]-goalx));
	//distance from start x=openx[sort_count]  y=openy[sort_count]
	
	//temp4 <=((openx[sort_count] - startx < openy[sort_count] - starty)?openy[sort_count]-starty:openx[sort_count]-startx);
	//temp5 <= ((openy[sort_count] - starty < 0)? -1*(openy[sort_count]-starty):openy[sort_count]-starty) + ((openx[sort_count]-startx < 0)? -1 *(openx[sort_count]-startx):openx[sort_count]-startx);
	
	//temp6 <= 1.41421 * temp4 + (temp5 - 2 * temp6);
	
	//TotalDistanceFromGoal
	//total1 = temp3 + temp6;
	state <= GET_SECOND_DISTANCE;
	end // case: BUBBLE_SORT
      
GET_SECOND_DISTANCE:
	begin
	  state <= COMPARE_BETTER;
	   $display("STATE: GET_SECOND_DISTANCE");
	  
//	temp1 <=((openx[sort_count+1] - goalx < openy[sort_count+1] - goaly)?openy[sort_count+1]-goaly:openx[sort_count+1]-goalx);
//	temp2 <= ((openy[sort_count+1] - goaly < 0)? -1*(openy[sort_count+1]-goaly):openy[sort_count+1]-goaly) + ((openx[sort_count+1]-goalx < 0)? -1 *(openx[sort_count+1]-goalx):openx[sort_count+1]-goalx);
	total2 <= 1.41421 * ((openx[sort_count+1] - goalx < openy[sort_count+1] - goaly)?openy[sort_count+1]-goaly:openx[sort_count+1]-goalx) + (((openy[sort_count+1] - goaly < 0)? -1*(openy[sort_count+1]-goaly):openy[sort_count+1]-goaly) + ((openx[sort_count+1]-goalx < 0)? -1 *(openx[sort_count+1]-goalx):openx[sort_count+1]-goalx) - 2 * ((openx[sort_count+1] - goalx < openy[sort_count+1] - goaly)?openy[sort_count+1]-goaly:openx[sort_count+1]-goalx));
		//distance from start x=openx[sort_count]  y=openy[sort_count]
	
	//temp4 <=((openx[sort_count] - startx < openy[sort_count] - starty)?openy[sort_count]-starty:openx[sort_count]-startx);
	//temp5 <= ((openy[sort_count+1] - starty < 0)? -1*(openy[sort_count+1]-starty):openy[sort_count+1]-starty) + ((openx[sort_count+1]-startx < 0)? -1 *(openx[sort_count+1]-startx):openx[sort_count+1]-startx);
	//temp6 <= 1.41421 * temp4 + (temp5 - 2 * temp6);
	
	//total2 = temp3 + temp6;
	end // case: GET_SECOND_DISTANCE
      

COMPARE_BETTER:
	begin
     $display("STATE: COMPARE_BETTER");
	if(total2 > total1)
		state <= SWITCH;
	
	else
		state <= BUBBLE_NEXT;
	end
	
SWITCH:
	begin
	   $display("STATE: SWITCH");
		did_swap <= 1'b1;
		openx[sort_count] <= openx[sort_count+1];
		openx[sort_count+1] <= openx[sort_count];
		openy[sort_count] <= openy[sort_count+1];
		openy[sort_count+1] <= openy[sort_count];
		state <= BUBBLE_NEXT;
	end

BUBBLE_NEXT:
	begin
	   $display("STATE: BUBBLE_NEXT");
		if(sort_count >= opencounter && did_swap == 1'b1)
		begin
			sort_count <= 10'b0;
			did_swap <= 1'b0;
			total1 <= 0;
			total2 <= 0;
			state <= BUBBLE_SORT;
		end
		
		if(sort_count >= opencounter && did_swap == 1'b0)
		begin
			sort_count <= 0;
			state <= SORT_DONE;//go to next stage here
		end
		
		if(sort_count < opencounter)
			begin
				sort_count <= sort_count + 1;
				state <= BUBBLE_SORT;
				total1 <= 0;
				total2 <= 0;
		    end
	end // case: BUBBLE_NEXT

SORT_DONE:
	begin
	   $display("STATE: SORT_DONE");
		done <= 1'b1;
		state <= CREATE_NEIGHBORS;
	end


//END COPYPASTED CODE!!!!











	  
endcase

	end // else: !if(reset)
     end // always @ (posedge sync,posedge reset)



   
/*
   
while(openx[0] != 8'b11111111 && openy[0] != 8'b11111111)
  begin
if(openx[0] == 8'b00100111 && openy[0] == 8'b00100111)
  reconstructPath();
else
  begin
     closex[closecounter] <= openx[0];
     closey[closecounter] <= openy[0];
     closecounter <= closecounter + 1;
     popOpen();

     
     setNeighborNodes();
     for(0-numNeighbors)
       begin
if(close
       end
     
  end
     

  end





subroutine estimateDistanceToGoal(startx starty goalx goaly)
  temp1 <= ((starty-goaly < startx-goalx)?starty-goaly:startx-goalx);//h_diagonal
	    temp2 <= ((starty-goaly < 0)? -1*(starty-goaly):stary-goaly) + ((startx-goalx < 0)? -1*(startx-goalx):startx-goalx);//h_straight
	    
temp3 = 1.41421 * temp1 + (temp2 - 2*temp1);
*/
/*
  		float h_diagonal = (float) Math.min(Math.abs(start.x-goal.x), Math.abs(start.y-goal.y));
		float h_straight = (float) (Math.abs(start.x-goal.x) + Math.abs(start.y-goal.y));
		float h_result = (float) (Math.sqrt(2) * h_diagonal + (h_straight - 2*h_diagonal));*/

   endmodule;