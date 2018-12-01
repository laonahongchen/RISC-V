`ifndef DEFINES
`define DEFINES

//--------------------General ---------------------------
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'b00000000000000000000000000000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define AluOpBus 5:0
`define AluSelBus 2:0
`define Instvalid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define IndelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNoptAssert 1'b0
`define ChipsEnable 1'b1
`define ChipsDisable 1'b0

//-------------------- Opcode -----------------------------------
`define OpOPI 7'b0010011



//----------------------funct3--------------------------------------
`define Funct3ADDI  3'b000
`define Funct3SLTI  3'b010
`define Funct3SLTIU 3'b011
`define Funct3XORI  3'b100
`define Funct3ORI   3'b110
`define Funct3ANDI  3'b111

//----------------------Alu ------------------------------------
`define EX_NOP_OP 5'h0
`define EX_ADD_OP 5'h1
`define EX_SUB_OP 5'h2
`define EX_SLT_OP 5'h3
`define EX_SLTU_OP 5'h4
`define EX_XOR_OP 5'h5
`define EX_OR_OP 5'h6
`define EX_AND_OP 5'h7
`define EX_SLL_OP 5'h8
`define EX_SRL_OP 5'h9
`define EX_SRA_OP 5'ha
`define EX_AUIPC_OP 5'hb

`define EX_JAL_OP 5'hc
`define EX_JALR_OP 5'hd
`define EX_BEQ_OP 5'he
`define EX_BNE_OP 5'hf
`define EX_BLT_OP 5'h10
`define EX_BGE_OP 5'h11
`define EX_BLTU_OP 5'h12
`define EX_BGEU_OP 5'h13

`define EX_LB_OP 5'h14
`define EX_LH_OP 5'h15
`define EX_LW_OP 5'h16
`define EX_LBU_OP 5'h17
`define EX_LHU_OP 5'h18

`define EX_SB_OP 5'h19
`define EX_SH_OP 5'h1a
`define EX_SW_OP 5'h1b

`define ME_NOP_OP 5'h0

//----------------------Alu Sel----------------------------------
`define EX_RES_NOP 3'b000
`define EX_RES_LOGIC 3'b001
`define EX_RES_SHIFT 3'b010
`define EX_RES_ARITH 3'b011
`define EX_RES_J_B 3'b100
`define EX_RES_LD_ST 3'b101
`define EX_RES_NOP 3'b000

//----------------------MemBus-----------------------------------
`define InstAddrBus 31:0
`define InstBus 31:0


//---------------------Reg ---------------------------------------
`define RegNum 32
`define RegNumLog2 5
`define DoubleRegBus 63:0
`define DoubleRegWidth 64
`define RegWidth 32
`define RegAddrBus 4:0
`define RegBus 31:0


`endif
