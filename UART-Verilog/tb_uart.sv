`timescale 1ns/1ps

module tb_uart;

/////////////////////////////////////////////////
// SIGNAL DECLARATION
/////////////////////////////////////////////////
logic clk;
logic rst;
logic start;
logic [7:0] tx_data;

logic tx;
logic [7:0] rx_data;
logic done_tx;
logic done_rx;

/////////////////////////////////////////////////
// CLOCK GENERATION (100MHz)
/////////////////////////////////////////////////
initial clk = 0;
always #5 clk = ~clk;   // 10ns period

/////////////////////////////////////////////////
// DUT INSTANTIATION
/////////////////////////////////////////////////
uart_top DUT (
    .clk(clk),
    .rst(rst),
    .start(start),
    .tx_data(tx_data),

    .tx(tx),
    .rx_data(rx_data),
    .done_tx(done_tx),
    .done_rx(done_rx)
);

/////////////////////////////////////////////////
// WAVEFORM DUMP
/////////////////////////////////////////////////
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_uart);
end

/////////////////////////////////////////////////
// TEST SEQUENCE
/////////////////////////////////////////////////
initial begin
    // INITIAL VALUES
    rst = 1;
    start = 0;
    tx_data = 8'h00;

    #50;
    rst = 0;

    //////////////////////////////////////////////////
    // SEND DATA = 0x55
    //////////////////////////////////////////////////
    #100;
    tx_data = 8'h68;
    start = 1;

    #10;
    start = 0;

    //////////////////////////////////////////////////
    // WAIT FOR RX COMPLETE
    //////////////////////////////////////////////////
    wait(done_rx);

    $display("=================================");
    $display("TRANSMITTED DATA = %h", tx_data);
    $display("RECEIVED DATA    = %h", rx_data);
    $display("=================================");

    #5000;
    $finish;
end

endmodule
