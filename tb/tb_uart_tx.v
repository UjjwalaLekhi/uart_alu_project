`timescale 1ns/1ps

module tb_uart_tx;

reg clk = 0;
reg start = 0;
reg [7:0] data = 8'hA5;
wire tx;
wire busy;

uart_tx uut (
    .clk(clk),
    .start(start),
    .data(data),
    .tx(tx),
    .busy(busy)
);

// clock has 10 ns period
always #5 clk = ~clk;

initial begin
    $dumpfile("sim/dump_uart_tx.vcd");
    $dumpvars(0, tb_uart_tx);

    // delay
    #20;

    // start pulse 
    @(posedge clk);
    start <= 1;

    @(posedge clk);
    start <= 0;

    @(negedge busy);
    #100;

    $finish;
end

endmodule