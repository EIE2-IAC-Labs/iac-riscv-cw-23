module 2flipflop (
    input logic         RegWriteD,
    input logic         ResultSrcD,
    input logic         MemWriteD,
    input logic         JumpD,
    input logic         BranchD,
    input logic         ALUContrlD,
    input logic         ALUSrcD,
    input logic         RD1,
    input logic         RD2,
    input logic         PCD,
    input logic         RdD,
    input logic         ImmExtD,
    input logic         PCPlus4D,
    input logic         MUXJUMPD,
    input logic         JUMPRTD,
    input logic         BranchMUXD,
    output logic         RegWriteE,
    output logic         ResultSrcE,
    output logic         MemWriteE,
    output logic         JumpE,
    output logic         BranchE,
    output logic         ALUContrlE,
    output logic         ALUSrcE,
    output logic         RD1E,
    output logic         RD2E,
    output logic         PCE,
    output logic         RdE,
    output logic         ImmExtE,
    output logic         PCPlus4E,
    output logic         MUXJUMPE,
    output logic         JUMPRTE,
    output logic         BranchMUXE     
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

