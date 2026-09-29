clk_1s div1(
	.rst(KEY[0]),
	.clk_50M(MAX10_CLK1_50),
	.clk_out(LEDR[0])
);

endmodule