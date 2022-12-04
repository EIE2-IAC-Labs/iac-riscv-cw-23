module top #(
        parameter ADDRESS_WIDTH = 16,
                  DATA_WIDTH = 32
) (
    input logic clk,
    input logic rst,
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
logic ALUctrl;
logic ALUsrc;
logic ImmSrc;
logic PCsrc;
//yellow
logic [DATA_WIDTH-1:0] ALUop1;
logic [DATA_WIDTH-1:0] ALUop2;
logic [DATA_WIDTH-1:0] regOp2;
logic [DATA_WIDTH-1:0] ALUout;
logic EQ;
//orange
logic [DATA_WIDTH-1:0] ImmOp;
logic [DATA_WIDTH-1:0] PC;

assign rs1 = {{11'b0},instr[19:15]};
assign rs2 = {{11'b0},instr[24:20]};
assign rd = {{11'b0},instr[11:7]};



PC_top pc_top_instance (
    .clk (clk),
    .rst (rst),
    .ImmOp(ImmOp),
    .PCsrc (PCsrc),
    .PC (PC)
);

Instr_Mem instr_mem_instance (
    .A (PC),
    .RD (instr)
);

Control_Unit control_unit_instance(
    .EQ (EQ),
    .instr (instr),
    .RegWrite (RegWrite),
    .ALUctrl (ALUctrl),
    .ALUsrc (ALUsrc),
    .ImmSrc (ImmSrc),
    .PCsrc (PCsrc)
);

Sign_extend sign_extend_instance(
    .ImmSrc (ImmSrc),
    .instr (instr),
    .ImmOp (ImmOp)
);

RegFile reg_file_instance(
    .clk (clk),
    .AD1 (rs1),
    .AD2 (rs2),
    .AD3 (rd),
    .WE3 (RegWrite),
    .WD3 (ALUout),
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
    .EQ (EQ)
);

endmodule
