module portao (
	input rst,
	input clk_1ms,
	input clk_1s,
	input botao, //ativo alto
	output motor_ligado,
	output motor_sentido,
	output portao_aberto,
	output [9:0] barra_led
);

	wire apertou;
	wire soltou;
	wire portao_fechado;
	wire fim_fechado;
	wire fim_aberto;
	wire tempo_esgotado;

	edge_detector detecta_borda (
		.clk(clk_1ms),
		.rst(rst),
		.botao(botao),
		.apertou(apertou),
		.soltou(soltou)
	);

	fsm_gate_ctrl controle (
		.rst(rst),
		.clk(clk_1ms),
		.botao(apertou),
		.fim_fechado(fim_fechado),
		.fim_aberto(fim_aberto),
		.tempo_esgotado(tempo_esgotado),
		.motor_ligado(motor_ligado),
		.motor_sentido(motor_sentido),
		.portao_aberto(portao_aberto),
		.portao_fechado(portao_fechado)
	);

	gate_counter posicao_portao (
		.rst(portao_fechado),
		.clk(clk_1s),
		.ligado(motor_ligado),
		.sentido(motor_sentido),
		.fim_fechado(fim_fechado),
		.fim_aberto(fim_aberto),
		.barra_led(barra_led)
	);

	contador_5s conta_aberto (
		.clk(clk_1s),
		.portao_aberto(portao_aberto),
		.tempo_esgotado(tempo_esgotado)
	);

endmodule
