module baud_gen(
    input clk,
    input rst,
    output reg baud_tick
);

parameter DIV = 10;

reg [3:0] count;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        count <= 0;
        baud_tick <= 0;
    end
    else
    begin
        if(count == DIV-1)
        begin
            count <= 0;
            baud_tick <= 1;
        end
        else
        begin
            count <= count + 1;
            baud_tick <= 0;
        end
    end
end

endmodule
