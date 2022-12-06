module MUX(input logic [31:0] branch_PC, inc_PC,
           input logic     PCsrc,
           output logic  [31:0] PCNext);
  
    assign PCNext = PCsrc ? branch_PC : inc_PC;
endmodule
