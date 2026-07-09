module full_adder_1bit
(
	input b0, b1, carry_in,
	
	output sum_out, carry_out
);
	assign sum_out = b0 ^ b1 ^ carry_in;
	
//carry is 1 if any pair of inputs is 1
	assign carry_out = (b0 & b1) | (b0 & carry_in) | (b1 & carry_in);
	
endmodule