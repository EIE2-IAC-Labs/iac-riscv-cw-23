module Sign_extend (
    input logic [2:0]   ImmSrc,
    input logic [31:0]  instr,
    output logic [31:0] ImmExt
);

    logic dummy_wire;

always_comb

    casez(ImmSrc)
    default: assign dummy_wire = 0; 
    3'b000: if (instr[31])                                      // I type   12 bits immediate is from the instruction bit [31:20]
                assign ImmExt = ({20'hFFFFF, instr[31:20]});
            else
                assign ImmExt = ({20'b0, instr[31:20]});

    3'b001: if (instr[31])                                      // S type 
                assign ImmExt = ({20'hFFFFF, instr[31:25], instr[11:7]});
            else
                assign ImmExt = ({20'b0, instr[31:25], instr[11:7]});

    3'b010: if (instr[31])                                      // B type
                assign ImmExt = ({{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0});
            else
                assign ImmExt = ({{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0});
    
    3'b011: if (instr[31])                                      // J type
                assign ImmExt = ({{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0});
            else
                assign ImmExt = ({{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0});

    3'b100: assign ImmExt = ({instr[31:12], 12'b0});            // U type

    endcase
    
endmodule
