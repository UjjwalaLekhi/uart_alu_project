# uart_alu_project
In this project we have a 4 bit ALU that has been interfaced with a UART transmitter and receiver. Main components include:
1. ALU
It is a 4bit ALU where in we input 2 operands (4 bit each) and the operator (2 bit). For the operator we have 4 choices: ADD, SUB, bitwise OR, bitwise AND
2. UART transmitter-receiver
   UART RX: Samples incoming serial stream data which consists of operands and operator and feeds it to the ALU.
   UART TX: Combines the 4-bit result with upper zeros (`{4'b0000, Y}`) and sends it back to the host system.

Improvements to be done:
1. Transition to Full 8-Bit Processing
2. Expanded ALU Operations
3. RAM and ROM Memory Subsystem
4. Add CPU registers to store intermediate values instead of immediate UART transmission.
5. Interface with I2C/SPI OLED screen module 
