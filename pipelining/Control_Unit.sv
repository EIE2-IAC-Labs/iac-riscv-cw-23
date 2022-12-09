module Control_Unit (
    //input logic         Zero,
    input logic  [31:0] instr,
    output logic        RegWrite,
    output logic        ResultSrc,
    output logic        MemWrite,
    output logic        Jump,    
    output logic        Branch,
    output logic [2:0]  ALUctrl,
    output logic        ALUsrc,
    output logic [2:0]  ImmSrc,
    //output logic        PCsrc,      
    output logic        MUXJUMP,                // MUXJUMP = 0 so that register write in result. MUXJUMP = 1 so that register write in PC+4
    output logic        JUMPRT,
    output logic        BranchMUX               // newMUX for pipeline Branch
     
);

logic [6:0]         op;
logic [2:0]         funct3;
logic [6:0]         funct7;
logic [1:0]         ALUOp;
logic [1:0]         opfunct7;



assign op = instr[6:0];
assign funct3 = instr[14:12];
assign funct7 = instr[31:25];
assign opfunct7 = {op[5],funct7[5]};

always_comb begin
    casez(op)

    default: begin                          //default value
            assign MUXJUMP = 0;
            assign JUMPRT = 0;
            //assign PCsrc = 0;
            assign RegWrite = 0;
            assign ImmSrc = 3'b000;
            assign ALUsrc = 0;
            assign MemWrite = 0;
            assign ResultSrc = 0;
            assign ALUctrl = 3'b000; 
            assign Jump = 0;
            assign Branch = 0;
            assign BranchMUX = 0;
    end

    7'b0010011: begin                      // Immediate ALU operation
        assign RegWrite = 1;
        assign ImmSrc = 3'b000;
        assign ALUsrc = 1;
        assign MemWrite = 0;
        assign ResultSrc = 0;
        assign Branch = 0;
        assign Jump = 0;
        assign ALUOp = 2'b10;
        assign MUXJUMP = 0;
        //assign PCsrc = 0;
        assign JUMPRT = 0;        
    end

    7'b0000011: begin                     //  Load
        assign RegWrite = 1;
        assign ImmSrc = 3'b000;
        assign ALUsrc = 1;
        assign MemWrite = 0;
        assign ResultSrc = 1;
        assign Branch = 0;
        assign Jump = 0;
        assign ALUOp = 2'b00;
        assign MUXJUMP = 0;
        //assign PCsrc = 0;
        assign JUMPRT = 0;
    end

    7'b0100011: begin                     // store
        assign RegWrite = 0;
        assign ImmSrc = 3'b001;
        assign ALUsrc = 1;
        assign MemWrite = 1;
        assign ResultSrc = 0;
        assign Branch = 0;
        assign Jump = 0;
        assign ALUOp = 2'b00;
        assign MUXJUMP = 0;
        //assign PCsrc = 0;
        assign JUMPRT = 0;
    end

    7'b0110011: begin                     // R type
        assign RegWrite = 1;
        assign ImmSrc = 3'b000;
        assign ALUsrc = 0;
        assign MemWrite = 0;
        assign ResultSrc = 0;
        assign Branch = 0;
        assign Jump = 0;
        assign ALUOp = 2'b10;
        assign MUXJUMP = 0;
        //assign PCsrc = 0;
        assign JUMPRT = 0;
    end

    7'b1100011: begin                      // Branch
        assign RegWrite = 0;
        assign ImmSrc = 3'b010;
        assign ALUsrc = 0;
        assign MemWrite = 0;
        assign ResultSrc = 0;
        assign Branch = 1;
        assign Jump = 0;
        assign ALUOp = 2'b01;
        assign MUXJUMP = 0;
        assign JUMPRT = 0;
        
        casez(funct3)
            default: assign BranchMUX = 0;
            3'b000: assign BranchMUX = 1;      // BranchMUX = 1 for beq
            3'b001: assign BranchMUX = 0;      // BranchMUX = 0 for bne
        endcase
    

    end

    7'b1100111: begin                      // jump and link register
        assign RegWrite = 1;
        assign ImmSrc = 3'b000;
        assign ALUsrc = 1;
        assign MemWrite = 0;
        assign ResultSrc = 0;
        assign Branch = 0;
        assign Jump = 1;
        assign ALUOp = 2'b00;
        assign MUXJUMP = 1;
        //assign PCsrc = 1;
        assign JUMPRT = 1;
    end

    7'b1101111: begin                      // jump and link
        assign RegWrite = 1;
        assign ImmSrc = 3'b011;
        assign ALUsrc = 0;
        assign MemWrite = 0;
        assign ResultSrc = 0;
        assign Branch = 0;
        assign Jump = 1;
        assign ALUOp = 2'b00;
        assign MUXJUMP = 1;
        //assign PCsrc = 1;
        assign JUMPRT = 0;
    end

    7'b0110111: begin                      // load upper immediate
        assign RegWrite = 1;
        assign ImmSrc = 3'b100;
        assign ALUsrc = 1;
        assign MemWrite = 0;
        assign ResultSrc = 0;
        assign Branch = 0;
        assign Jump = 0;
        assign ALUOp = 2'b11;
        assign MUXJUMP = 0;
        //assign PCsrc = 0;
        assign JUMPRT = 0;
    end
    endcase


    casez(ALUOp)
    2'b00: assign ALUctrl = 000;
    2'b01: assign ALUctrl = 001;
    2'b10: casez(funct3)
           3'b000: if (op == 7'b0110011 && opfunct7 == 2'b11)   assign ALUctrl = 3'b001;          //subtract
                   else  assign ALUctrl = 3'b000;                      // add
           3'b010: assign ALUctrl = 3'b101;                            // set less than
           3'b110: assign ALUctrl = 3'b011;                            // or
           3'b111: assign ALUctrl = 3'b010;                            // and
           3'b001: assign ALUctrl = 3'b100;                            // shift left
           endcase
    2'b11: assign ALUctrl = 3'b110;                                       // ALUResult = SrcB
    endcase
end

endmodule
