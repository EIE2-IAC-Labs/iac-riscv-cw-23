module 1flipflop (
    input logic         clk,
    input logic         RD,
    input logic         PC,
    input logic         inc_PC,
    output logic        InstrD
    output logic        PCD,
    output logic        PCPlus4D
);

always_ff @(posedge clk)
    begin
        InstrD <= RD;
        PCD <= PC;
        inc_PC <= PCPlus4D;
    end
endmodule