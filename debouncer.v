module debouncer (
	input noisy_in, rst_n, clk,
	output reg stable_out
);	
	reg [19:0] counter;
	reg sync0, sync1;
	
//store input signal after delay
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			sync0 <= 1'b0;
			sync1 <= 1'b0;
		end
		else begin
			sync0 <= noisy_in;
			sync1 <= sync0;
		end
	end

//reset counter if the signal is constant
//output new signal after 20 milliseconds
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			counter <= 20'd0;
			stable_out <= 1'b0;
		end
		else if (sync1 == stable_out) begin
			counter <= 20'd0;
		end
		else begin
			counter <= counter + 1'b1;
			
			if (counter == 20'd1_000_000) begin
                    stable_out <= sync1;
                    counter   <= 20'd0;
			end
		end
    end

endmodule