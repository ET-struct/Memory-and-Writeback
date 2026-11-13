`timescale 1ns / 1ps
module wb_mux(
    output wire [31:0] y,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire sel
);
   
    assign y = sel ? a : b;
    
endmodule
