module video_sync_generator(reset,
                            vga_clk,
                            blank_n,
                            HS,
                            VS,
									 pixelX,
									 pixelY
									 );
                            
input reset;
input vga_clk;
output reg blank_n;
output reg HS;
output reg VS;
output [10:0] pixelX;                       
output [10:0] pixelY;                       


///////////////////
/*
--VGA Timing
--Horizontal :
--                ______________                 _____________
--               |              |               |
--_______________|  VIDEO       |_______________|  VIDEO (next line)

--___________   _____________________   ______________________
--           |_|                     |_|
--            B <-C-><----D----><-E->
--           <------------A--------->
--The Unit used below are pixels;  
--  B->Sync_cycle                   :H_sync_cycle
--  C->Back_porch                   :hori_back
--  D->Visable Area
--  E->Front porch                  :hori_front
--  A->horizontal line total length :hori_line
--Vertical :
--               ______________                 _____________
--              |              |               |          
--______________|  VIDEO       |_______________|  VIDEO (next frame)
--
--__________   _____________________   ______________________
--          |_|                     |_|
--           P <-Q-><----R----><-S->
--          <-----------O---------->
--The Unit used below are horizontal lines;  
--  P->Sync_cycle                   :V_sync_cycle
--  Q->Back_porch                   :vert_back
--  R->Visable Area
--  S->Front porch                  :vert_front
--  O->vertical line total length :vert_line
*////////////////////////////////////////////
////////////////////////                          
//parameter
parameter [10:0] hori_line  = 800;                           
parameter [10:0] hori_back  = 144;
parameter hori_front = 16;
parameter [10:0] vert_line  = 525;
parameter [10:0] vert_back  = 34;
parameter vert_front = 11;
parameter H_sync_cycle = 96;
parameter V_sync_cycle = 2;
parameter H_BLANK = hori_front+H_sync_cycle ; //add by yang

//////////////////////////
reg [10:0] h_cnt;
reg [10:0]  v_cnt;
wire cHD,cVD,cDEN,hori_valid,vert_valid;
wire [10:0] pixelX_temp;                       

///////
always@(negedge vga_clk,posedge reset)
begin
  if (reset)
  begin
     h_cnt<=11'd0;
     v_cnt<=11'd0;
  end
    else
    begin
      if (h_cnt == hori_line - 11'b1)
      begin 
         h_cnt<= 11'd0;
         if (v_cnt == vert_line - 11'b1)
            v_cnt <= 11'd0;
         else
            v_cnt<=v_cnt + 11'd1;
      end
      else
         h_cnt<=h_cnt + 11'b1;
			
		pixelX_temp = h_cnt - hori_back ;
		pixelX[10:0]  = pixelX_temp[10:0];
		pixelY =(v_cnt - vert_back);
		
    end
end
/////
assign cHD = (h_cnt<H_sync_cycle)?1'b0:1'b1;
assign cVD = (v_cnt<V_sync_cycle)?1'b0:1'b1;

assign hori_valid = (h_cnt<(hori_line-hori_front)&& h_cnt>=hori_back)?1'b1:1'b0;
assign vert_valid = (v_cnt<(vert_line-vert_front)&& v_cnt>=vert_back)?1'b1:1'b0;

assign cDEN = hori_valid && vert_valid;

/*assign pixelX_temp = (h_cnt - hori_back) >= 0 ? h_cnt - hori_back : 11'b0;
assign pixelX[10:0]  = pixelX_temp[10:0];
assign pixelY = (v_cnt - vert_back) >= 0 ? (v_cnt - vert_back) : 11'b0;*/


// create bug for half clock cycle
/*assign pixelX_temp = h_cnt - hori_back ;
assign pixelX[10:0]  = pixelX_temp[10:0];
assign pixelY =(v_cnt - vert_back);*/


always@(negedge vga_clk)
begin
  HS<=cHD;
  VS<=cVD;
  blank_n<=cDEN;
end

endmodule


