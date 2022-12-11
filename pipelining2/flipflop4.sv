module flipflop4 #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input logic clk,
    //input control signals
    input logic         RegWriteM,
    input logic         ResultSrcM,
    input logic         MUXJUMPM,
    input logic         JUMPRTM,
    input logic         JumpM,
    //other inputs
    input logic  [DATA_WIDTH-1:0]       ALUResultM,
    input logic  [DATA_WIDTH-1:0]       ReadData,
    input logic  [4:0]       RdM,
    input logic  [DATA_WIDTH-1:0]       PCTargetM,
    input logic  [DATA_WIDTH-1:0]       PCPlus4M,
    //output control signals
    output logic        JumpW,
    output logic        RegWriteW,
    output logic        ResultSrcW,
    output logic        MUXJUMPW,
    output logic        JUMPRTW,
    //other outputs
    output logic [DATA_WIDTH-1:0]       ALUResultW,
    output logic [DATA_WIDTH-1:0]       ReadDataW,
    output logic [4:0]       RdW,
    output logic [DATA_WIDTH-1:0]      PCTargetW,
    output logic [DATA_WIDTH-1:0]       PCPlus4W
);

always_ff @(posedge clk)
    begin
    RegWriteW <= RegWriteM;
    ResultSrcW <= ResultSrcM;
    MUXJUMPW <= MUXJUMPM;
    JUMPRTW <= JUMPRTM;
    JumpW <= JumpM;
    ALUResultW <= ALUResultM;
    ReadDataW <= ReadData;
    RdW <= RdM;
    PCTargetW <= PCTargetM;
    PCPlus4W <= PCPlus4M;
    end

endmodule
