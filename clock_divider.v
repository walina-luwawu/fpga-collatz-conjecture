module clock_divider
(
	input clk, rst_n,
	
	output reg clk_out
);
//decrease clock frequency to 1 Hz 
	reg [24:0] counter;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			counter <= 25'd0;
			clk_out <= 1'b0;
		end
		else begin
			if (counter == 25'd24_999_999) begin
				counter <= 25'd0;
				clk_out <= ~clk_out;
			end
			else begin
				counter <= counter + 1'b1;
			end
		end
	end
	
endmodule	