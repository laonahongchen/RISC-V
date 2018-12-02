module id (
    input wire rst,
    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        inst_i,

    input wire[`RegBus]         reg1_data_i,
    input wire[`RegBus]         reg2_data_i,

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
wire[19:0] U_imm =  inst_i[31:12];
reg[31:0] imm;
//reg[31:0] imm2;
reg instvalid;

//----------------------------decodeing----------------------------------------
always @ ( * ) begin
    if(rst == `RstEnable) begin
        aluop_o <=      `EXE_NOP_OP;
        alusel_o <=     `EXE_RES_NOP;
        wd_o <=         `NOPRegAddr;
        wreg_o <=       `WriteDisable;
        instvalid <=    `Instvalid;
        reg1_read_o <=  1'b0;
        reg2_read_o <=  1'b0;
        reg1_addr_o <=  `NOPRegAddr;
        reg2_addr_o <=  `NOPRegAddr;
        imm <=          32'h0;
    end else begin
        case (opcode)
            `OpOPI: begin
                case(funct3)
                    `Funct3ORI: begin
                        aluop_o <=      `EXE_OR_OP;
                        alusel_o <=     `EXE_RES_LOGIC;
                        wd_o <=         rd;
                        wreg_o <=       `WriteEnable;
                        instvalid <=    `Instvalid;
                        reg1_read_o <=  1'b1;
                        reg2_read_o <=  1'b0;
                        reg1_addr_o <=  rs1;
                        reg2_addr_o <=  rs2;
                        imm <=          {20'h0, I_imm};
                    end
                    default: begin
                    end
                endcase
            default: begin
            end
        endcase
    end
end

always @ ( * ) begin
    if(rst == `RstEnable) begin
        reg1_o <= `ZeroWord;
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
    end else if (reg2_read_o == 1'b1)  begin
        reg2_o <= reg2_data_i;
    end else if (reg2_read_o == 1'b0) begin
        reg2_o <= imm;
    end else begin
        reg2_o <= `ZeroWord;
    end
end

endmodule // id
