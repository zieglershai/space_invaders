module ROM_mux(
	input clk,
	input resetN,
	input [3:0] select,
	input [31:0] adress,
	output [15:0] dout,
	output [17:0] depth,
	output [31:0] repeats

);




reg [31:0] address_d; // hold previous address value

logic [16:0] read_from; // actual addres includiong offset

 

logic read; // input to u0
assign read = address_d != adress; // new address recived
 

logic [3:0] data_burstcount; // assert to 1 for read mode
assign data_burstcount = {3'b000,read};

wire [31:0] rom_data;

my_ROM u0 ( // each word is 32 bit
	.clock(clk),
	.reset_n(resetN),
	.avmm_data_addr(read_from), // take 16 lsb and divide by 2 - for each adress hold 2 word
	
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




parameter [16:0] offset_ufo = 17'd35729; // starting position in mif file
parameter [16:0] offset_soundtrack = 17'd0; // starting position in mif file

parameter [17:0] ufo_depth = 18'd23942; // starting position in mif file
parameter [17:0] soundtrack_depth = 18'd71457; // starting position in mif file

parameter [31:0] ufo_repeats = 32'd2; // starting position in mif file
parameter [31:0] soundtrack_repeats = 31'd2; // starting position in mif file

always_comb begin // decide which sound to read from ROM
	if (select == 4'd0) begin // soundtrack enable 
		read_from = adress[17:1] + offset_soundtrack;
		depth = soundtrack_depth;
		repeats = soundtrack_repeats;
		
	end
	else begin // ufo enable
		read_from = adress[17:1] + offset_ufo;
		depth = ufo_depth;
		repeats = ufo_repeats;
	end
end



endmodule 