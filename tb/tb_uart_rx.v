`timescale 1ns/1ps

module tb_uart_rx;

reg clk = 0;
reg rx = 1;   // idle HIGH

wire [7:0] data_out;
wire data_valid;

parameter CLKS_PER_BIT = 10;

uart_rx uut (
    .clk(clk),
    .rx(rx),
    .data_out(data_out),
    .data_valid(data_valid)
);

// Clock 10 ns period
always #5 clk = ~clk;


// Task to send 1 byte over UART
task send_byte;
    input [7:0] data;
    integer i;
    begin
        // Start bit
        rx = 0;
        #(CLKS_PER_BIT * 10);

        // data bits (LSB first)
        for(i = 0; i < 8; i = i + 1) begin
            rx = data[i];
            #(CLKS_PER_BIT * 10);
        end

        // stop bit
        rx = 1;
        #(CLKS_PER_BIT * 10);
    end
endtask


initial begin
    $dumpfile("sim/dump_uart_rx.vcd");
    $dumpvars(0, tb_uart_rx);

    #50;

    // Send 0xA5
    send_byte(8'hA5);

    #500;

    // Send 0x3C
    send_byte(8'h3C);

    #1000;

    $finish;
end

endmodule