module collatz_calculator
(
	input [7:0] current_term,
	
	output [7:0] next_term
);
	wire [7:0] current_term_mul_2, sum;
	wire carry;
	
//multiply current term by 2
	assign current_term_mul_2 = {current_term[6:0], 1'b0};

//add 1 and the current term to twice the current term
	full_adder_8bit u0 (
			.byte0 (current_term_mul_2),
			.byte1 (current_term),
			.carry_in (1'b1),
			.sum_out (sum),
			.carry_out (carry)
			);

//next term is n/2 if the current term is even
//otherwise next term is 3n + 1
	assign next_term = (current_term == 8'd1) ? 8'd1 :
							 (~current_term[0])     ? {1'b0, current_term[7:1]} : sum;
	
endmodule
								