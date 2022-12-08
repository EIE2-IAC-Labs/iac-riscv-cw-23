module 3flipflop (
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input logic         clk,
    //remaining inputs
    input logic [DATA_WIDTH-1:0]        ALUOut,
    input logic [DATA_WIDTH-1:0]        regOp2, //writeDataE in diagram
    input logic [4:0]        RdE,
    input logic [DATA_WIDTH-1:0]        PCTargetE,
    input logic [DATA_WIDTH-1:0]        PCPlus4E,
    //control signal inputs
    input logic         RegWriteE,
    input logic         ResultSrcE,
    input logic         MemWriteE,
    input logic         MUXJUMPE,
    input logic         JUMPRTE,
    input logic [2:0]        ALUControlD,
    //control signal outputs
    output logic        RegWriteM,
    output logic        ResultSrcM,
    output logic        MemWriteM,
    output logic        MUXJUMPM,
    output logic        JUMPRTM,
    output logic [2:0]      ALUControlE,
    //remaining outputs
    output logic [DATA_WIDTH-1:0]       ALUResultM,
    output logic [DATA_WIDTH-1:0]       WriteDataM,
    output logic [4:0]      RdM,
    output logic [DATA_WIDTH-1:0]      PCTargetM,
    output logic [DATA_WIDTH-1:0]       PCPlus4M
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