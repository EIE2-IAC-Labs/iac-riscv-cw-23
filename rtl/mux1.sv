module MUX(input logic [31:0] branch_PC, inc_PC,
           input logic     PCsrc,
           output logic  [31:0] next_PC);
  
    assign next_PC = PCsrc ? branch_PC : inc_PC;
endmodule
