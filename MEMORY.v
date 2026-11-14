`timescale 1ns / 1ps

// Memory Stage: This uses the outputs of Execute Stage as well as combining the modules: AND, data_memory, and mem_wb.
module MEMORY(
    input wire clk,
    input wire [31:0] ALUResult,
    input wire [31:0] WriteData,
    input wire [4:0] WriteReg,
    input wire [1:0] WBControl,
    input wire MemWrite,
    input wire MemRead,
    input wire Branch,
    input wire Zero,
    output wire [31:0] ReadData,
    output wire [31:0] ALUResult_out,
    output wire [4:0] WriteReg_out,
    output wire [1:0] WBControl_out,
    output wire PCSrc
);

    wire [31:0] read_data_in;
    wire regwrite_out;
    wire memtoreg_out;

    // Combine the 1-bit control signals into the 2-bit output the testbench expects
    assign WBControl_out = {regwrite_out, memtoreg_out};

    // Branch AND gate
    AND AND_4(
        .membranch(Branch),
        .zero(Zero),
        .PCSrc(PCSrc)
    );

    // Data Memory 
    // (Removed .clk(clk) because data_memory.v does not have a clock port)
    data_memory data_memory4(
        .addr(ALUResult),
        .write_data(WriteData),
        .memwrite(MemWrite),
        .memread(MemRead),
        .read_data(read_data_in)
    );

    // MEM/WB Pipeline Latch
    mem_wb mem_wb4(
        .clk(clk),
        .control_wb_in(WBControl),       // inputs
        .read_data_in(read_data_in),
        .alu_result_in(ALUResult),
        .write_reg_in(WriteReg),
        .regwrite(regwrite_out),         // outputs
        .memtoreg(memtoreg_out),
        .read_data(ReadData),
        .mem_alu_result(ALUResult_out),
        .mem_write_reg(WriteReg_out)
    );

endmodule
