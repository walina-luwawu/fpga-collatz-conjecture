module collatz_sm
(
    input        pulse_step,
    input        pulse_auto,
    input        clk_divider_tick,
    input        rst_n,
    input        clk,
    input  [7:0] init_term,

    output [7:0] current_term,
    output [7:0] term_count
);

    localparam IDLE = 3'b000,
               HOLD = 3'b001,
               STEP = 3'b010,
               AUTO = 3'b011,
               DONE = 3'b100;

    reg [2:0] current_state;
    reg [2:0] next_state;
    reg [7:0] tmp_current_term;
    reg [7:0] tmp_term_count;

    wire [7:0] next_term;
	 
    collatz_calculator u0 (
        .current_term (tmp_current_term),
        .next_term    (next_term)
    );

    always @(*) begin
        next_state = current_state;

        case (current_state)
		  
            IDLE: begin
                if (pulse_step && !pulse_auto)
                    next_state = STEP;
                else if (pulse_auto && !pulse_step)
                    next_state = AUTO;
                else
                    next_state = HOLD;
            end

            HOLD: begin
                if (tmp_current_term == 8'd1)
                    next_state = DONE;
                else if (pulse_step && !pulse_auto)
                    next_state = STEP;
                else if (pulse_auto && !pulse_step)
                    next_state = AUTO;
                else
                    next_state = HOLD;
            end

            STEP: begin
                if (next_term == 8'd1)
                    next_state = DONE;
                else
                    next_state = HOLD;
            end

            AUTO: begin
                if (tmp_current_term == 8'd1)
                    next_state = DONE;
                else
                    next_state = AUTO;
            end

            DONE: begin
                next_state = HOLD;
            end


            default: begin
                next_state = IDLE;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state    <= IDLE;
            tmp_current_term <= 8'd0;
            tmp_term_count   <= 8'd0;
        end
        else begin
            if (pulse_step || pulse_auto || clk_divider_tick)
                current_state <= next_state;
            if (current_state == IDLE) begin
                tmp_current_term <= init_term;
                tmp_term_count   <= 8'd0;
            end
            else if (current_state == STEP) begin
                tmp_current_term <= next_term;
                tmp_term_count   <= tmp_term_count + 8'd1;
            end
            else if ((current_state == AUTO) && clk_divider_tick) begin
                tmp_current_term <= next_term;
                tmp_term_count   <= tmp_term_count + 8'd1;
            end
        end
    end

    assign current_term = tmp_current_term;
    assign term_count   = tmp_term_count;

endmodule