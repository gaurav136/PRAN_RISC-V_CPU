`timescale 1 ns/1 ns

module tb;

// registers to send data
reg clk;
reg reset;
reg Ext_MemWrite;
reg [31:0] Ext_WriteData, Ext_DataAdr;

// Wire Ouputs from Instantiated Modules
wire [31:0] WriteData, DataAdr, ReadData;
wire MemWrite;

// Initialize Top Module
pran_riscv_cpu uut (clk, reset, Ext_MemWrite, Ext_WriteData, Ext_DataAdr, MemWrite, WriteData, DataAdr, ReadData);

integer i = 0, data_1 = 0, data_2 = 0, data_3, cpu_data = 0;
reg flag = 0;

// generate clock to sequence tests
always begin
    clk <= 1; # 5; clk <= 0; # 5;
end

// check results of simple RISC-V CPU (from book)
// performing standard instructions
// initial begin
//     reset = 1;
//     Ext_MemWrite = 0; Ext_DataAdr = 32'b0; Ext_WriteData = 32'b0; #10;
//     reset = 0;
// end

// always @(negedge clk) begin
//     # 10;
//     if(MemWrite && !reset) begin
//         if(DataAdr === 100 & WriteData === 25) begin
//             $display("Simulation succeeded");
//             $stop;
//         end
//         else if (DataAdr !== 96) begin
//             $display("Simulation failed");
//             $stop;
//         end
//     end
// end

// For Sum of Natural Number
initial begin
    reset = 1;

    // set N variable as ten in the memory address 02000000
    Ext_MemWrite = 1; Ext_WriteData = 20; Ext_DataAdr = 32'h02000000;
    data_2 = Ext_WriteData; #10;
    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h02000000; #10;

    // Write Sum as 0 in the memory address 02000004
    Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000004;
    data_1 = Ext_WriteData; #10;
    // compute cpu_data
    for (i = 1; i <= data_2; i = i + 1'b1) begin
        cpu_data = cpu_data + i;
    end
    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h02000004; #10;

    // Write CPU_Done as 0 in the memory address 02000008
    Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000008; #10;
    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #10;

    Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #10;

    reset = 0;
    // External Memory Access Disabled
    Ext_MemWrite = 0; Ext_WriteData = 0; Ext_DataAdr = 0;
end

always @(negedge clk) begin
    if(MemWrite && !reset) begin
        if (DataAdr === 32'h02000004 & WriteData === cpu_data) flag = 1;
        if(flag === 1 & DataAdr === 32'h02000008 & WriteData === 1) begin
            $display("Simulation succeeded");
            $stop;
        end
    end
end

// For Arithmetic Progression
// initial begin
//     reset <= 1;

//     // Write A in the memory address 02000000
//     Ext_MemWrite = 1; Ext_WriteData = 05; Ext_DataAdr = 32'h02000000;
//     data_1 = Ext_WriteData; #10;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #10;

//     // Write D in the memory address 02000004
//     Ext_MemWrite = 1; Ext_WriteData = 06; Ext_DataAdr = 32'h02000004;
//     data_2 = Ext_WriteData; #10;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #10;

//     // Write N in the memory address 02000008
//     Ext_MemWrite = 1; Ext_WriteData = 15; Ext_DataAdr = 32'h02000008;
//     data_3 = Ext_WriteData; #10;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #10;

//     // Write CPU_DATA as 0 in the memory address 0200000c
//     Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h0200000c;
//     cpu_data = Ext_WriteData; #10;
//     // compute a_n
//     for (i = 0; i < data_3; i = i + 1'b1) begin
//         cpu_data = data_1 + i * data_2;
//     end
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #10;

//     Ext_MemWrite = 1; Ext_WriteData = 00; Ext_DataAdr = 32'h02000010;
//     data_2 = Ext_WriteData; #10;
//     Ext_MemWrite = 0; Ext_WriteData = 00; Ext_DataAdr = 32'h0; #10;

//     reset = 0;
//     // External Memory Access Disabled
//     Ext_MemWrite = 0; Ext_WriteData = 0; Ext_DataAdr = 0;
// end

// always @(negedge clk) begin
//    if(MemWrite && !reset) begin
//        if (DataAdr === 32'h0200000c & WriteData === cpu_data) flag = 1;
//        if(flag === 1 & DataAdr === 32'h02000010 & WriteData === 1) begin
//            $display("Simulation succeeded");
//            $stop;
//        end
//    end
// end

endmodule
