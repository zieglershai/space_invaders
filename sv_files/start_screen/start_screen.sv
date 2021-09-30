module start_screen(
					input clk,
					input resetN,
					input startOfFrame,
					input standBy,
					input [10:0] pixelX,
					input [10:0] pixelY,
					
					output startScreenDR,
					output [7:0] startScreenRGB

);
//keyStart moudule wires
wire [10:0] keyStart_sq_inst_offsetX;
wire [10:0] keyStart_sq_inst_offsetY;
wire keyStart_sq_RecDR;
wire startDR;
wire [7:0] startRGB;

square_object 	#(
			.OBJECT_WIDTH_X(128), //dec
			.OBJECT_HEIGHT_Y(77),//dec
			.OBJECT_COLOR(0) //hex
)
keyStart_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd70),
					.topLeftY(11'd230),
					.offsetX(keyStart_sq_inst_offsetX),
					.offsetY(keyStart_sq_inst_offsetY),
					.drawingRequest(keyStart_sq_RecDR),
					.RGBout()
);

keyStartBitMap key_map_inst(
					.clk(clk), 
					.resetN(resetN), 
					.offsetX(keyStart_sq_inst_offsetX), 
					.offsetY(keyStart_sq_inst_offsetY), 
					.InsideRectangle(keyStart_sq_RecDR),
					.standBy(standBy),
					.drawingRequest(startDR), 
					.RGBout(startRGB)
);

//space invaders moudule wires
wire [10:0] space_sq_inst_offsetX;
wire [10:0] space_sq_inst_offsetY;
wire space_sq_RecDR;
wire spaceDR;
wire [7:0] spaceRGB;

square_object 	#(
			.OBJECT_WIDTH_X(256), //dec
			.OBJECT_HEIGHT_Y(128),//dec
			.OBJECT_COLOR(0) //hex
)
space_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd192),
					.topLeftY(11'd80),
					.offsetX(space_sq_inst_offsetX),
					.offsetY(space_sq_inst_offsetY),
					.drawingRequest(space_sq_RecDR),
					.RGBout()
);

spaceInvadersBitMap space_map_inst(
					.clk(clk), 
					.resetN(resetN), 
					.offsetX(space_sq_inst_offsetX), 
					.offsetY(space_sq_inst_offsetY), 
					.InsideRectangle(space_sq_RecDR),
					.standBy(standBy),
					.drawingRequest(spaceDR), 
					.RGBout(spaceRGB)
);



//key credit invaders moudule wires
wire [10:0] credit_sq_inst_offsetX;
wire [10:0] credit_sq_inst_offsetY;
wire credit_sq_RecDR;
wire creditDR;
wire [7:0] creditRGB;

square_object 	#(
			.OBJECT_WIDTH_X(128), //dec
			.OBJECT_HEIGHT_Y(78),//dec
			.OBJECT_COLOR(0) //hex
)
credit_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd448),
					.topLeftY(11'd230),
					.offsetX(credit_sq_inst_offsetX),
					.offsetY(credit_sq_inst_offsetY),
					.drawingRequest(credit_sq_RecDR),
					.RGBout()
);

keyCreditBitMap credit_map_inst(
					.clk(clk), 
					.resetN(resetN), 
					.offsetX(credit_sq_inst_offsetX), 
					.offsetY(credit_sq_inst_offsetY), 
					.InsideRectangle(credit_sq_RecDR),
					.standBy(standBy),
					.drawingRequest(creditDR), 
					.RGBout(creditRGB)
);



//names  moudule wires
wire [10:0] names_sq_inst_offsetX;
wire [10:0] names_sq_inst_offsetY;
wire names_sq_RecDR;
wire namesDR;
wire [7:0] namesRGB;




square_object 	#(
			.OBJECT_WIDTH_X(64), //dec
			.OBJECT_HEIGHT_Y(29),//dec
			.OBJECT_COLOR(0) //hex
)
names_sq_inst(
					.clk(clk),
					.resetN(resetN),
					.pixelX(pixelX),
					.pixelY(pixelY),
					.topLeftX(11'd30),
					.topLeftY(11'd430),
					.offsetX(names_sq_inst_offsetX),
					.offsetY(names_sq_inst_offsetY),
					.drawingRequest(names_sq_RecDR),
					.RGBout()
);

namesBitMap names_map_inst(
					.clk(clk), 
					.resetN(resetN), 
					.offsetX(names_sq_inst_offsetX), 
					.offsetY(names_sq_inst_offsetY), 
					.InsideRectangle(names_sq_RecDR),
					.standBy(standBy),
					.drawingRequest(namesDR), 
					.RGBout(namesRGB)
);

start_screen_mux start_mux_inst
(
					.clk(clk),
					.resetN(resetN),
					.startDrawingRequest(startDR), 
					.startRGB(startRGB),
					.spaceDrawingRequest(spaceDR), 
					.spaceRGB(spaceRGB), 
					.creditDrawingRequest(creditDR), 
					.creditRGB(creditRGB),
					.namesDR(namesDR),
					.namesRGB(namesRGB),
					.RGBOut(startScreenRGB),
					.startScreenDR(startScreenDR) 
);
endmodule
