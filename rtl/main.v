module main (
    input clk,
    input rx,
    output tx
);

wire [7:0] rx_data;
wire rx_valid;

wire [3:0] A, B;
wire [3:0] Y;
wire carry;

reg start_tx = 0;
wire tx_busy;

// UART RX
uart_rx rx_inst (
    .clk(clk),
    .rx(rx),
    .data_out(rx_data),
    .data_valid(rx_valid)
);

// Decode
assign A = rx_data[7:4];
assign B = rx_data[3:0];

// ALU (ADD)
alu alu_inst (
    .A(A),
    .B(B),
    .op(2'b00),
    .Y(Y),
    .carry(carry)
);

// UART TX
uart_tx tx_inst (
    .clk(clk),
    .start(start_tx),
    .data({4'b0000, Y}),
    .tx(tx),
    .busy(tx_busy)
);

// Control logic
always @(posedge clk) begin
    if (rx_valid && !tx_busy)
        start_tx <= 1;
    else
        start_tx <= 0;
end

endmodule