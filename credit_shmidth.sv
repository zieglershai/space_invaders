

/// responsible to turn button to schmidt trigger

module shmidth(
	input clk,
	input resetN,
	input neg_in,
	input pos_in,

	output pos_out,
	output neg_out

);


wire [31:0] neg_counter;
wire [31:0] pos_counter;
wire [31:0] time_counter;


always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin
		neg_counter <=	32'b0;
		neg_out <= 1;
	end
	else begin
		// negative input part
		if (!neg_in && neg_counter == 32'b0)begin
			neg_out <= 0;
			neg_counter = 32'b1; // start counting
		end
		else if(neg_counter != 32'b0 && neg_counter < 32'd4500000) begin // if we started counting - how long one press is 
			neg_counter <= neg_counter + 1;
			neg_out <= 1;
		end
		else begin
			neg_counter <= 32'b0; // more than one press
		end
		// positive input part
		
		
	end
end


//positvie part
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		pos_counter <= 32'b0;
		time_counter <= 32'b0;
		pos_out <= 1'b0;
	end
	else begin
		if (pos_in && time_counter == 32'b0) begin
			time_counter <= 32'b1;
			pos_counter <= 32'b1;
			pos_out <= 1'b0;
		end
		else if (time_counter > 32'b0 && time_counter < 32'd700) begin // if we are counting
			time_counter <= time_counter + 32'b1;
			if (pos_in)begin
					pos_counter <= pos_counter + 32'b1;
			end
		end
		else if (time_counter == 32'd700) begin
			time_counter <= 32'b0;
			pos_counter <= 32'b0;
			if (pos_counter >= 32'd500) begin
				pos_out <= 1'b1;
			end
		end
		else begin
			pos_out <= 1'b0;
		end
	end
end
endmodule
