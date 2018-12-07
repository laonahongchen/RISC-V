`include "defines.vh"
module ex (
    input wire                  rst,

    input wire[`InstAddrBus]    pc_i,
    input wire[`AluOpBus]       aluop_i,
    input wire[`AluSelBus]      alusel_i,
    input wire[`RegBus]         reg1_i,
    input wire[`RegBus]         reg2_i,
    input wire[`RegAddrBus]     wd_i,
    input wire                  wreg_i,

    input wire[`RegBus]         offset_i,

    output reg[`RegAddrBus]     wd_o,
    output reg                  wreg_o,
    output reg[`RegBus]         wdata_o,
    output reg                  stall_req_o,

    output reg                  b_flag_o,
    output wire[`InstAddrBus]   b_target_o,

);

reg[`RegBus] logicout;
reg[`RegBus] shiftout;
reg[`RegBus] arithout;
reg[`RegBus] pcout = pc_i + 4;

always @ ( * ) begin
    if(rst == `RstEnable) begin
        b_flag_o = 1'b0;
        b_target_o = `ZeroWord;
    end else begin
        b_flag_o = 1'b0;
        b_target_o = `ZeroWord;
        case (aluop_i)
            `EX_JALR_OP: begin
                b_flag_o = 1'b1;
                b_target_o = {(r1_data_i + r2_data_i)[31:1], 1'b0};
            end
            `EX_BNE_OP:  begin
                b_flag_o = ~(r1_data_i == r2_data_i);
                b_target_o = pc_o + offset_i;
            end
            `EX_BEQ_OP: begin
                b_flag_o = (r1_data_i == r2_data_i);
                b_target_o = pc_o + offset_i;
            end
            `EX_BLT_OP: begin
                b_flag_o = ($signed(r1_data_i) < $signed(r2_data_i));
                b_target_o = pc_o + offset_i;
            end
            `EX_BGE_OP: begin
                b_flag_o = ($signed(r1_data_i) > $signed(r2_data_i));
                b_target_o = pc_o + offset_i;
            end
            `EX_BLTU_OP: begin
                b_flag_o = ((r1_data_i) < (r2_data_i));
                b_target_o = pc_o + offset_i;
            end
            `EX_BGEU_OP: begin
                b_flag_o = ((r1_data_i) > (r2_data_i));
                b_target_o = pc_o + offset_i;
            end
            default: begin
            end
        endcase
    end
end

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
                logicout = `ZeroWord;
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
            default : begin
                shiftout = `ZeroWord;
            end
        endcase
    end
end

always @ ( * ) begin
    if(rst == `RstEnable) begin
        arithout <= `ZeroWord;
    end else begin
        case(aluop_i)
            `EX_ADD_OP: begin
                arithout = reg1_i + reg2_i;
            end
            `EX_SUB_OP: begin
                arithout = reg1_i - re2_i;
            end
            `EX_SLT_OP: begin
                arithout = $signed(reg1_i) < $signed(reg2_i);
            end
            `EX_SLTU_OP : begin
                arithout = reg1_i < reg2_i;
            end
            default: begin
                arithout = `ZeroWord;
            end
        endcase
    end
end



always @ ( * ) begin
    wd_o <= wd_i;
    wreg_o <= wreg_i;
    case (alusel_i)
        `EX_RES_JAL: begin
            wdata_o = pcout;
        end
        `EX_RES_LOGIC: begin
            wdata_o = logicout;
        end
        `EX_RES_SHIFT: begin
            wdata_o = shiftout;
        end
        `EX_RES_ARITH: begin
            wdata_o = arithout;
        end
        default: begin
            wdata_o = `ZeroWord;
        end
    endcase
end

endmodule // ex
