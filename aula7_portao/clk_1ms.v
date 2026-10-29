module clk_1ms (
	input rst,
	input clk_50M,
	output reg clk_out
);

	reg [14:0] contagem; //32767 > 25000

	always @(posedge clk_50M) begin
		if(rst) begin
			contagem <= 0;
			clk_out  <= 0;
		end else begin
			if(contagem == 15'd24999) begin
				contagem <= 0;           //zera pra comecar de novo
				clk_out  <= ~clk_out;    //inverte a cada 0,5 ms
			end else begin
				contagem <= contagem + 1;
			end
		end
	end

endmodule
