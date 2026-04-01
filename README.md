Design and Verification of UART Controller (TX-RX Loopback)

A fully functional UART communication system implemented in Verilog/SystemVerilog, including a Baud Rate Generator, Transmitter (TX), Receiver (RX), and a Top-level loopback design. Simulated and verified using Icarus Verilog and GTKWave.

Module Overview

1. baud_gen.v — Baud Rate Generator
Generates a baud_tick pulse every DIV clock cycles to control the TX/RX sampling rate.
Parameter	Value	Description
DIV	10	Clock divider (baud tick every 10 cycles)
Port	Direction	Width	Description
clk	Input	1	System clock
rst	Input	1	Active-high synchronous reset
baud_tick	Output	1	Baud rate pulse
________________________________________
2. uart_tx.v — UART Transmitter
Serializes an 8-bit data word into a 10-bit UART frame (1 start bit + 8 data bits + 1 stop bit) and transmits it LSB-first on the tx line.
Port	Direction	Width	Description
clk	Input	1	System clock
rst	Input	1	Active-high reset
baud_tick	Input	1	Baud rate tick from baud_gen
start	Input	1	Pulse high to begin transmission
tx_data	Input	8	Byte to transmit
tx	Output	1	Serial TX line (idle HIGH)
done	Output	1	Pulses HIGH when transmission complete
Frame format:
[ START(0) | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | STOP(1) ]
________________________________________
3. uart_rx.v — UART Receiver
Detects the start bit (falling edge on rx), then samples the incoming serial stream on each baud_tick to reconstruct the 8-bit data word.
Port	Direction	Width	Description
clk	Input	1	System clock
rst	Input	1	Active-high reset
baud_tick	Input	1	Baud rate tick from baud_gen
rx	Input	1	Serial RX line
rx_data	Output	8	Received byte
done	Output	1	Pulses HIGH when reception complete
________________________________________
4. uart_top.v — Top-Level Module (Loopback)
Instantiates baud_gen, uart_tx, and uart_rx. The TX output is wired directly back to the RX input to form a loopback connection — useful for functional verification without external hardware.
clk, rst ──► baud_gen ──► baud_tick ──► uart_tx ──► tx_line ──► uart_rx
                                                        │
                                                   (loopback)
Port	Direction	Width	Description
clk	Input	1	System clock
rst	Input	1	Active-high reset
start	Input	1	Start transmission
tx_data	Input	8	Data to transmit
tx	Output	1	TX serial output
rx_data	Output	8	Received data
done_tx	Output	1	Transmission complete
done_rx	Output	1	Reception complete
________________________________________
 Simulation
Testbench: tb_uart.sv
•	Clock: 100 MHz (10 ns period)
•	Test data: 0x68 (ASCII 'h')
•	Checks: Waits for done_rx, then prints transmitted vs received data
•	Waveform dump: Generates wave.vcd for GTKWave inspection
•	Run Simulation (Icarus Verilog)

•	Compile

1.	iverilog -g2012 -o sim tb/tb_uart.sv src/uart_top.v src/uart_tx.v src/uart_rx.v src/baud_gen.v

•	Run

1.	vvp sim

•	Expected output:

1.	 TRANSMITTED DATA = 68
2.	 RECEIVED DATA    = 68

•	View Waveform (GTKWave)
1)	gtkwave wave.vcd

📊 Block Diagram
 

 Simulation Results
The testbench transmits 0x68 and the receiver correctly captures the same byte, confirming the loopback works as expected.
Signal	Value
tx_data	0x68
rx_data	0x68
done_tx	Pulsed HIGH after 10 baud ticks
done_rx	Pulsed HIGH after full frame received

Tools Used
Tool	Purpose
Icarus Verilog
RTL simulation / compilation
GTKWave
Waveform viewer
Yosys
Synthesis & design statistics

Synthesis Stats (Yosys)
Module	Cells
baud_gen	19
uart_tx	48
uart_rx	44
Total	111


