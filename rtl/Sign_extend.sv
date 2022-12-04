module Sign_extend (
    input logic         ImmSrc,
    input logic [31:0]  instr,
    output logic [31:0] ImmOp
);

always @ *
if (ImmSrc)
    if (instr[31])                                      // addi   12 bits immediate is from the instruction bit [31:20]
        assign ImmOp = ({20'hFFFFF, instr[31:20]});
    else
        assign ImmOp = ({20'b0, instr[31:20]});

else                                                    // bne   12 bits immediate is from the instruction bit [31,7,30:25,11:8]
    if (instr[31])
        assign ImmOp = ({20'hFFFFF, instr[31], instr[7], instr[30:25], instr[11:8]});
    else
        assign ImmOp = ({20'b0,  instr[31], instr[7], instr[30:25], instr[11:8]});

endmodule
