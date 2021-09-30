/* soundtrack sound*/
module soundtrack_ROM (
	
	input clk,
	input resetN,
	input [31:0] adress, // for future purpose
	output [15:0] dout,
	output [17:0] depth,
	output [31:0] repeats

);


reg [31:0] address_d; // hold previous address value
 

logic read; // input to u0
assign read = address_d != adress; // new address recived

logic [3:0] data_burstcount; // assert to 1 for read mode
assign data_burstcount = {3'b000,read};

wire [31:0] rom_data;


my_ROM u0 ( // each word is 32 bit
	.clock(clk),
	.reset_n(resetN),
	.avmm_data_addr(adress [17:1]), // take 16 lsb and divide by 2 - for each adress hold 2 word
	
	.avmm_data_read(read), // new read command

	.avmm_data_readdata(rom_data), // data out
	
	.avmm_data_waitrequest(/*waitrequest*/), // output signal
	
	.avmm_data_readdatavalid(/*readdatavalid*/), // correct output
	
	.avmm_data_burstcount(data_burstcount)
	

);



always_ff @(posedge clk, negedge resetN) begin
	if (resetN == 1'b0) begin
		address_d <= 32'b0;
	end
	else begin
		address_d  <= adress;
		if (adress[0] == 1'b1)begin //right word or left
			dout <= rom_data [15:0];
		end
		else begin
			dout <= rom_data [31:16];
		end
	end
end




// used to be bit map but was replaced with my_Rom

logic [17:0] soundtrack_depth;
logic [31:0] soundtrack_repeats;
//assign soundtrack_depth = 18'd20133; // same as numbers of samples
assign soundtrack_depth = 18'd71457; // same as numbers of samples

assign soundtrack_repeats = 32'd2;// repeat more than once


assign repeats = soundtrack_repeats;
assign depth = soundtrack_depth;

endmodule 