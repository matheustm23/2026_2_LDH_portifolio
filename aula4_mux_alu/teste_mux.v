//Definicoes de constantes no verilog
`define OP_OR		1'b0
`define OP_AND 	1'b1

module alu( //unidade logica aritmética

	input a,
	input b,
	input op_sel,
	output reg y
);

	always @(*) begin
		if(op_sel==	`OP_OR) 
		y= a | b;
		else //OP_AND
		y= a & b;
	end
endmodule
		