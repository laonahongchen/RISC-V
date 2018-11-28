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
`define AluOpBus 7:0
`define AluSelBus 3:0
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
`define OpOpImm 7'b0010011



//----------------------funct3--------------------------------------
`define Funct3ADDI 3'b000
`define Funct3SLTI 3'b010
`define Funct3SLTIU 3'b011
`define Funct3XORI 3'b100
`define Funct3ORI 3'b110
`define Funct3ANDI 3'b111

//----------------------MemBus-----------------------------------
`define InstAddrBus 32:0

`endif
