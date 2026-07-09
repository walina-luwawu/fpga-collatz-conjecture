module full_adder_8bit
(
	input [7:0] byte0, byte1,
	input carry_in,
	
	output [7:0] sum_out,
	output carry_out
);
	wire [7:0] carry;
	
	full_adder_1bit u0 (
		.b0 (byte0[0]),
		.b1 (byte1[0]),
		.carry_in (carry_in),
		.sum_out (sum_out[0]),
		.carry_out (carry[0])
	);
	
	full_adder_1bit u1 (
		.b0 (byte0[1]),
		.b1 (byte1[1]),
		.carry_in (carry[0]),
		.sum_out (sum_out[1]),
		.carry_out (carry[1])
	);
	
	full_adder_1bit u2 (
		.b0 (byte0[2]),
		.b1 (byte1[2]),
		.carry_in (carry[1]),
		.sum_out (sum_out[2]),
		.carry_out (carry[2])
	);
	
	full_adder_1bit u3 (
		.b0 (byte0[3]),
		.b1 (byte1[3]),
		.carry_in (carry[2]),
		.sum_out (sum_out[3]),
		.carry_out (carry[3])
	);
	
	full_adder_1bit u4 (
		.b0 (byte0[4]),
		.b1 (byte1[4]),
		.carry_in (carry[3]),
		.sum_out (sum_out[4]),
		.carry_out (carry[4])
	);
	
	full_adder_1bit u5 (
		.b0 (byte0[5]),
		.b1 (byte1[5]),
		.carry_in (carry[4]),
		.sum_out (sum_out[5]),
		.carry_out (carry[5])
	);
	
	full_adder_1bit u6 (
		.b0 (byte0[6]),
		.b1 (byte1[6]),
		.carry_in (carry[5]),
		.sum_out (sum_out[6]),
		.carry_out (carry[6])
	);
	
	full_adder_1bit u7 (
		.b0 (byte0[7]),
		.b1 (byte1[7]),
		.carry_in (carry[6]),
		.sum_out (sum_out[7]),
		.carry_out (carry[7])
	);
	
	assign carry_out = carry[7];
	
endmodule