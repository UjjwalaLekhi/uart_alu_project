timescale 1ns

module tb_alu;

reg [3:0] A, B;
reg [1:0] op;
wire [3:0] Y;
wire carry;

alu uut (
    .A(A),
    .B(B),
    .op(op),
    .Y(Y),
    .carry(carry)
);

initial begin
    // waveform
    $dumpfile("sim/dump.vcd");
    $dumpvars(0, tb_alu);

    // test values
    A = 4'd3; B = 4'd2;

    op = 2'b00; #10; // result 5
    op = 2'b01; #10; // result 1
    op = 2'b10; #10; // result 2
    op = 2'b11; #10; // result 3

    // test values
    A = 4'd7; B = 4'd5;

    op = 2'b00; #10; // result 12
    op = 2'b01; #10; // result 2
    op = 2'b10; #10; // result 5
    op = 2'b11; #10; // result 7

    $finish;
end

endmodule