module uart_top(
    input clk,
    input rst,
    input start,
    input [7:0] tx_data,

    output tx,
    output [7:0] rx_data,
    output done_tx,
    output done_rx
);

/////////////////////////////////////////////////
// BAUD GENERATOR
/////////////////////////////////////////////////
wire baud_tick;

baud_gen baud_inst (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

/////////////////////////////////////////////////
// INTERNAL CONNECTION
/////////////////////////////////////////////////
wire tx_line;

assign tx = tx_line;   // output
wire rx_line = tx_line; // loopback TX → RX

/////////////////////////////////////////////////
// UART TRANSMITTER
/////////////////////////////////////////////////
uart_tx tx_inst (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .start(start),
    .tx_data(tx_data),
    .tx(tx_line),
    .done(done_tx)
);

/////////////////////////////////////////////////
// UART RECEIVER
/////////////////////////////////////////////////
uart_rx rx_inst (
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick),
    .rx(rx_line),
    .rx_data(rx_data),
    .done(done_rx)
);

endmodule
