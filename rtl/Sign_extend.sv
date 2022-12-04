module Sign_extend (
    input logic [2:0]   ImmSrc,
    input logic [31:0]  instr,
    output logic [31:0] ImmOp
);

    logic dummy_wire;

always_comb

    casez(ImmSrc)
    default: assign dummy_wire = 0; 
    3'b000: if (instr[31])                                      // I type   12 bits immediate is from the instruction bit [31:20]
                assign ImmOp = ({20'hFFFFF, instr[31:20]});
            else
                assign ImmOp = ({20'b0, instr[31:20]});

    3'b001: if (instr[31])                                      // S type 
                assign ImmOp = ({20'hFFFFF, instr[31:25], instr[11:7]});
            else
                assign ImmOp = ({20'b0, instr[31:25], instr[11:7]});

    3'b010: if (instr[31])                                      // B type
                assign ImmOp = ({20'hFFFFF, instr[31], instr[7], instr[30:25], instr[11:8]});
            else
                assign ImmOp = ({20'b0,  instr[31], instr[7], instr[30:25], instr[11:8]});
    
    3'b011: if (instr[31])                                      // J type
                assign ImmOp = ({20'hFFFFF, instr[31], instr[19:12], instr[20], instr[30:21]});
            else
                assign ImmOp = ({20'b0, instr[31], instr[19:12], instr[20], instr[30:21]});

    3'b100: assign ImmOp = ({instr[31:12], 12'b0});            // U type

    endcase
    
endmodule
