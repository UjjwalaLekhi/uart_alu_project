module alu (
    input  [3:0] A,
    input  [3:0] B,
    input  [1:0] op,
    output reg [3:0] Y,
    output reg carry
);

always @(*) begin
    case(op)
        2'b00: begin  // ADD
            {carry, Y} = A + B;
        end

        2'b01: begin  // SUB
            {carry, Y} = A - B;
        end

        2'b10: begin  // AND
            Y = A & B;
            carry = 0;
        end

        2'b11: begin  // OR
            Y = A | B;
            carry = 0;
        end

        default: begin
            Y = 4'b0000;
            carry = 0;
        end
    endcase
end
endmodule