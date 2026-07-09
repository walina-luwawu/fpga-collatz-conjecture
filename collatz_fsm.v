module collatz_fsm
(
    input pulse_step, pulse_auto, rst_n, clk,
    input clk_divider_tick,
    input [7:0] current_term,
	 
    output [2:0] fsm_state,
	 output [7:0] term_count
);
//define states
    localparam STATE_IDLE = 3'b000,
               STATE_HOLD = 3'b001,
               STATE_STEP = 3'b010,
               STATE_AUTO = 3'b011,
               STATE_DONE = 3'b100;

    reg [2:0] current_state; 
    reg [2:0] next_state;
    reg [7:0] tc;
	 
//find the next state from the current state and input pulses
    always @(*) begin
        case (current_state)
            STATE_IDLE: begin
                if (pulse_step & ~pulse_auto)
						next_state = STATE_STEP;
                else if (pulse_auto & ~pulse_step) 
						next_state = STATE_AUTO;
                else 
						next_state = STATE_HOLD;
            end
            STATE_HOLD: begin
                if (current_term == 8'd1)
						next_state = STATE_DONE;
                else if (pulse_step & ~pulse_auto)
						next_state = STATE_STEP;
                else if (pulse_auto & ~pulse_step)
						next_state = STATE_AUTO;
                else
						next_state = STATE_HOLD;
            end
            STATE_STEP: begin
                if (current_term == 8'd1)
						next_state = STATE_DONE;
                else
						next_state = STATE_HOLD;
            end
            STATE_AUTO: begin
                if (current_term == 8'd1)
						next_state = STATE_DONE;
                else 
						next_state = STATE_AUTO;
            end
            STATE_DONE: next_state = STATE_IDLE;
            default: next_state = current_state;
        endcase
    end
    
//increment counter if the current state is step or auto
    always @(posedge clk or negedge rst_n) begin
         if (!rst_n) begin
              current_state <= STATE_IDLE;
              tc <= 8'd0;
         end else begin
              current_state <= next_state;
              
              if (current_state == STATE_IDLE) begin
                  tc <= 8'd0;
              end
				  else begin
                  if (current_state == STATE_STEP) begin
                      tc <= tc + 1'b1;
                  end
						else if (current_state == STATE_AUTO && clk_divider_tick) begin
                      tc <= tc + 1'b1;
                  end
              end
         end
    end
	 
	 assign fsm_state = current_state;
	 assign term_count = tc;
	 
endmodule
	