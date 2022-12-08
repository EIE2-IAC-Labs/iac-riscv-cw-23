module 2flipflop (
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input logic         clk,
    //input control signals
    input logic         RegWriteD,
    input logic         ResultSrcD,
    input logic         MemWriteD,
    input logic         JumpD,
    input logic         BranchD,
    input logic [2:0]        ALUControlD,
    input logic         ALUSrcD,
    input logic         MUXJUMPD,
    input logic         JUMPRTD,
    input logic         BranchMUXD,
    //other inputs
    input logic [DATA_WIDTH-1:0]        RD1,
    input logic [DATA_WIDTH-1:0]        RD2,
    input logic [DATA_WIDTH-1:0]        PCD,
    input logic [4:0]        RdD,
    input logic [DATA_WIDTH-1:0]        ImmExtD,
    input logic [DATA_WIDTH-1:0]        PCPlus4D,
    //output control signals
    output logic         RegWriteE,
    output logic         ResultSrcE,
    output logic         MemWriteE,
    output logic         JumpE,
    output logic         BranchE,
    output logic         ALUControlE,
    output logic         ALUSrcE,
    output logic         MUXJUMPE,
    output logic         JUMPRTE,
    output logic         BranchMUXE,  
    //other outputs
    output logic [DATA_WIDTH-1:0]        RD1E,
    output logic [DATA_WIDTH-1:0]        RD2E,
    output logic [DATA_WIDTH-1:0]        PCE,
    output logic [4:0]        RdE,
    output logic [DATA_WIDTH-1:0]        ImmExtE,
    output logic [DATA_WIDTH-1:0]        PCPlus4E
);

always_ff @(posedge clk)
    begin
        RegWriteE   <=  RegWriteD;
        ResultSrcE  <=  ResultSrcD;
        MemWriteE   <=  MemWriteD;
        JumpE       <=  JumpD;
        BranchE     <=  BranchD;
        ALUContrlE  <=  ALUContrlD;
        ALUSrcE     <=  ALUSrcD;
        RD1E        <=  RD1;
        RD2E        <=  RD2;
        PCE         <=  PCD;
        RdE         <=  RdD;
        ImmExtE     <=  ImmExtD;
        PCPlus4E    <=  PCPlus4D;
        MUXJUMPE    <=  MUXJUMPD;
        JUMPRTE     <=  JUMPRTD;
        BranchMUXE  <=  BranchMUXD;        
    end


endmodule

