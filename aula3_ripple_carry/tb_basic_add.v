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
	initial begin //Bloco initial, executa uma unica vez, não é sintetizavel
		a = 0; b = 0;
		#10
		#1
		$monitor("TEST1: a=%b b=%b s=%b",a, b, s);
		#1
		if (s==5'd0) begin
			$monitor("TEST1: PASS");
		end else begin
			$monitor("TEST1: FAIL");
		end
		#8
		
		a = 1; b = 1;
		#10
		#1
		$monitor("TEST2: a=%b b=%b s=%b",a, b, s);
		#1
		if (s==5'd2) begin
			$monitor("TEST2: PASS");
		end else begin
			$monitor("TEST2: FAIL");
		end
		#8
		
		a = 3; b = 5;
		#10
		#1
		$monitor("TEST3: a=%b b=%b s=%b",a, b, s);
		#1
		if (s==5'd8) begin
			$monitor("TEST3: PASS");
		end else begin
			$monitor("TEST3: FAIL");
		end
		#8
		
		a = 7; b = 9;
		#10
		#1
		$monitor("TEST4: a=%b b=%b s=%b",a, b, s);
		#1
		if (s==5'd16) begin
			$monitor("TEST4: PASS");
		end else begin
			$monitor("TEST4: FAIL");
		end
		#8
		$finish;
	end

endmodule