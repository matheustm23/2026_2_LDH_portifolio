module clk_1s (
	input rst,
	input clk_50M,
	output reg clk_out
);

	reg [24:0] contagem; //33554431 > 25M

	always @(posedge clk_50M) begin
		if(rst) begin
			contagem <= 0;
			clk_out  <= 0;
		end else begin
			if(contagem == 25'd24999999) begin
				contagem <= 0;           //zera pra comecar de novo
				clk_out  <= ~clk_out;    //inverte a cada 0,5 s
			end else begin
				contagem <= contagem + 1;
			end
		end
	end

endmodule
