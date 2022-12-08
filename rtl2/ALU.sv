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

    always_comb 
        begin
        casez(ALUctrl)
        3'b000: assign ALUResult = ALUop1 + ALUop2;
        3'b001: assign ALUResult = ALUop1 - ALUop2;
        3'b110: assign ALUResult = ALUop2; //load upper immediate
        default: Zero = 1'b0;
        endcase

        casez(ALUResult)
        32'b0:  assign Zero = 1'b1; 
        default: Zero = 1'b0;
        endcase
        end

endmodule

