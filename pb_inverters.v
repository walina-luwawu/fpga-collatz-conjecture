module pb_inverters
(
	input [3:0] pb_n,
	
	output [3:0] pb_out
);
	assign	pb_out = ~pb_n;
	
endmodule