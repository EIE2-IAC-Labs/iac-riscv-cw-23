module ALU #(
    parameter DATA_WIDTH = 32
              //CONTROL_SIGNAL = 1
) (
    input logic ALUctrl,
    input logic [DATA_WIDTH-1:0] ALUop1,
    input logic [DATA_WIDTH-1:0] ALUop2,
    output logic [DATA_WIDTH-1:0] SUM,
    output logic EQ //whether ALUop1 and ALUop2 are equal or not
    //can be either 0 or 1
);


//if (ALUctrl)
    //assign SUM = ALUop1 + ALUop2;
//else
    //if (ALUop1 - ALUop2 == {DATA_WIDTH{1'b0}})
        //assign EQ = 1'b1;
    //else
        //assign EQ = 1'b0;

    always_comb 
        casez(ALUctrl)
        1'b1: assign SUM = ALUop1 + ALUop2;
        1'b0: if (ALUop1 - ALUop2 == {DATA_WIDTH{1'b0}}) assign EQ = 1'b1; 
              else assign EQ = 1'b0;
        default: EQ = 1'b0;
        endcase
endmodule

