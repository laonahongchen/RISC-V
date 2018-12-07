`include "defines.vh"
module id_ex (
    input wire              clk,
    input wire              rst,

    input wire[`AluOpBus]   id_aluop,
    input wire[`AluSelBus]  id_alusel,
    input wire[`RegBus]     id_reg1,
    input wire[`RegBus]     id_reg2,
    input wire[`RegAddrBus] id_wd,
    input wire              id_wreg,
    input wire              id_pc,
    input wire[`RegBus]     id_offset,

    input wire[`StallBus]   stall,
    input wire              ex_b_flag_i,

    output reg[`AluOpBus]   ex_aluop,
    output reg[`AluSelBus]  ex_alusel,
    output reg[`RegBus]     ex_reg1,
    output reg[`RegBus]     ex_reg2,
    output reg[`RegAddrBus] ex_wd,
    output reg              ex_wreg,
    output reg              ex_pc,
    output reg[`RegBus]     ex_offset
);

reg next_jump;

always @ ( posedge clk ) begin
    if(rst == `RstEnable) begin
        ex_aluop <= `EX_NOP_OP;
        ex_alusel <= `EX_RES_NOP;
        ex_reg1 <= `ZeroWord;
        ex_reg2 <= `ZeroWord;
        ex_wd <= `NOPRegAddr;
        ex_wreg <= `WriteDisable;
        ex_pc <= `ZeroWord;
        ex_offset <= `ZeroWord;
        next_jump <= 1'b0;
    end else if (ex_b_flag_i) begin
        if(stall[2] == `Stop && stall[3] == `NoStop) begin
            ex_aluop <= `EX_NOP_OP;
            ex_alusel <= `EX_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
            ex_pc <= `ZeroWord;
            ex_offset <= `ZeroWord;
            next_jump <= 1'b1;
        end else if(stall[2] == `Stop) begin
            ex_aluop <= `EX_NOP_OP;
            ex_alusel <= `EX_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
            ex_pc <= `ZeroWord;
            ex_offset <= `ZeroWord;
            next_jump <= 1'b1;
        end else begin
            ex_aluop <= `EX_NOP_OP;
            ex_alusel <= `EX_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
            ex_pc <= `ZeroWord;
            ex_offset <= `ZeroWord;
            next_jump <= 1'b0;
        end
    end else if (stall[2] == `Stop && stall[3] == `NoStop) begin
        ex_aluop <= `EX_NOP_OP;
        ex_alusel <= `EX_RES_NOP;
        ex_reg1 <= `ZeroWord;
        ex_reg2 <= `ZeroWord;
        ex_wd <= `NOPRegAddr;
        ex_wreg <= `WriteDisable;
        ex_pc <= `ZeroWord;
        ex_offset <= `ZeroWord;
    end else if(stall[2] == `NoStop)begin
        if(next_jump) begin
            ex_aluop <= `EX_NOP_OP;
            ex_alusel <= `EX_RES_NOP;
            ex_reg1 <= `ZeroWord;
            ex_reg2 <= `ZeroWord;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WriteDisable;
            ex_pc <= `ZeroWord;
            ex_offset <= `ZeroWord;
            next_jump <= 1'b0;
        end else begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
            ex_pc <= id_pc;
            ex_offset <= id_offset;
            next_jump <= 1'b0;
        end
    end
end

endmodule // id_ex
