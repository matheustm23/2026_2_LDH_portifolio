`timescale 1us/1us
module tb_basic_add;

	//Sinais
	reg [3:0] a;
	reg [3:0] b;
	wire [4:0] s;
	
	//Instancia do DUT
	adder_4b dut (
		.a(a), .b(b), .s(s)
	);
	
	//Stimuli
	initial begin //Bloco initial, executa uma unica vez (não é sintetizavel)
		a = 0; b = 0;
		#10
		a = 1; b = 1;
		#10
		a = 3; b = 5;
		#10
		a = 7; b = 9;
		#10
		$finish;
	end

endmodule