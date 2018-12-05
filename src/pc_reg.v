`include "defines.vh"

module pc_reg(
    input wire                  clk,
    input wire                  rst,
    input wire[`StallBus]             stall,

    output reg[`InstAddrBus]    pc,
    output reg                  ce
);
    always @ ( posedge clk ) begin
        if (rst == `RstEnable) begin
            ce <= `ChipsDisable;
        end else begin
            ce <= `ChipsEnable;
        end
    end

    always @ ( posedge clk ) begin
        if (ce == `ChipsDisable)  begin
            pc <= 32'h00000000;
        end else if(stall[0] == `NoStop) begin
            pc <= pc + 4'h4;
        end
    end
endmodule
