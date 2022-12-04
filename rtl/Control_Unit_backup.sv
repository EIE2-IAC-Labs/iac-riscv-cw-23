module Control_Unit (
    input logic         EQ,
    input logic  [31:0]       instr,
    output logic        RegWrite,
    output logic        ALUctrl,
    output logic        ALUsrc,
    output logic        ImmSrc,
    output logic        PCsrc
);

logic [6:0]         op;
logic [2:0]         funct3;
logic [1:0]         ALUOp;
logic               Branch;

assign op = instr[6:0];
assign funct3 = instr[14:12];

always_latch @(instr) 
    if (op == 7'b0010011) begin //addi
        RegWrite = 1;
        //ALUctrl = 0;
        ALUsrc = 1;
        ImmSrc = 1;
        ALUOp = 2'b10;
        Branch = 0;

end else if (op == 7'b1100011) begin  //bne
        RegWrite = 0;
        //ALUctrl = 1;
        ALUsrc = 0;
        ImmSrc = 0;
        ALUOp = 2'b01;
        Branch = 1;
end

//always_latch @(instr) 
    if (Branch && EQ == 0)
        assign PCsrc = 1;
    else
        assign PCsrc = 0;

//always_latch @(instr) 
    if (ALUOp == 00)
        assign ALUctrl = 1;    // load & store ALUctrl = 1 not used in lab 4
    
    else if (ALUOp == 01)
        assign ALUctrl = 0;    // jump ALUctrl = 0

    else
        if (funct3 == 000)
            assign ALUctrl = 1;    // addi ALUctrl = 1

endmodule
