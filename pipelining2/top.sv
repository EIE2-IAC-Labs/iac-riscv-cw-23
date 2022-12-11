module top #(
        parameter ADDRESS_WIDTH = 16,
                  DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,
    input logic TRIGGERSEL,
    output logic [DATA_WIDTH-1:0] a0
);

//green 
logic [DATA_WIDTH-1:0] instr;
//blue
logic [ADDRESS_WIDTH-1:0] rs1;
logic [ADDRESS_WIDTH-1:0] rs2;
logic [ADDRESS_WIDTH-1:0] rd;
//purple
logic RegWrite;
logic [2:0] ALUctrl;
logic ALUsrc;
logic [2:0] ImmSrc;
logic PCsrc;
logic MemWrite;
logic JUMPRT;
logic MUXJUMP;
logic Zero;
logic ResultSrc;
logic BranchMUX;
logic Branch;
logic Jump;
//yellow
logic [DATA_WIDTH-1:0] ALUop1;
logic [DATA_WIDTH-1:0] ALUop2;
logic [DATA_WIDTH-1:0] regOp2;
logic [DATA_WIDTH-1:0] ALUout;
//orange
logic [DATA_WIDTH-1:0] ImmOp;
logic [DATA_WIDTH-1:0] PC;
logic [DATA_WIDTH-1:0] MUXJUMPOutput;
//dataMemory
logic [DATA_WIDTH-1:0] ReadData;
logic [DATA_WIDTH-1:0] TriggerOutput;
logic [DATA_WIDTH-1:0] Result;

//pipelining signals
//D-Stage
logic [DATA_WIDTH-1:0] InstrD;
logic [DATA_WIDTH-1:0] PCD;
logic [DATA_WIDTH-1:0] PCPlus4D;
logic addr_modeD;
//E-Stage
logic RegWriteE; //control outputs
logic ResultSrcE;
logic MemWriteE;
logic JumpE;
logic BranchE;
logic BranchMUXE;
logic [2:0] ALUControlE;
logic ALUSrcE;
logic MUXJUMPE;
logic JUMPRTE;
logic addr_modeE;
logic [DATA_WIDTH-1:0] RD1E; //other outputs
logic [DATA_WIDTH-1:0] RD2E;
logic [DATA_WIDTH-1:0] PCE;
logic [DATA_WIDTH-1:0] RdE;
logic [DATA_WIDTH-1:0] ImmExtE;
logic [DATA_WIDTH-1:0] PCPlus4E;
//M-Stage
logic RegWriteM; //control outputs
logic ResultSrcM;
logic MemWriteM;
logic MUXJUMPM;
logic JUMPRTM;
logic JumpM;
logic addr_modeM;
logic [DATA_WIDTH-1:0] ALUResultM; //other outputs
logic [DATA_WIDTH-1:0] WriteDataM;
logic [DATA_WIDTH-1:0] RdM;
logic [DATA_WIDTH-1:0] PCTargetM;
logic [DATA_WIDTH-1:0] PCPlus4M;
//W-Stage
logic RegWriteW; //control outputs
logic ResultSrcW;
logic MUXJUMPW;
logic JUMPRTW;
logic JumpW;
logic [DATA_WIDTH-1:0] RdW; //other outputs
logic [DATA_WIDTH-1:0] PCPlus4W;
logic [DATA_WIDTH-1:0] ReadDataW;
logic [DATA_WIDTH-1:0] ALUResultW;
logic [DATA_WIDTH-1:0] PCTargetW;
logic [DATA_WIDTH-1:0] PCE2;

assign rs1 = {{11'b0}, InstrD[19:15]};
assign rs2 = {{11'b0}, InstrD[24:20]};
assign rd = {{11'b0}, InstrD[11:7]};

logic [DATA_WIDTH-1:0]  inc_PC;
logic [DATA_WIDTH-1:0]  branch_PC;
logic [DATA_WIDTH-1:0]  PCNext;
logic [DATA_WIDTH-1:0] ReturnMultiplexerOutput;
assign inc_PC = PC+4;
assign branch_PC = PCE2 + ImmExtE;

assign PCE2 = JUMPRTE ? RD1E : PCE;
//assign ReturnMultiplexerOutput = JUMPRTW ? Result : PCTargetW;  //jump multiplexer
assign PCNext = PCsrc ? branch_PC : inc_PC;

ProgramCounter ProgramCounter (
    .clk (clk),
    .rst (rst),
    .PCNext (PCNext),
    .PC(PC)
);

Instr_Mem instr_mem_instance (
    .A (PC),
    .RD (instr)
);

Control_Unit control_unit_instance(
    .instr (InstrD),
    .RegWrite (RegWrite),
    .ALUctrl (ALUctrl),
    .ALUsrc (ALUsrc),
    .ImmSrc (ImmSrc),
    .Branch(Branch),
    .Jump(Jump),
    .ResultSrc (ResultSrc),
    .MemWrite(MemWrite),
    .JUMPRT(JUMPRT),
    .MUXJUMP(MUXJUMP),
    .BranchMUX(BranchMUX),
    .addr_mode(addr_modeD)
);

Sign_extend sign_extend_instance(
    .ImmSrc (ImmSrc),
    .instr (InstrD),
    .ImmExt (ImmOp)
);

assign MUXJUMPOutput = MUXJUMPW ? PCPlus4W : Result;

RegFile reg_file_instance(
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (RdW),
    .WE3 (RegWriteW),
    .WD3 (MUXJUMPOutput),
    .RD1 (ALUop1),
    .RD2 (regOp2),
    .a0 (a0)
);

assign ALUop2 = ALUSrcE ? ImmExtE : RD2E;

ALU alu_instance(
    .ALUctrl (ALUControlE),
    .ALUop1 (RD1E),
    .ALUop2 (ALUop2),
    .ALUResult (ALUout),
    .Zero (Zero)
);

DataMemory data_memory_instance(
    .clk (clk),
    .WE (MemWriteM),
    .A (ALUResultM),
    .WD (WriteDataM),
    .RD (ReadData),
    .addr_modeM(addr_modeM)
);

assign Result = ResultSrcW ?  ReadDataW: ALUResultW; //Mux for data memory

flipflop1 Oneflipflop_instance(
    .clk(clk),
    .RD(instr),
    .PC(PC),
    .inc_PC(inc_PC),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

flipflop2 Twoflipflop_instance(
    .clk(clk),
    //input control signals
    .RegWriteD(RegWrite),
    .MemWriteD(MemWrite),
    .JumpD(Jump),
    .BranchD(Branch),
    .ALUControlD(ALUctrl),
    .ALUSrcD(ALUsrc),
    .MUXJUMPD(MUXJUMP),
    .BranchMUXD(BranchMUX),
    .ResultSrcD(ResultSrc),
    .JUMPRTD(JUMPRT),
    //other inputs
    .RD1(ALUop1),
    .RD2(regOp2),
    .PCD(PCD),
    .RdD(rd),
    .ImmExtD(ImmOp),
    .PCPlus4D(PCPlus4D),
    .addr_modeD(addr_modeD),
    //output control signals
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .JumpE(JumpE),
    .BranchE(BranchE),
    .ALUControlE(ALUControlE),
    .ALUSrcE(ALUSrcE),
    .MUXJUMPE(MUXJUMPE),
    .JUMPRTE(JUMPRTE),
    .BranchMUXE(BranchMUXE),
    //other outputs
    .RD1E(RD1E),
    .RD2E(RD2E),
    .PCE(PCE),
    .RdE(RdE),
    .ImmExtE(ImmExtE),
    .PCPlus4E(PCPlus4E),
    .addr_modeE(addr_modeE)
);

flipflop3 Threeflipflop_instance(
    .clk(clk),
    //other inputs
    .ALUOut(ALUout),
    .regOp2(RD2E),
    .RdE(RdE),
    .PCTargetE(branch_PC),
    .PCPlus4E(PCPlus4E),
    //input control signals
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .MUXJUMPE(MUXJUMPE),
    .JUMPRTE(JUMPRTE),
    .JumpE(JumpE),
    .addr_modeE(addr_modeE),
    //output control signals
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM),
    .MUXJUMPM(MUXJUMPM),
    .JUMPRTM(JUMPTRM),
    .JumpM(JumpM),
    //other outputs
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .PCTargetM(PCTargetM),
    .PCPlus4M(PCPlus4M),
    .addr_modeM(addr_modeM)
);

flipflop4 Fourflipflop_instance(
    .clk(clk),
    //other inputs
    .ALUResultM(ALUResultM),
    .ReadData(ReadData),
    .RdM(RdM),
    .PCTargetM(PCTargetM),
    .PCPlus4M(PCPlus4M),
    //control inputs
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MUXJUMPM(MUXJUMPM),
    .JUMPRTM(JUMPRTM),
    .JumpM(JumpM),
    //control outputs
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),
    .MUXJUMPW(MUXJUMPW),
    .JUMPRTW(JUMPRTW),
    .JumpW(JumpW),
    //other outputs
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
    .PCTargetW(PCTargetW),
    .PCPlus4W(PCPlus4W)
);

assign PCsrc = BranchMUXE ? ((Zero && BranchE) || JumpE) : ((!Zero && BranchE) || JumpE);

endmodule
