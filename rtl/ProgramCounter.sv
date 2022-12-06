module ProgramCounter#(
    parameter WIDTH = 32
)(
    input logic      clk,
    input logic      rst,
    input logic [WIDTH-1:0]  PCNext,
    output logic [WIDTH-1:0]  PC
);

always_ff @(posedge clk, posedge rst)
    if(rst) PC <= 32'hBFC00000;
    else    PC <= PCNext;

endmodule
