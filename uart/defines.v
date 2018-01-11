//全局
`define RstEnable 1'b1
`define RstDisable 1'b0
`define ZeroWord 32'h00000000
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0

`define OpBus 6:0
`define SubOpBus 2:0

`define InstValid 1'b0
`define InstInvalid 1'b1
`define Stop 1'b1
`define NoStop 1'b0
`define InDelaySlot 1'b1
`define NotInDelaySlot 1'b0
`define Branch 1'b1
`define NotBranch 1'b0
`define InterruptAssert 1'b1
`define InterruptNotAssert 1'b0
`define TrapAssert 1'b1
`define TrapNotAssert 1'b0
`define True_v 1'b1
`define False_v 1'b0
`define ChipEnable 1'b1
`define ChipDisable 1'b0

`define DataAddrBus 31:0
`define DataBus 31:0
`define DataMemNum 131071
`define DataMemNumLog2 17
`define ByteWidth 7:0

//指令
`define EXE_LUI     7'b0110111
`define EXE_AUIPC   7'b0010111
`define EXE_JAL     7'b1101111
`define EXE_JALR    7'b1100111
`define EXE_BEQ     7'b1100011
`define EXE_LB      7'b0000011
`define EXE_SB      7'b0100011
`define EXE_ADDI    7'b0010011
`define EXE_ORI     7'b0010011
`define EXE_ADD     7'b0110011
`define EXE_FENCE   7'b0001111
`define EXE_NOP     7'b0000000

`define OP_DEFAULT     3'b000

//EXE_BEQ
`define OP_BEQ      3'b000
`define OP_BNE      3'b001
`define OP_BLT      3'b100 
`define OP_BGE      3'b101 
`define OP_BLTU     3'b110 
`define OP_BGEU     3'b111
//EXE_LB
`define OP_LB       3'b000
`define OP_LH       3'b001
`define OP_LW       3'b010  
`define OP_LBU      3'b100 
`define OP_LHU      3'b101 
//EXE_SB
`define OP_SB       3'b000
`define OP_SH       3'b001
`define OP_SW       3'b010 
//EXE_ADDI
`define OP_ADDI     3'b000
`define OP_SLTI     3'b010
`define OP_SLTIU    3'b011
`define OP_XORI     3'b100 
`define OP_ORI      3'b110  
`define OP_ANDI     3'b111
`define OP_SLLI     3'b001
`define OP_SRLI     3'b101
`define OP_SRAI     3'b101
//EXE_ADD
`define OP_ADD      3'b000
`define OP_SUB      3'b000
`define OP_SLT      3'b010
`define OP_SLTU     3'b011
`define OP_XOR      3'b100 
`define OP_OR       3'b110  
`define OP_AND      3'b111
`define OP_SLL      3'b001
`define OP_SRL      3'b101
`define OP_SRA      3'b101

`define UP_OP       7'b0000000
`define DOWN_OP     7'b0100000
//指令存储器inst_rom
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 131071
`define InstMemNumLog2 17


//通用寄存器regfile
`define RegAddrBus 4:0
`define RegBus 31:0
`define RegWidth 32
`define DoubleRegWidth 64
`define DoubleRegBus 63:0
`define RegNum 32
`define RegNumLog2 5
`define NOPRegAddr 5'b00000


`define INST_WIDTH  31:0
`define ADDR_WIDTH  31:0
`define DATA_WIDTH  31:0
`define REG_WIDTH    4:0
`define ALU_OP_WIDTH 4:0
`define BYTE_WIDTH   7:0

`define DataMemNum 131071
`define InstMemNum 131071
`define DataMemNumLog2 17
`define InstMemNumLog2 17

`define ZeroWord 32'h00000000
`define ZeroReg  5'b00000

`define SET_WIDTH       1:0
`define SET_NUM           2
`define TAG_WIDTH      21:0
`define INDEX_WIDTH     5:0
`define SELECT_WIDTH    3:0
`define DATA_ROW_WIDTH 63:0
`define DATA_ROWS        64
`define DATA_COL_WIDTH  3:0
`define DATA_COLS         4
`define BENCH_WIDTH   127:0
