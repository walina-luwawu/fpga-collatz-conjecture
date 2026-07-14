module LogicalStep_Lab2_top
(
	input				rst_n,		//reset in
	input          clkin_50,	//clock in
	input		[7:0]	sw,
	input		[3:0]	pb_n,

	output	[7:0]	leds,
	output	[6:0]	seg7_data,
	output			seg7_char1,
	output			seg7_char2
);

//these are used as intermediate signals
	wire pb_step, pb_auto, pulse_step, pulse_auto, clk_out, load_en, step_en;
	wire [3:0] hex, pb;
	wire [7:0] byte, next_term, term_count;
	wire [2:0] fsm_state;
	wire[6:0] seg7_A, seg7_B;
	reg [7:0] current_term;
	
// wire assignments
	assign hex = sw[3:0];
	assign byte = {4'b0000, hex};
	
//module instantiations are here
	pb_inverters u0 (
		.pb_n (pb_n),
		.pb_out (pb)
	);
	
	debouncer u1 (
		.noisy_in (pb[0]),
		.rst_n (rst_n),
		.clk (clkin_50),
		.stable_out (pb_step)
	);
	
	debouncer u2 (
		.noisy_in (pb[1]),
		.rst_n (rst_n),
		.clk (clkin_50),
		.stable_out (pb_auto)
	);
	
	pulse_detector u3 (
		.signal_in (pb_step),
		.rst_n (rst_n),
		.clk (clkin_50),
		.pulse_out (pulse_step)
	);
	
	pulse_detector u4 (
		.signal_in (pb_auto),
		.rst_n (rst_n),
		.clk (clkin_50),
		.pulse_out (pulse_auto)
	);
	
	clock_divider u5 (
		.rst_n (rst_n),
		.clk (clkin_50),
		.clk_out (clk_out)
	);
	
	collatz_fsm u6 (
		 .pulse_step (pulse_step),
		 .pulse_auto (pulse_auto),
		 .rst_n (rst_n),
		 .clk (clkin_50),
		 .clk_divider_tick (clk_out),
		 .current_term (current_term),
		 .term_count (term_count),
		 .fsm_state (fsm_state),
		 .load_en (load_en),
		 .step_en (step_en)
	);
	
	collatz_calculator u7 (
		.current_term (current_term),
		.next_term (next_term)
	);
	
	always @(posedge clkin_50 or negedge rst_n) begin
		if (!rst_n) begin
			current_term <= 8'd0;
		end else begin
			if (load_en) begin
				current_term <= byte;
			end else if (step_en) begin
				current_term <= next_term;
			end
		end
	end

	assign leds = current_term;
	
	SevenSegment u8 (
		.hex      (term_count[3:0]), 
		.sevenseg (seg7_A)
	);

	SevenSegment u9 (
		.hex      (term_count[7:4]), 
		.sevenseg (seg7_B)
	);

	segment7_mux u10 (
		.clk  (clkin_50),
		.din2 (seg7_A), 
		.din1 (seg7_B),
		.dout (seg7_data),
		.dig2 (seg7_char2), 
		.dig1 (seg7_char1)
	);
 
endmodule