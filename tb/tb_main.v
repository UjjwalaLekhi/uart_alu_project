`timescale 1ns/1ps

module tb_main;

reg clk = 0;
reg rx = 1;   // idle HIGH
wire tx;

parameter CLKS_PER_BIT = 10;

// Instantiate top
main uut (
    .clk(clk),
    .rx(rx),
    .tx(tx)
);

// Clock
always #5 clk = ~clk;


// Task: send UART byte
task send_byte;
    input [7:0] data;
    integer i;
    begin
        // START bit
        rx = 0;
        #(CLKS_PER_BIT * 10);

        // DATA bits (LSB first)
        for(i = 0; i < 8; i = i + 1) begin
            rx = data[i];
            #(CLKS_PER_BIT * 10);
        end

        // STOP bit
        rx = 1;
        #(CLKS_PER_BIT * 10);
    end
endtask


initial begin
    $dumpfile("sim/dump_main.vcd");
    $dumpvars(0, tb_main);

    #50;

    // Send A=3, B=2 → 0011 0010 = 0x32 → result = 5
    send_byte(8'h32);

    #2000;

    // Send A=7, B=5 → 0111 0101 = 0x75 → result = 12
    send_byte(8'h75);

    #3000;

    $finish;
end

endmodule