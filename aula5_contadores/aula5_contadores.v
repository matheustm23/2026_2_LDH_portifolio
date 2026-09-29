module clk_1s (
	input rst,
	input clk_50M,
	output reg clk_out
);

	reg [24:0] count; //2^25 = 33554432
	
	always @(posedge clk_50M) begin
		if(rst)begin
			count 	<= 0;
			clk_out	<= 0;
		end else begin
			count <= count+1;
			if(count == 25'd25000000)
				begin clk_out <= ~clk_out;	//alterna clock_out
			end
		end
	end
endmodule