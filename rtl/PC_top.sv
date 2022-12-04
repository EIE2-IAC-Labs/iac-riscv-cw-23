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
logic [WIDTH-1:0]  next_PC;
assign inc_PC = PC+4;
assign branch_PC = PC + ImmOp;

assign next_PC = PCsrc ? branch_PC : inc_PC;

  ProgramCounter ProgramCounter (
    .clk (clk),
    .rst (rst),
    .next_PC (next_PC),
    .PC(PC)
  );

endmodule
