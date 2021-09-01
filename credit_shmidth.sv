

/// responsible to turn button to schmidt trigger

module credit_shmidth(
	input clk,
	input resetN,
	input i_addCoin,
	
	output o_addCoin

);


wire [31:0] counter;


always_ff@(posedge clk or negedge resetN)
begin

	if(!resetN) begin
		counter <=	32'b0;
		o_addCoin <= 1;
	end
	else begin
		if (!i_addCoin && counter == 32'b0)begin
			o_addCoin <= 0;
			counter = 32'b1; // start counting
		end
		else if(counter != 32'b0 && counter < 32'd4500000) begin // if we started counting - how long one press is 
			counter <= counter + 1;
			o_addCoin <= 1;
		end
		else begin 
		counter <= 32'b0; // more than one press
		end
	end
end

endmodule
