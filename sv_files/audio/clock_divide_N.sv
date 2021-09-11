// -- divide by odd number ---
// -- 50 % duty cycle﻿

module clock_divide_N ( 

input  wire ref_clk, 
input  wire nReset, 
output wire clk_out );


parameter [7:0] N = 8'd19;
reg [7:0] counter;
reg tff1_en;
reg tff2_en;

reg tff1_out;
reg tff2_out;


// Counter
always @ (posedge ref_clk or negedge nReset)
if (nReset == 1'b0)
  counter <= 0;
else
  counter <= (counter == N-1'b1) ? 1'b0 : counter + 8'b1;

// TFF_1 Enable
always @ (posedge ref_clk or negedge nReset)
if (nReset == 1'b0) 
  tff1_en <= 1'b0;
else begin
  tff1_en <= 1'b0;
  if (counter == 8'b0)
    tff1_en <= 1'b1;
end

// TFF_2 Enable
always @ (posedge ref_clk or negedge nReset)
if (nReset == 1'b0) 
  tff2_en <= 1'b0;
else begin
  tff2_en <= 1'b0;
  if (counter == (N+8'b1)/8'd2) // (N+1)/2
    tff2_en <= 1'b1;
end


 // TFF_1
always @ (posedge ref_clk or negedge nReset)
if (nReset == 1'b0) 
  tff1_out <= 1'b0;
else if (tff1_en )
  tff1_out <= ! tff1_out ;


 // TFF_2 on Negative Edge
always @ (negedge ref_clk or negedge nReset)
if (nReset == 1'b0)
  tff2_out <= 1'b0;
else if (tff2_en )
  tff2_out <= ! tff2_out ;




 assign clk_out = tff1_out ^ tff2_out ;
 
 endmodule