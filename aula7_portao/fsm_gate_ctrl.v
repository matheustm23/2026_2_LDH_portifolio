`define ESTADO_FECHADO		3'b000
`define ESTADO_ABRINDO		3'b001
`define ESTADO_MEIO_ABERTO	3'b010
`define ESTADO_ABERTO		3'b011
`define ESTADO_FECHANDO		3'b100
`define ESTADO_MEIO_FECHADO	3'b101

module fsm_gate_ctrl(
	input rst,
	input clk,
	//Sinais de controle
	input botao,
	input fim_fechado,
	input fim_aberto,
	input tempo_esgotado,   //vem do contador de 5 s
	//Saidas
	output reg motor_ligado,
	output reg motor_sentido,   //1 abrindo, 0 fechando
	output reg portao_aberto,   //liga o contador de 5 s
	output reg portao_fechado   //zera a posicao do portao
);

	reg [2:0] estado;
	reg [2:0] proximo_estado;

	//Motor de estados
	always @(posedge clk) begin
		if(rst) begin //reset sincrono
			estado <= `ESTADO_FECHADO;
		end else begin
			estado <= proximo_estado;
		end
	end

	//Logica de transicao
	always @(*) begin
		case(estado)
			`ESTADO_FECHADO: begin
				if (botao == 1'b1) begin
					proximo_estado = `ESTADO_ABRINDO;
				end else begin
					proximo_estado = `ESTADO_FECHADO;
				end
			end
			`ESTADO_ABRINDO: begin
				if (fim_aberto == 1'b1) begin
					proximo_estado = `ESTADO_ABERTO;
				end else if (botao == 1'b1) begin
					proximo_estado = `ESTADO_MEIO_ABERTO;
				end else begin
					proximo_estado = `ESTADO_ABRINDO;
				end
			end
			`ESTADO_MEIO_ABERTO: begin
				if (botao == 1'b1) begin
					proximo_estado = `ESTADO_FECHANDO;
				end else begin
					proximo_estado = `ESTADO_MEIO_ABERTO;
				end
			end
			`ESTADO_ABERTO: begin
				if (botao == 1'b1 || tempo_esgotado == 1'b1) begin
					proximo_estado = `ESTADO_FECHANDO;
				end else begin
					proximo_estado = `ESTADO_ABERTO;
				end
			end
			`ESTADO_FECHANDO: begin
				if (fim_fechado == 1'b1) begin
					proximo_estado = `ESTADO_FECHADO;
				end else if (botao == 1'b1) begin
					proximo_estado = `ESTADO_MEIO_FECHADO;
				end else begin
					proximo_estado = `ESTADO_FECHANDO;
				end
			end
			`ESTADO_MEIO_FECHADO: begin
				if (botao == 1'b1) begin
					proximo_estado = `ESTADO_ABRINDO;
				end else begin
					proximo_estado = `ESTADO_MEIO_FECHADO;
				end
			end
			default: proximo_estado = `ESTADO_FECHADO;
		endcase
	end

	//Logica de saida
	always @(*) begin
		motor_ligado = 0;
		motor_sentido = 0;
		portao_aberto = 0;
		portao_fechado = 0;
		case(estado)
			`ESTADO_FECHADO: begin
				portao_fechado = 1;
			end
			`ESTADO_ABRINDO: begin
				motor_ligado = 1;
				motor_sentido = 1;
			end
			`ESTADO_ABERTO: begin
				portao_aberto = 1;
			end
			`ESTADO_FECHANDO: begin
				motor_ligado = 1;
				motor_sentido = 0;
			end
		endcase
	end

endmodule
