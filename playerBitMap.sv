// System-Verilog 'written by Alex Grinshpun May 2018
// New bitmap dudy February 2021
// (c) Technion IIT, Department of Electrical Engineering 2021 



module	playerBitMap	(	
					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic playGame,
					input logic playerHit,

					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0] RGBout,  //rgb value from the bitmap 
					output	logic	[3:0] HitEdgeCode //one bit per edge 
 ) ;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_NUMBER_OF_Y_BITS = 4;  // 2^4 = 16
localparam  int OBJECT_NUMBER_OF_X_BITS = 6;  // 2^6 = 64


localparam  int OBJECT_HEIGHT_Y = 1 <<  OBJECT_NUMBER_OF_Y_BITS ;
localparam  int OBJECT_WIDTH_X = 1 <<  OBJECT_NUMBER_OF_X_BITS;

// this is the devider used to acess the right pixel 
localparam  int OBJECT_HEIGHT_Y_DIVIDER = OBJECT_NUMBER_OF_Y_BITS - 2; //how many pixel bits are in every collision pixel
localparam  int OBJECT_WIDTH_X_DIVIDER =  OBJECT_NUMBER_OF_X_BITS - 2;

// generating a smiley bitmap

localparam logic [7:0] TRANSPARENT_ENCODING = 8'h00 ;// RGB value in the bitmap representing a transparent pixel 

logic [0:OBJECT_HEIGHT_Y-1] [0:OBJECT_WIDTH_X-1] [7:0] object_colors = {
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h9c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h9c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h9c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h9c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h5c,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}};



//////////--------------------------------------------------------------------------------------------------------------=
//hit bit map has one bit per edge:  hit_colors[3:0] =   {Left, Top, Right, Bottom}	
//there is one bit per edge, in the corner two bits are set  


logic [0:3] [0:3] [3:0] hit_colors = 
		  {16'hC446,     
			16'h8C62,    
			16'h8932,
			16'h9113};

 

// pipeline (ff) to get the pixel color from the array 	 



one_sec_counter one_sec_counter ( .clk(clk), .resetN(resetN),.turbo(1), .one_sec(t_sec), .duty50() );
logic [10:0] curr_t_sec;
logic secFlag;
logic t_sec;

//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge playGame or negedge resetN)
begin
	if(!resetN || !playGame) begin
		RGBout <=	8'h00;
		HitEdgeCode <= 4'h0;
		curr_t_sec <= 0;
		secFlag <= 0;

	end

	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default  
		HitEdgeCode <= 4'h0;
		
		if (playerHit) begin
			curr_t_sec <= 8;
		end
		
		if (t_sec && !secFlag && curr_t_sec)begin
			secFlag <= 1;
			curr_t_sec <= curr_t_sec - 11'b1;
		end
		else if(!t_sec && secFlag) begin
			secFlag <= 0;
		end
		
		if (InsideRectangle == 1'b1 ) 
		begin // inside an external bracket 
			HitEdgeCode <= hit_colors[offsetY >> OBJECT_HEIGHT_Y_DIVIDER][offsetX >> OBJECT_WIDTH_X_DIVIDER];	//get hitting edge from the colors table  
			RGBout <= object_colors[offsetY][offsetX];
		end  	
	end
		
end

//////////--------------------------------------------------------------------------------------------------------------=
// decide if to draw the pixel or not 
assign drawingRequest = (RGBout != TRANSPARENT_ENCODING && (!curr_t_sec[0])) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule