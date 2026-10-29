module contador_5s (
	input clk,                //clock de 1 s
	input portao_aberto,      //vem da FSM
	output tempo_esgotado     //volta pra FSM
);

	reg [2:0] segundos;

	always @(posedge clk) begin
		if(portao_aberto == 1'b0)
			segundos <= 0;            //portao nao esta aberto, zera
		else if(segundos == 3'd5)
			segundos <= 3'd5;         //para no 5
		else
			segundos <= segundos + 1;
	end

	assign tempo_esgotado = (segundos == 3'd5);

endmodule
