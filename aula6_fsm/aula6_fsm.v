`define STATE_CLOSED 	2'b00
`define STATE_CLOSING 2'b01
`define STATE_OPEN 	2'b10
`define STATE_OPENING 2'b11

module fsm_gate_ctrl(

	input rst,
	input clk,
	
	//Sinais de controle
	input user_button, //controle do portao
	input start_stop, //fim de curso portao aberto
	input end_stop, //fim de curso portao fechado
	
	//Saidas
	output reg motor_power, //liga/desliga motor
	output reg motor_direction //direcao do motor
	
);

	reg[1:0] state;
	reg[1:0] nextState;
	
	//Motor de estados
	always @(posedge clk) begin
		if(rst) begin //reset sincrono
			state <= `STATE_CLOSED;		
		end else begin
			state <= nextState; 
		end
	end
		
	//Logica de transicao
	always @(*) begin
		case(state)
			`STATE_CLOSED: begin
				if(user_button == 1'b0) begin
					nextState = `STATE_CLOSED;
				end else begin
					nextState = `STATE_OPENING;
				end
			end
			
			`STATE_OPENING: begin
				if(end_stop == 1'b0) begin
					nextState = `STATE_OPENING;
				end else begin
					nextState = `STATE_OPEN;
				end
			end	
			
			`STATE_OPEN: begin
				if(user_button == 1'b0) begin
					nextState = `STATE_OPEN;
				end else begin
					nextState = `STATE_CLOSING;
				end
			end
			
			`STATE_CLOSING: begin
				if(start_stop == 1'b0) begin
					nextState = `STATE_CLOSING;
				end else begin
					nextState = `STATE_CLOSED;
				end
			end
			
			default: begin
				nextState = `STATE_CLOSED;
			end
			
		endcase
	end
	
	//Logica de saida
	always @(*) begin
		case(state)
		
			`STATE_OPENING: begin
				motor_power = 1;
				motor_direction = 1;
			end
			
			`STATE_CLOSING: begin
				motor_power = 1;
				motor_direction = 0;
			end
			
			default: begin
				motor_power = 0;
				motor_direction = 0;
			end
			
		endcase
	end

endmodule