// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (input clk,
                  input reset,
                  output [31:0] PC,
                  input [31:0] Instr,
                  output MemWrite,
                  output [31:0] Mem_WrAddr,
                  output [31:0] Mem_WrData,
                  output [1:0] Store,
                  input [31:0] ReadData,
                  output [31:0] Result);
    
    wire        ALUSrc, RegWrite, Zero, ALUR31, PCSrc, Jalr, Jump, Op5;
    wire [1:0]  ResultSrc, ImmSrc;
    wire [2:0]  Load;
    wire [3:0]  ALUControl;
    //wire [31:0] Result;
    
    
    
    controller  c ( Instr[6:0], Instr[14:12], Instr[30], Zero, ALUR31,
                    ResultSrc, MemWrite, PCSrc, Jalr,ALUSrc, RegWrite,Op5,
                    ImmSrc,Store, Load, ALUControl);
    
    datapath    dp (clk, reset, Instr,ReadData, ResultSrc, PCSrc,Jalr,
                    ALUSrc, RegWrite, Op5, ImmSrc, Store,Load , ALUControl,
                    Zero,ALUR31, PC, Mem_WrAddr, Mem_WrData, Result);
    
endmodule


