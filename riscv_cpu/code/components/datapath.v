
// data

module datapath (input clk,
                 input reset,
                 input [31:0] Instr,
                 input [31:0] ReadData,
                 input [1:0] ResultSrc,
                 input PCSrc,
                 input Jalr,
                 input ALUSrc,
                 input RegWrite,
                 input Op5,
                 input [1:0] ImmSrc,
                 input [1:0] Store,
                 input [2:0] Load,
                 input [3:0] ALUControl,
                 output Zero,
                 output ALUR31,
                 output [31:0] PC,
                 output [31:0] Mem_WrAddr,
                 output [31:0] Mem_WrData,
                 output [31:0] Result);
    
    
    
    wire [31:0] PCNext, PCPlus4, PCTarget, PCNextJalr;
    wire [31:0] AuLuiPC, Auipc;
    wire [31:0] ImmExt, SrcA, SrcB, WriteData, ALUResult; // Result
    wire [31:0] Load_Extend_Data,Store_Extend_Data;
    wire [1:0]  Add_offset;
    
    // next PC logic
    reset_ff #(32)      pcreg(clk, reset, PCNextJalr, PC);
    adder  #(32)             pcadd4(PC, 32'd4, PCPlus4);
    adder #(32)         pcaddbranch(PC, ImmExt, PCTarget);
    mux2 #(32)          pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
    mux2 #(32)	        pcmuxJalr(PCNext, ALUResult,Jalr,PCNextJalr);
    
    // register file logic
    reg_file            rf (clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, SrcA, WriteData);
    sign_extend         immext (Instr[31:7], ImmSrc, ImmExt);
    
    // ALU logic
    mux2 #(32)          srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    alu                 alu (SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux4 #(32) 	        resultmux(ALUResult, Load_Extend_Data, PCPlus4,AuLuiPC,ResultSrc, Result);
    
    //store ,Load
    //store_extend        extstore(WriteData, Store, Store_Extend_Data);
    sgn_zero_extend     extload(ReadData, Load,Add_offset, Load_Extend_Data);
    
    //auipc,lui
    mux2 #(32)		    auluipc(Auipc,{Instr[31:12],12'b0}, Op5, AuLuiPC);
    adder			    auipcadd({Instr[31:12],12'b0}, PC, Auipc);
    
    
    
    assign Mem_WrData = WriteData;   //Store_Extend_Data;
    assign Mem_WrAddr = ALUResult;
    assign ALUR31     = ALUResult[31];
    assign Add_offset[1:0] = ALUResult[1:0]; 
    
endmodule
