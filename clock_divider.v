module clock_divider
(
	input clk, rst_n,
	
	output reg tick
);
//decrease clock frequency to 12.5 MHz 
	reg [23:0] counter;

	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			counter <= 24'd0;
			tick <= 1'b0;
		end
		else begin
			if (counter == 24'd12_500_000) begin
				counter <= 24'd0;
				tick <= 1'b1;
			end
			else begin
				counter <= counter + 1'b1;
				tick <= 1'b0;
			end
		end
	end
	
endmodule	