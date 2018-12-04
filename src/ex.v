`include "defines.vh"
module ex (
    input wire rst,

    input wire[`AluOpBus] aluop_i,
    input wire[`AluSelBus] alusel_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    input wire[`RegAddrBus] wd_i,
    input wire          wreg_i,

    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o
);

reg[`RegBus] logicout;
reg[`RegBus] shiftout;


always @ ( * ) begin
    if(rst == `RstEnable) begin
        logicout = `ZeroWord;
    end else begin
        case (aluop_i)
            `EX_OR_OP: begin
                logicout = reg1_i | reg2_i;
            end
            `EX_XOR_OP: begin
                logicout = reg1_i ^ reg2_i;
            end
            `EX_AND_OP: begin
                logicout = reg1_i & reg2_i;
            end
            default: begin
            end
        endcase
    end
end

always @ ( * ) begin
    if(rst == `RstEnable) begin
        shiftout <= `ZeroWord;
    end else begin
        case(aluop_i)
            `EX_SLL_OP: begin
                shiftout = reg1_i << (reg2_i[4:0]);
            end
            `EX_SRL_OP: begin
                shiftout = reg1_i >> (reg2_i[4:0]);
            end
            `EX_SRA_OP: begin
                shiftout = (reg1_i >> (reg2_i[4:0])) | ({32{reg1_i[31]}} << (6'd32 - {1'b0,reg2_i[4:0]}));
            end
        endcase
    end
end

always @ ( * ) begin
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case (alusel_i)
        `EX_RES_LOGIC: begin
            wdata_o = logicout;
        end
        `EX_RES_SHIFT: begin
            wdata_o = shiftout;
        end
        default: begin
            wdata_o = `ZeroWord;
        end
    endcase
end

endmodule // ex
