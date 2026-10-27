module ripple_carry_adder (
	input [6:0] a,
	input [6:0] b,
	output [7:0] s
);

	wire [7:0] c;
	
	genvar i;
	generate
		for(i=0; i<7; i=i+1) begin : fa	
			full_adder a1 (
				.a(a[i]), .b(b[i]), .ci(c[i]), .s(s[i]), .co(c[i+1])
			);
		end
	endgenerate
	
	assign c[0] = 1'b0;
	assign s[7] = c[7];
		
		
endmodule