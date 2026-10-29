module gate_counter (
	input rst,
	input clk,              //clock de 1 s, um passo por segundo
	input ligado,
	input sentido,          //1 abre, 0 fecha
	output fim_fechado,
	output fim_aberto,
	output reg [9:0] barra_led
);

	reg [3:0] posicao;      //0 = fechado, 10 = aberto
	reg [3:0] proxima_posicao;

	always @(posedge clk) begin
		if(rst)
			posicao <= 0;
		else if(ligado)
			posicao <= proxima_posicao;
	end

	//Logica da proxima posicao
	always @(*) begin
		if(sentido == 1'b1) begin
			if(posicao == 4'd10)
				proxima_posicao = posicao;
			else
				proxima_posicao = posicao + 1;
		end else begin
			if(posicao == 4'd0)
				proxima_posicao = posicao;
			else
				proxima_posicao = posicao - 1;
		end
	end

	//Barra de leds
	always @(*) begin
		case(posicao)
			0:		barra_led = 10'b0000000000;
			1:		barra_led = 10'b0000000001;
			2:		barra_led = 10'b0000000011;
			3:		barra_led = 10'b0000000111;
			4:		barra_led = 10'b0000001111;
			5:		barra_led = 10'b0000011111;
			6:		barra_led = 10'b0000111111;
			7:		barra_led = 10'b0001111111;
			8:		barra_led = 10'b0011111111;
			9:		barra_led = 10'b0111111111;
			10:		barra_led = 10'b1111111111;
			default:	barra_led = 10'b0000000000;
		endcase
	end

	assign fim_fechado = (posicao == 0);
	assign fim_aberto = (posicao == 10);

endmodule
