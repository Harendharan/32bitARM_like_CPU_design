`include "cpu.v"
`include "imem.v"
`include "dmem.v"

module top (
    input clk, 
    input reset
);

    // Internal wires for connecting modules
    wire [31:0] PC, Instr, ReadData;
    wire [31:0] WriteData, DataAdr;
    wire MemWrite;

    // Instantiate the CPU
    cpu c1 (
        .clk(clk), 
        .reset(reset), 
        .PC(PC), 
        .Instr(Instr), 
        .MemWrite(MemWrite), 
        .ALUResult(DataAdr), 
        .WriteData(WriteData), 
        .ReadData(ReadData)
    );

    // Instantiate the Instruction Memory (IMEM)
    imem c2 (
        .a(PC), 
        .rd(Instr)
    );

    // Instantiate the Data Memory (DMEM)
    dmem c3 (
        .clk(clk), 
        .we(MemWrite), 
        .a(DataAdr), 
        .wd(WriteData), 
        .rd(ReadData)
    );

endmodule
