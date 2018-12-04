`include "defines.vh"
module id (
    input wire rst,
    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        inst_i,

    input wire[`RegBus]         reg1_data_i,
    input wire[`RegBus]         reg2_data_i,

    input wire                  ex_wreg_i,
    input wire[`RegBus]         ex_wdata_i,
    input wire[`RegAddrBus]     ex_wd_i,

    input wire                  mem_wreg_i,
    input wire[`RegBus]         mem_wdata_i,
    input wire[`RegAddrBus]     mem_wd_i,

    output reg                  reg1_read_o,
    output reg                  reg2_read_o,
    output reg[`RegAddrBus]     reg1_addr_o,
    output reg[`RegAddrBus]     reg2_addr_o,

    output reg[`AluOpBus]       aluop_o,
    output reg[`AluSelBus]      alusel_o,
    output reg[`RegBus]         reg1_o,
    output reg[`RegBus]         reg2_o,
    output reg[`RegAddrBus]     wd_o,
    output reg                  wreg_o
);

wire[6:0] opcode =  inst_i[6:0];
wire[4:0] rd =      inst_i[11:7];
wire[3:0] funct3 =  inst_i[14:12];
wire[4:0] rs1 =     inst_i[19:15];
wire[4:0] rs2 =     inst_i[24:20];
wire[6:0] funct7 =  inst_i[31:25];
wire[11:0] I_imm =  inst_i[31:20];
wire[11:0] S_imm =  {inst_i[31:25], inst_i[11:7]};
wire[11:0] SB_imm = {inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8]};
wire[19:0] U_imm =  inst_i[31:12];
wire[19:0] UJ_imm = {inst_i[31], inst_i[19:12],inst_i[30:21],inst_i[20]};
reg[31:0] imm;
//reg[31:0] imm2;
reg instvalid;

//----------------------------decodeing----------------------------------------
always @ ( * ) begin
    if(rst == `RstEnable) begin
        aluop_o <=      `EX_NOP_OP;
        alusel_o <=     `EX_RES_NOP;
        wd_o <=         `NOPRegAddr;
        wreg_o <=       `WriteDisable;
        instvalid <=    `Instvalid;
        reg1_read_o <=  1'b0;
        reg2_read_o <=  1'b0;
        reg1_addr_o <=  `NOPRegAddr;
        reg2_addr_o <=  `NOPRegAddr;
        imm <=          `ZeroWord;
    end else begin
        aluop_o <=      `EX_NOP_OP;
        alusel_o <=     `EX_RES_NOP;
        wd_o <=         `NOPRegAddr;
        wreg_o <=       `WriteDisable;
        instvalid <=    `InstInvalid;
        reg1_read_o <=  1'b0;
        reg2_read_o <=  1'b0;
        reg1_addr_o <=  rs1;
        reg2_addr_o <=  rs2;
        reg2_addr_o <=  `NOPRegAddr;
        imm <=          `ZeroWord;
        case (opcode)
            `OpLUI: begin
                aluop_o <=      `EX_OR_OP;
                alusel_o <=     `EX_RES_LOGIC;
                wd_o <=         rd;
                wreg_o <=       `WriteEnable;
                instvalid <=    `Instvalid;
                reg1_read_o <=  1'b0;
                reg2_read_o <=  1'b0;
                reg1_addr_o <=  rs1;
                reg2_addr_o <=  rs2;
                imm <=          U_imm;
            end
            `OpOP: begin
                case(funct3)
                    `Funct3AND: begin
                        aluop_o <=      `EX_AND_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b1;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          `ZeroWord;
                    end
                    `Funct3OR: begin
                        aluop_o <=      `EX_OR_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b1;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          `ZeroWord;
                    end
                    `Funct3XOR: begin
                        aluop_o <=      `EX_XOR_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b1;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          `ZeroWord;
                    end
                    `Funct3SLL: begin
                        aluop_o <=      `EX_SLL_OP;
                        alusel_o <=     `EX_RES_SHIFT;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b1;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          `ZeroWord;
                    end
                    `Funct3SRL: begin
                        case(funct7)
                            `Funct7SRL: begin
                                aluop_o <=      `EX_SRL_OP;
                                alusel_o <=     `EX_RES_SHIFT;
                                wd_o <=         rd;
                                wreg_o <=       `WriteEnable;
                                instvalid <=    `Instvalid;
                                reg1_read_o <=  1'b1;
                                reg2_read_o <=  1'b1;
                                reg1_addr_o <=  rs1;
                                reg2_addr_o <=  rs2;
                                imm <=          `ZeroWord;
                            end
                            `Funct7SRA: begin
                                aluop_o <=      `EX_SRA_OP;
                                alusel_o <=     `EX_RES_SHIFT;
                                wd_o <=         rd;
                                wreg_o <=       `WriteEnable;
                                instvalid <=    `Instvalid;
                                reg1_read_o <=  1'b1;
                                reg2_read_o <=  1'b1;
                                reg1_addr_o <=  rs1;
                                reg2_addr_o <=  rs2;
                                imm <=          `ZeroWord;
                            end
                            default: begin
                            end
                        endcase
                    end
                    default: begin
                    end
                endcase
            end
            `OpOPI: begin
                case(funct3)
                    `Funct3SRLI: begin
                        case(funct7)
                            `Funct7SRLI: begin
                                aluop_o <=      `EX_SRL_OP;
                                alusel_o <=     `EX_RES_SHIFT;
                                wd_o <=         rd;
                                wreg_o <=       `WriteEnable;
                                instvalid <=    `Instvalid;
                                reg1_read_o <=  1'b1;
                                reg2_read_o <=  1'b0;
                                reg1_addr_o <=  rs1;
                                reg2_addr_o <=  rs2;
                                imm <=          {27'h0, rs2};
                            end
                            `Funct7SRAI: begin
                                aluop_o <=      `EX_SRA_OP;
                                alusel_o <=     `EX_RES_SHIFT;
                                wd_o <=         rd;
                                wreg_o <=       `WriteEnable;
                                instvalid <=    `Instvalid;
                                reg1_read_o <=  1'b1;
                                reg2_read_o <=  1'b0;
                                reg1_addr_o <=  rs1;
                                reg2_addr_o <=  rs2;
                                imm <=          {27'h0, rs2};
                            end
                            default: begin
                            end
                        endcase
                    end
                    `Funct3SLLI: begin
                        aluop_o <=      `EX_SLL_OP;
                        alusel_o <=     `EX_RES_SHIFT;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b0;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          {27'h0, rs2};
                    end
                    `Funct3ORI: begin
                        aluop_o <=      `EX_OR_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b0;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          {20'h0, I_imm};
                    end
                    `Funct3XORI: begin
                        aluop_o <=      `EX_XOR_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b0;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          {20'h0, I_imm};
                    end
                    `Funct3ANDI: begin
                        aluop_o <=      `EX_AND_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b0;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          {20'h0, I_imm};
                    end
                    `Funct3ADDI: begin
                        aluop_o <=      `EX_AND_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b0;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          {{20{I_imm[11]}}, I_imm[11:0]};
                    end
                    `Funct3SLTI: begin
                        aluop_o <=      `EX_AND_OP;
                        alusel_o <=     `EX_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b0;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          {{20{I_imm[11]}}, I_imm[11:0]};
                    end
                    default: begin
                    end
                endcase
            end
            default: begin
            end
        endcase
    end
end

always @ ( * ) begin
    if(rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
    end else if ((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
        reg1_o <= ex_wdata_i;
    end else if ((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
        reg1_o <= mem_wdata_i;
    end else if (reg1_read_o == 1'b1)  begin
        reg1_o <= reg1_data_i;
    end else if (reg1_read_o == 1'b0) begin
        reg1_o <= imm;
    end else begin
        reg1_o <= `ZeroWord;
    end
end

always @ ( * ) begin
    if(rst == `RstEnable) begin
        reg2_o <= `ZeroWord;
    end else if ((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
        reg2_o <= ex_wdata_i;
    end else if ((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
        reg2_o <= mem_wdata_i;
    end else if (reg2_read_o == 1'b1)  begin
        reg2_o <= reg2_data_i;
    end else if (reg2_read_o == 1'b0) begin
        reg2_o <= imm;
    end else begin
        reg2_o <= `ZeroWord;
    end
end

endmodule // id
