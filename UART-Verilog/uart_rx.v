module uart_rx(
    input clk,
    input rst,
    input baud_tick,
    input rx,

    output reg [7:0] rx_data,
    output reg done
);

reg [3:0] bit_cnt;
reg [9:0] shift_reg;
reg receiving;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        receiving <= 0;
        bit_cnt   <= 0;
        done      <= 0;
        rx_data   <= 0;
    end
    else
    begin
        done <= 0;

        // Detect START bit (rx goes LOW)
        if (!receiving && rx == 0)
        begin
            receiving <= 1;
            bit_cnt   <= 0;
        end

        // Receive bits on baud tick
        else if (receiving && baud_tick)
        begin
            shift_reg <= {rx, shift_reg[9:1]};
            bit_cnt   <= bit_cnt + 1;

            // After 10 bits received
            if (bit_cnt == 9)
            begin
                receiving <= 0;
                rx_data <= shift_reg[9:2]; // extract data
                done <= 1;
            end
        end
    end
end

endmodule
