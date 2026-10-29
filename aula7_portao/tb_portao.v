`timescale 1us/1us

module tb_portao;

	reg rst;
	reg clk_1ms;
	reg clk_1s;
	reg botao;
	wire motor_ligado;
	wire motor_sentido;
	wire portao_aberto;
	wire [9:0] barra_led;

	portao dut (
		.rst(rst),
		.clk_1ms(clk_1ms),
		.clk_1s(clk_1s),
		.botao(botao),
		.motor_ligado(motor_ligado),
		.motor_sentido(motor_sentido),
		.portao_aberto(portao_aberto),
		.barra_led(barra_led)
	);

	always #500 clk_1ms = ~clk_1ms;       //periodo de 1 ms
	always #500000 clk_1s = ~clk_1s;      //periodo de 1 s

	//O botao fica apertado por 20 ms em cada aperto.
	//Os tempos entre parenteses sao o instante da simulacao.
	initial begin
		clk_1ms = 0;
		clk_1s = 0;
		rst = 1;
		botao = 0;
		#2000
		rst = 0;
		#998000                    //espera o clock de 1 s bater e zerar a posicao (1 s)

		//CENARIO 1: abre, fica aberto e fecha sozinho
		botao = 1;
		#20000
		botao = 0;
		#9780000                   //(10,8 s)
		if ((portao_aberto==1'b1) & (barra_led==10'b1111111111)) begin
			$monitor("CENARIO 1: abriu: PASS");
		end else begin
			$monitor("CENARIO 1: abriu: FAIL");
		end
		#4400000                   //(15,2 s)
		if ((portao_aberto==1'b1) & (motor_ligado==1'b0)) begin
			$monitor("CENARIO 1: ainda aberto antes dos 5 s: PASS");
		end else begin
			$monitor("CENARIO 1: ainda aberto antes dos 5 s: FAIL");
		end
		#600000                    //(15,8 s)
		if ((motor_ligado==1'b1) & (motor_sentido==1'b0)) begin
			$monitor("CENARIO 1: fechou sozinho depois dos 5 s: PASS");
		end else begin
			$monitor("CENARIO 1: fechou sozinho depois dos 5 s: FAIL");
		end
		#10200000                  //(26 s)
		if ((barra_led==10'b0000000000) & (motor_ligado==1'b0) & (portao_aberto==1'b0)) begin
			$monitor("CENARIO 1: terminou fechado: PASS");
		end else begin
			$monitor("CENARIO 1: terminou fechado: FAIL");
		end

		//CENARIO 2: aperta o botao com o portao aberto, antes dos 5 s
		#1000000                   //(27 s)
		botao = 1;
		#20000
		botao = 0;
		#9980000                   //(37 s)
		if (portao_aberto==1'b1) begin
			$monitor("CENARIO 2: abriu: PASS");
		end else begin
			$monitor("CENARIO 2: abriu: FAIL");
		end
		#1600000                   //(38,6 s) 2 s depois de abrir
		botao = 1;
		#20000
		botao = 0;
		#80000                     //(38,7 s)
		if ((motor_ligado==1'b1) & (motor_sentido==1'b0) & (portao_aberto==1'b0)) begin
			$monitor("CENARIO 2: botao fechou na hora: PASS");
		end else begin
			$monitor("CENARIO 2: botao fechou na hora: FAIL");
		end
		#10300000                  //(49 s)
		if ((barra_led==10'b0000000000) & (motor_ligado==1'b0)) begin
			$monitor("CENARIO 2: terminou fechado: PASS");
		end else begin
			$monitor("CENARIO 2: terminou fechado: FAIL");
		end

		//CENARIO 3: abre de novo, a contagem tem que comecar do zero
		#1000000                   //(50 s)
		botao = 1;
		#20000
		botao = 0;
		#14180000                  //(64,2 s)
		if ((portao_aberto==1'b1) & (motor_ligado==1'b0)) begin
			$monitor("CENARIO 3: ainda aberto antes dos 5 s: PASS");
		end else begin
			$monitor("CENARIO 3: ainda aberto antes dos 5 s: FAIL");
		end
		#600000                    //(64,8 s)
		if ((motor_ligado==1'b1) & (motor_sentido==1'b0)) begin
			$monitor("CENARIO 3: fechou sozinho depois dos 5 s: PASS");
		end else begin
			$monitor("CENARIO 3: fechou sozinho depois dos 5 s: FAIL");
		end
		#10200000                  //(75 s)
		if ((barra_led==10'b0000000000) & (motor_ligado==1'b0)) begin
			$monitor("CENARIO 3: terminou fechado: PASS");
		end else begin
			$monitor("CENARIO 3: terminou fechado: FAIL");
		end

		//CENARIO 4: botao enquanto abre, o portao para no meio
		#1000000                   //(76 s)
		botao = 1;
		#20000
		botao = 0;
		#2980000                   //(79 s) 3 s abrindo
		botao = 1;
		#20000
		botao = 0;
		#180000                    //(79,2 s)
		if ((motor_ligado==1'b0) & (portao_aberto==1'b0) & (barra_led==10'b0000000111)) begin
			$monitor("CENARIO 4: parou no meio: PASS");
		end else begin
			$monitor("CENARIO 4: parou no meio: FAIL");
		end
		#6000000                   //(85,2 s) mais de 5 s parado
		if ((motor_ligado==1'b0) & (portao_aberto==1'b0) & (barra_led==10'b0000000111)) begin
			$monitor("CENARIO 4: nao fecha sozinho no meio: PASS");
		end else begin
			$monitor("CENARIO 4: nao fecha sozinho no meio: FAIL");
		end
		#400000                    //(85,6 s)
		botao = 1;
		#20000
		botao = 0;
		#80000                     //(85,7 s)
		if ((motor_ligado==1'b1) & (motor_sentido==1'b0)) begin
			$monitor("CENARIO 4: botao fecha: PASS");
		end else begin
			$monitor("CENARIO 4: botao fecha: FAIL");
		end
		#3300000                   //(89 s)
		if ((barra_led==10'b0000000000) & (motor_ligado==1'b0)) begin
			$monitor("CENARIO 4: terminou fechado: PASS");
		end else begin
			$monitor("CENARIO 4: terminou fechado: FAIL");
		end

		//CENARIO 5: botao enquanto fecha, o portao para no meio e depois abre
		#1000000                   //(90 s)
		botao = 1;
		#20000
		botao = 0;
		#17780000                  //(107,8 s) fechando sozinho ha 3 s
		botao = 1;
		#20000
		botao = 0;
		#180000                    //(108 s)
		if ((motor_ligado==1'b0) & (portao_aberto==1'b0) & (barra_led==10'b0001111111)) begin
			$monitor("CENARIO 5: parou no meio: PASS");
		end else begin
			$monitor("CENARIO 5: parou no meio: FAIL");
		end
		#2000000                   //(110 s)
		botao = 1;
		#20000
		botao = 0;
		#180000                    //(110,2 s)
		if ((motor_ligado==1'b1) & (motor_sentido==1'b1)) begin
			$monitor("CENARIO 5: botao abre de novo: PASS");
		end else begin
			$monitor("CENARIO 5: botao abre de novo: FAIL");
		end
		#2800000                   //(113 s)
		if (portao_aberto==1'b1) begin
			$monitor("CENARIO 5: abriu: PASS");
		end else begin
			$monitor("CENARIO 5: abriu: FAIL");
		end
		#4200000                   //(117,2 s)
		if ((portao_aberto==1'b1) & (motor_ligado==1'b0)) begin
			$monitor("CENARIO 5: ainda aberto antes dos 5 s: PASS");
		end else begin
			$monitor("CENARIO 5: ainda aberto antes dos 5 s: FAIL");
		end
		#600000                    //(117,8 s)
		if ((motor_ligado==1'b1) & (motor_sentido==1'b0)) begin
			$monitor("CENARIO 5: fechou sozinho depois dos 5 s: PASS");
		end else begin
			$monitor("CENARIO 5: fechou sozinho depois dos 5 s: FAIL");
		end
		#10200000                  //(128 s)
		if ((barra_led==10'b0000000000) & (motor_ligado==1'b0)) begin
			$monitor("CENARIO 5: terminou fechado: PASS");
		end else begin
			$monitor("CENARIO 5: terminou fechado: FAIL");
		end

		$finish;
	end

endmodule
