module PC_top #(
    parameter WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic PCsrc,
    input logic JUMPRT,
    input logic [WIDTH-1:0] ImmOp,
    input logic [WIDTH-1:0] Result,
    output logic [WIDTH-1:0] PC
);

logic [WIDTH-1:0]  inc_PC;
logic [WIDTH-1:0]  branch_PC;
logic [WIDTH-1:0]  PCNext;
logic [WIDTH-1:0] ReturnMultiplexerOutput;
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

endmodule
