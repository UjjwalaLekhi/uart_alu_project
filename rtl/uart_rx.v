module uart_rx (
    input clk,
    input rx,
    output reg [7:0] data_out = 0,
    output reg data_valid = 0
);

parameter CLKS_PER_BIT = 10;

reg [3:0] state = 0;
reg [3:0] bit_index = 0;
reg [15:0] clk_count = 0;
reg [7:0] data_reg = 0;

localparam IDLE  = 0;
localparam START = 1;
localparam DATA  = 2;
localparam STOP  = 3;

always @(posedge clk) begin
    case(state)

        IDLE: begin
            data_valid <= 0;
            if(rx == 0) begin // start bit detected
                clk_count <= 0;
                state <= START;
            end
        end

        START: begin
            if (clk_count < (CLKS_PER_BIT / 2)) begin
                clk_count <= clk_count + 1;
            end
            else begin
                clk_count <= 0;
                if (rx == 0) begin
                    bit_index <= 0;
                    state     <= DATA;  // valid start bit
                end
                else begin
                    state     <= IDLE;  // just noise stay in the state IDLE.
                end
            end
        end      


        DATA: begin
            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
                clk_count <= 0;
                data_reg[bit_index] <= rx;

                if(
				bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                    state <= STOP;
            end
        end

        STOP: begin
            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else begin
				clk_count <= 0;
                state <= IDLE;
				
				if (rx == 1) begin
                    data_out   <= data_reg;
                    data_valid <= 1;  // data is clean and valid
                end
                else begin
                    data_valid <= 0;  // Framing error
                    
                end
               
            end
        end

    endcase
end

endmodule