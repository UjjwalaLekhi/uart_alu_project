module uart_tx (
    input clk,
    input start,
    input [7:0] data,
    output reg tx = 1,
    output reg busy = 0
);

parameter CLKS_PER_BIT = 10;

reg [1:0] state = 0;
reg [3:0] bit_index = 0;
reg [7:0] data_reg = 0;
reg [15:0] clk_count = 0;
//FSM states
localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

always @(posedge clk) begin
    case(state)

        IDLE: begin//idle state
            tx <= 1;//non blocking
            busy <= 0;
            clk_count <= 0;
            bit_index <= 0;

            if(start) begin
                busy <= 1;
                data_reg <= data;
                state <= START;
            end
        end

        START: begin
            tx <= 0;// transmission goes out of idle state

            if(clk_count < CLKS_PER_BIT-1)//after 10 clock cycles or whatever width is chosen for the transmission of each bit
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                state <= DATA;
            end
        end

        DATA: begin
            tx <= data_reg[bit_index];

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;

                if(bit_index < 7)//if all data bits will be sent by current clock cycle
                    bit_index <= bit_index + 1;
                else begin
                    bit_index <= 0;
                    state <= STOP;
                end
            end
        end

        STOP: begin
            tx <= 1;// stop bit

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                busy <= 0;
                state <= IDLE;
            end
        end

    endcase
end

endmodule