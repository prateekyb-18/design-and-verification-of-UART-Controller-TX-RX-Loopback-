# UART Controller (TX-RX Loopback) using verilog

This is a simple UART (Universal Asynchronous Receiver Transmitter) I built using Verilog. It covers the full communication flow — generating the baud rate, transmitting data serially, and receiving it back — all verified through simulation.

---

## What's Inside

The design has four modules that work together:

- **baud_gen** — generates a tick every 10 clock cycles to control the timing of TX and RX
- **uart_tx** — takes an 8-bit value and sends it out as a serial stream (start bit → 8 data bits → stop bit)
- **uart_rx** — listens on the line, detects the start bit, and reconstructs the original byte
- **uart_top** — wires everything together with a loopback (TX feeds directly into RX), which makes it easy to test without any external hardware

---

## How to Simulate

I used Icarus Verilog for simulation and GTKWave to view the waveforms.

```bash
# Compile
iverilog -g2012 -o sim tb_uart.sv uart_top.v uart_tx.v uart_rx.v baud_gen.v

# Run
vvp sim
```

You should see this in the terminal:
```
=================================
TRANSMITTED DATA = 68
RECEIVED DATA    = 68
=================================
```

To view the waveform:
```bash
gtkwave wave.vcd
```

---

## Test Details

The testbench sends the byte `0x68` and waits until the receiver confirms it got the same value back. The clock runs at 100 MHz and the baud divider is set to 10, so you get a baud tick every 10 cycles.

![UART Block Diagram](docs/[block-dia](https://github.com/user-attachments/assets/513edd0a-e979-48fe-9c03-885f88c2cf97)
)
)

---

## Tools Used

- Icarus Verilog — simulation
- GTKWave — waveform viewer  
- Yosys — synthesis and design stats

---

Built this as part of learning RTL design and digital communication fundamentals. Feel free to use or modify it.
