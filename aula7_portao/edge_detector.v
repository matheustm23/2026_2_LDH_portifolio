`define BTN_SOLTO		2'b00
`define BTN_APERTOU		2'b01
`define BTN_SEGURANDO	2'b10
`define BTN_SOLTOU		2'b11

module edge_detector(
	input clk,
	input rst,
	input botao, //ativo alto
	output apertou,
	output soltou
);

	reg [1:0] estado;
	reg [1:0] proximo_estado;

	always @(posedge clk) begin
		if(rst)
			estado <= `BTN_SOLTO;
		else
			estado <= proximo_estado;
	end

	always @(*) begin
		case(estado)
			`BTN_SOLTO:		proximo_estado = botao ? `BTN_APERTOU : `BTN_SOLTO;
			`BTN_APERTOU:	proximo_estado = `BTN_SEGURANDO;
			`BTN_SEGURANDO:	proximo_estado = botao ? `BTN_SEGURANDO : `BTN_SOLTOU;
			`BTN_SOLTOU:	proximo_estado = `BTN_SOLTO;
			default:		proximo_estado = `BTN_SOLTO;
		endcase
	end

	assign apertou = (estado == `BTN_APERTOU);
	assign soltou = (estado == `BTN_SOLTOU);

endmodule
