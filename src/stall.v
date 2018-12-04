`include "defines.vh"
module stall (
    input wire rst,
    input wire if_stall_req,
    input wire id_stall_req,
    input wire ex_stall_req,
    input wire me_stall_req,
    input wire wb_stall_req,

    output reg[4:0] stall
);

always @ ( * ) begin
    if(rst) begin
        stall = `NoStall;
    end else if(wb_stall_req == `StallReq) begin
        stall = `WbStall;
    end else if(me_stall_req == `StallReq) begin
        stall = `MemStall;
    end else if(ex_stall_req == `StallReq) begin
        stall = `ExStall;
    end else if(id_stall_req == `StallReq) begin
        stall = `IdStall;
    end else if(if_stall_req == `StallReq) begin
        stall = `IfStall;
    end else begin
        stall = `NoStall;
    end
end

endmodule // stall
