module seg_display (
	input [3:0] din,
	output [7:0] dout
);

always_comb begin
	if (din == 4'b1111) begin
		dout = digits_up_bin[15];
	end
	else if (din == 4'b1110) begin
		dout = digits_up_bin[14];
	end
	else if (din == 4'b1101) begin
		dout = digits_up_bin[13];
	end
	else if (din == 4'b1100) begin
		dout = digits_up_bin[12];
	end
	else if (din == 4'b1011) begin
		dout = digits_up_bin[11];
	end
	else if (din == 4'b1010) begin
		dout = digits_up_bin[10];
	end
	else if (din == 4'b1001) begin
		dout = digits_up_bin[9];
	end
	else if (din == 4'b1000) begin
		dout = digits_up_bin[8];
	end
	else if (din == 4'b0111) begin
		dout = digits_up_bin[7];
	end
	else if (din == 4'b0110) begin
		dout = digits_up_bin[6];
	end
	else if (din == 4'b0101) begin
		dout = digits_up_bin[5];
	end
	else if (din == 4'b0100) begin
		dout = digits_up_bin[4];
	end
	else if (din == 4'b0011) begin
		dout = digits_up_bin[3];
	end
	else if (din == 4'b0010) begin
		dout = digits_up_bin[2];
	end
	else if (din == 4'b0001) begin
		dout = digits_up_bin[1];
	end
	else begin
		dout = digits_up_bin[0];
	end
end



logic [0:15][7:0] digits_up_bin ={
						  8'b11000000,   //0
                    8'b11111001,  //1      --0--    
                    8'b10100100,  //2     |     |
                    8'b10110000,  //3     5     1  
                    8'b10011001,  //4     |     |    
                    8'b10010010,  //5      --6--   
                    8'b10000010,  //6     |     |  
                    8'b11111000,  //7     4     2
                    8'b10000000,  //8     |     |
                    8'b10010000,  //9     --3--  .7
						  8'b10001000,  //a
						  8'b10000011,  //b
						  8'b11000110,  //c
						  8'b10100001,  //d
						  8'b10000110,  //e
						  8'b10001110  //f

        };
endmodule 