module uart_tx(
    input clk,
    input rst,
    input baud_tick,
    input start,
    input [7:0] tx_data,

    output reg tx,
    output reg done
);

reg [3:0] bit_cnt;
reg [9:0] shift_reg;
reg sending;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        tx <= 1;
        done <= 0;
        sending <= 0;
        bit_cnt <= 0;
    end
    else
    begin
        done <= 0;

        if(start && !sending)
        begin
            // start + data + stop
            shift_reg <= {1'b1, tx_data, 1'b0};
            sending <= 1;
            bit_cnt <= 0;
        end

        else if(sending && baud_tick)
        begin
            tx <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_cnt <= bit_cnt + 1;

            if(bit_cnt == 9)
            begin
                sending <= 0;
                done <= 1;
                tx <= 1;
            end
        end
    end
end

endmodule
