module teste_pinos(
	input  [3:0] a,
	input  [3:0] b,
	output [7:0] m
);
	assign m = {b, a};   // LEDR0-3 espelham SW0-3 (a), LEDR4-7 espelham SW4-7 (b)
endmodule