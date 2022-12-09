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
//yellow
logic [DATA_WIDTH-1:0] ALUop1;
logic [DATA_WIDTH-1:0] ALUop2;
logic [DATA_WIDTH-1:0] regOp2;
logic [DATA_WIDTH-1:0] ALUout;
logic EQ;
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
//E-Stage
logic RegWriteE; //control outputs
logic ResultSrcE;
logic MemWriteE;
logic JumpE;
logic BranchE;
logic [2:0] ALUControlE;
logic ALUSrcE;
logic MUXJUMPE;
logic JUMPRTE;
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
logic [DATA_WIDTH-1:0] RdW; //other outputs
logic [DATA_WIDTH-1:0] PCPlus4W;
logic [DATA_WIDTH-1:0] ReadDataW;
logic [DATA_WIDTH-1:0] ALUResultW;

assign rs1 = {{11'b0},instr[19:15]};
assign rs2 = {{11'b0},instr[24:20]};
assign rd = {{11'b0},instr[11:7]};

logic [DATA_WIDTH-1:0]  inc_PC;
logic [DATA_WIDTH-1:0]  branch_PC;
logic [DATA_WIDTH-1:0]  PCNext;
logic [DATA_WIDTH-1:0] ReturnMultiplexerOutput;
assign inc_PC = PC+4;
assign branch_PC = PC + ImmOp;

assign ReturnMultiplexerOutput = JUMPRT ? Result : branch_PC;//jump multiplexer
assign PCNext = PCsrc ? ReturnMultiplexerOutput : inc_PC;

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
    .Zero (Zero),
    .instr (instr),
    .RegWrite (RegWrite),
    .ALUctrl (ALUctrl),
    .ALUsrc (ALUsrc),
    .ImmSrc (ImmSrc),
    .PCsrc (PCsrc),
    .ResultSrc (ResultSrc),
    .MemWrite(MemWrite),
    .JUMPRT(JUMPRT),
    .MUXJUMP(MUXJUMP),
    .BranchMUX(BranchMUX)
);

Sign_extend sign_extend_instance(
    .ImmSrc (ImmSrc),
    .instr (instr),
    .ImmExt (ImmOp)
);

assign MUXJUMPOutput = MUXJUMP ? PC+4 : Result;

RegFile reg_file_instance(
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (RdW),
    .WE3 (RegWrite),
    .WD3 (MUXJUMPOutput),
    .RD1 (ALUop1),
    .RD2 (regOp2),
    .a0 (a0)
);

assign ALUop2 = ALUsrc ? ImmOp : regOp2;

ALU alu_instance(
    .ALUctrl (ALUctrl),
    .ALUop1 (ALUop1),
    .ALUop2 (ALUop2),
    .ALUResult (ALUout),
    .Zero (Zero)
);

DataMemory data_memory_instance(
    .clk (clk),
    .WE (MemWrite),
    .A (ALUout),
    .WD (regOp2),
    .RD (ReadData)
);

assign TriggerOutput = TRIGGERSEL ? ReadData : ALUout; //Trigger Mux
assign Result = ResultSrc ? TriggerOutput : ALUout; //Mux for data memory

Oneflipflop Oneflipflop_instance(
    .clk(clk),
    .RD(instr),
    .PC(PC),
    .inc_PC(inc_PC),
    .InstrD(InstrD),
    .PCD(PCD),
    .PCPlus4D(PCPlus4D)
);

Twoflipflop Twoflipflop_instance(
    .clk(clk),
    //input control signals
    .RegWriteD(RegWrite),
    .MemWriteD(MemWrite),
    .JumpD(Jump),
    .BranchD(Branch),
    .ALUContrlD(ALUctrl),
    .ALUSrcD(ALUsrc),
    .MUXJUMPD(MUXJUMP),
    .BranchMUXD(BranchMUX),
    //other inputs
    .RD1(ALUop1),
    .RD2(regOp2),
    .PCD(PCD),
    .RdD(rd),
    .ImmExtD(ImmOp),
    .PCPlus4D(PCPlus4D),
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
    .PCPlus4E(PCPlus4E)
);

Threeflipflop Threeflipflop_instance(
    .clk(clk),
    //other inputs
    .ALUOut(ALUOut),
    .regOp2(regOp2),
    .RdE(RdE),
    .PCTargetE(branch_PC),
    .PCPlus4E(PCPlus4E),
    //input control signals
    .RegWriteE(RegWriteE),
    .ResultSrcE(ResultSrcE),
    .MemWriteE(MemWriteE),
    .MUXJUMPE(MUXJUMPE),
    .JUMPRTE(JUMPRTE),
    //output control signals
    .RegWriteM(RegWriteM),
    .ResultSrcM(ResultSrcM),
    .MemWriteM(MemWriteM),
    .MUXJUMPM(MUXJUMPM),
    .JUMPRTM(JUMPTRM),
    //other outputs
    .ALUResultM(ALUResultM),
    .WriteDataM(WriteDataM),
    .RdM(RdM),
    .PCTargetM(PCTargetM),
    .PCPlus4M(PCPlus4M)
);

Fourflipflop Fourflipflop_instance(
    .clk(clk),
    //other inputs
    .ALUResultM(ALUResultM),
    .ReadData(ReadData),
    .RdM(RdM),
    .PCTargetM(PCTargetM),
    .PCPlus4M(PCPlus4M),
    //control inputs
    .RegWriteM(),
    .ResultSrcM(),
    .MUXJUMPM(),
    .JUMPRTM(),
    //control outputs
    .RegWriteW(RegWriteW),
    .ResultSrcW(ResultSrcW),
    .MUMJUMPW(MUMJUMPW),
    .JUMPRTW(JUMPRTW),
    //other outputs
    .ALUResultW(ALUResultW),
    .ReadDataW(ReadDataW),
    .RdW(RdW),
    .PCTargetW(PCTargetW),
    .PCPlus4W(PCPlus4W)
);

endmodule
