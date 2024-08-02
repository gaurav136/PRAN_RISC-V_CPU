//RISC-V CPU
/*
Instructions
-------------------.
This file is the top-level verilog design for RISC-V CPU Implementation

Recommended Quartus Version : 20.1

-------------------
*/

// top_riscv_cpu module declaration
module t1c_riscv_cpu (
    input clk, reset,
    input Ext_MemWrite,
    input [31:0] Ext_WriteData, Ext_DataAdr,
    output MemWrite,
    output [31:0] WriteData, DataAdr, ReadData,
    output [31:0] PC,
    output [31:0] Result
);

// wire lines from other modules
wire [31:0] Instr;
wire [31:0] DataAdr_rv32, WriteData_rv32;
wire [1:0] Store, Store_rv32;
wire MemWrite_rv32;

// instantiate processor and memories
riscv_cpu rvsingle (clk, reset, PC, Instr, MemWrite_rv32, DataAdr_rv32, WriteData_rv32, Store_rv32, ReadData, Result);
instr_mem imem (PC, Instr);
data_mem dmem (clk, MemWrite, DataAdr, WriteData, Store, ReadData);

// output assignments
assign Store    = (Ext_MemWrite && reset) ? 2'b10 : Store_rv32;
assign MemWrite = (Ext_MemWrite && reset) ? 1 : MemWrite_rv32;
assign WriteData = (Ext_MemWrite && reset) ? Ext_WriteData : WriteData_rv32;
assign DataAdr = (reset) ? Ext_DataAdr : DataAdr_rv32;
endmodule
