	       8'b0:
		 begin
		    if((distanceFromStart0[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart0[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1:
		 begin
		    if((distanceFromStart1[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart1[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10:
		 begin
		    if((distanceFromStart2[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart2[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11:
		 begin
		    if((distanceFromStart3[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart3[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100:
		 begin
		    if((distanceFromStart4[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart4[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b101:
		 begin
		    if((distanceFromStart5[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart5[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b110:
		 begin
		    if((distanceFromStart6[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart6[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b111:
		 begin
		    if((distanceFromStart7[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart7[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1000:
		 begin
		    if((distanceFromStart8[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart8[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1001:
		 begin
		    if((distanceFromStart9[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart9[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1010:
		 begin
		    if((distanceFromStart10[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart10[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1011:
		 begin
		    if((distanceFromStart11[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart11[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1100:
		 begin
		    if((distanceFromStart12[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart12[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1101:
		 begin
		    if((distanceFromStart13[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart13[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1110:
		 begin
		    if((distanceFromStart14[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart14[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b1111:
		 begin
		    if((distanceFromStart15[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart15[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10000:
		 begin
		    if((distanceFromStart16[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart16[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10001:
		 begin
		    if((distanceFromStart17[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart17[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10010:
		 begin
		    if((distanceFromStart18[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart18[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10011:
		 begin
		    if((distanceFromStart19[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart19[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10100:
		 begin
		    if((distanceFromStart20[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart20[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10101:
		 begin
		    if((distanceFromStart21[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart21[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10110:
		 begin
		    if((distanceFromStart22[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart22[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b10111:
		 begin
		    if((distanceFromStart23[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart23[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11000:
		 begin
		    if((distanceFromStart24[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart24[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11001:
		 begin
		    if((distanceFromStart25[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart25[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11010:
		 begin
		    if((distanceFromStart26[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart26[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11011:
		 begin
		    if((distanceFromStart27[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart27[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11100:
		 begin
		    if((distanceFromStart28[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart28[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11101:
		 begin
		    if((distanceFromStart29[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart29[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11110:
		 begin
		    if((distanceFromStart30[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart30[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b11111:
		 begin
		    if((distanceFromStart31[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart31[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100000:
		 begin
		    if((distanceFromStart32[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart32[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100001:
		 begin
		    if((distanceFromStart33[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart33[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100010:
		 begin
		    if((distanceFromStart34[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart34[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100011:
		 begin
		    if((distanceFromStart35[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart35[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100100:
		 begin
		    if((distanceFromStart36[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart36[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100101:
		 begin
		    if((distanceFromStart37[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart37[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100110:
		 begin
		    if((distanceFromStart38[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart38[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
	       8'b100111:
		 begin
		    if((distanceFromStart39[currentx]+ ((currentx == tempneighborx[neighborcounter] || currenty == tempneighbory[neighborcounter]) ? 10 : 19))<distanceFromStart39[currentx])
		      state <= NEIGHBOR_IS_BETTER;
		    else 
begin 
if(neighborcounter == 4'b0111) state <= CHECK_DONE;
neighborcounter <= neighborcounter + 1; 
state <= NEIGHBOR_CHECK_LOOP;
end
		 end
