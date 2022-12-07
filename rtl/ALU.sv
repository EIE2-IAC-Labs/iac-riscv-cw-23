module ALU #(
    parameter DATA_WIDTH = 32
              //CONTROL_SIGNAL = 1
) (
    input logic [2:0] ALUctrl,
    input logic [DATA_WIDTH-1:0] ALUop1,
    input logic [DATA_WIDTH-1:0] ALUop2,
    output logic [DATA_WIDTH-1:0] ALUResult,
    output logic Zero //whether ALUop1 and ALUop2 are equal or not
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
        3'b000: assign ALUResult = ALUop1 + ALUop2;
        3'b001: assign ALUResult = ALUop1 - ALUop2;
         if (ALUResult == {DATA_WIDTH{1'b0}}) assign Zero = 1'b1; 
              else assign Zero = 1'b0;
        default: Zero = 1'b0;
        3'b110: assign ALUResult = ALUop2;
        endcase
endmodule

