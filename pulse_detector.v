module pulse_detector
(
	input signal_in, rst_n, clk,
	
	output pulse_out
);
	reg signal_d;
	
//store the signal at the start and end of a clock pulse
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			signal_d <= 1'b0;
		end
		else begin
			signal_d <= signal_in;
		end
	end
	
//a pulse happened if the pusbut button was pressed and released
	assign pulse_out = signal_in & ~signal_d;
	
endmodule