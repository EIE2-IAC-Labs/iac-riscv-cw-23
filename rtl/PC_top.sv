module PC_top #(
    parameter WIDTH = 32
)(
    input logic clk,
    input logic rst,
    input logic PCsrc,
    input logic [WIDTH-1:0] ImmOp,
    output logic [WIDTH-1:0] PC
);

logic [WIDTH-1:0]  inc_PC;
logic [WIDTH-1:0]  branch_PC;
logic [WIDTH-1:0]  PCNext;
assign inc_PC = PC+4;
assign branch_PC = PC + ImmOp;

assign PCNext = PCsrc ? branch_PC : inc_PC;

  ProgramCounter ProgramCounter (
    .clk (clk),
    .rst (rst),
    .PCNext (PCNext),
    .PC(PC)
  );

endmodule
