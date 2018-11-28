module regfile (
    input wire clk,
    input wire rst,

    input wire we,
    input wire[`RegAddrBus] waddr,
    input wire[`RegBus] wdata,

    input wire re1,
    input wire[`RegAddrBus] raddr1,
    output reg[`RegBus] rdata1,

    input wire re2,
    input wire[`RegAddrBus] raddr2,
    output reg[`RegBus] rdata2,
);

reg[`RegBus] regs[0:`RegNum - 1];


endmodule // regfile
