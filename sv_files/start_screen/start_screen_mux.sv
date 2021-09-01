
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	start_screen_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // start 
					input		logic	startDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] startRGB,
					
		   // space invaders 
					input		logic	spaceDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] spaceRGB,

			// credit invaders 
					input		logic	creditDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] creditRGB,		
			
	
					output logic [7:0] RGBOut,
					output logic startScreenDR
					     

);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			startScreenDR <= 0;
			RGBOut	<= 8'b0;
	end
	
	else begin
		if (startDrawingRequest == 1'b1 )  begin 
			RGBOut <= startRGB;  //first priority 
			startScreenDR <= 1;
		end
		
		else if (spaceDrawingRequest == 1'b1 )  begin 
			RGBOut <= spaceRGB;  //second priority 
			startScreenDR <= 1;
		end

		else if (creditDrawingRequest == 1'b1 )  begin 
			RGBOut <= creditRGB;  //second priority 
			startScreenDR <= 1;
		end
		
		else begin
			RGBOut <= 8'b0 ; // last priority - nothing
			startScreenDR <= 0;
		end
			
		end ; 
	end

endmodule


