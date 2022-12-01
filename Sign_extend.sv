module Sign_extend (
    input logic [1:0]   ImmSrc,
    input logic [31:0]  instr,
    output logic [31:0] ImmOp
);

always_comb

    casez(ImmSrc)
    2'b00:  if (instr[31])                                      // I type   12 bits immediate is from the instruction bit [31:20]
                assign ImmOp = ({20'hFFFFF, instr[31:20]});
            else
                assign ImmOp = ({20'b0, instr[31:20]});

    2'b01:  if (instr[31])                                      // S type 
                assign ImmOp = ({20'hFFFFF, instr[31:25], instr[11:7]});
            else
                assign ImmOp = ({20'b0, instr[31:25], instr[11:7]});

    2'b10:  if (instr[31])                                      // B type
                assign ImmOp = ({20'hFFFFF, instr[31], instr[7], instr[30:25], instr[11:8]});
            else
                assign ImmOp = ({20'b0,  instr[31], instr[7], instr[30:25], instr[11:8]});
    
    2'b11:  if (instr[31])                                      // J type
                assign ImmOp = ({20'hFFFFF, instr[31], instr[19:12], instr[20], instr[30:21]});
            else
                assign ImmOp = ({20'b0, instr[31], instr[19:12], instr[20], instr[30:21]});

    endcase
    
endmodule
