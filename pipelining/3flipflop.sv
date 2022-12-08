module 3flipflop(
    input logic         clk,
    //remaining inputs
    input logic         ALUOut,
    input logic         regOp2, //writeDataE in diagram
    input logic         RdE,
    input logic         PCTargetE,
    input logic         PCPlus4E,
    //control signal inputs
    input logic         RegWriteE,
    input logic         ResultSrcE,
    input logic         MemWriteE,
    input logic         MUXJUMPE,
    input logic         JUMPRTE,
    //control signal outputs
    output logic        RegWriteM,
    output logic        ResultSrcM,
    output logic        MemWriteM,
    output logic        MUXJUMPM,
    output logic        JUMPRTM,
    //remaining outputs
    output logic        ALUResultM,
    output logic        WriteDataM,
    output logic        RdM,
    output logic        PCTargetM,
    output logic        PCPlus4M
);

always_ff @(posedge clk)
    begin
        RegWriteM <= RegWriteE;
        ResultSrcM <= ResultSrcE;
        MemWriteM <= MemWriteE;
        ALUResultM <= ALUOut;
        WriteDataM <= regOp2;
        RdM <= RdE;
        PCTargetM <= PCTargetE;
        PCPlus4M <= PCPlus4E;
    end
endmodule