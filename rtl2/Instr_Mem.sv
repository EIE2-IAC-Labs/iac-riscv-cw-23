module Instr_Mem # (
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 8,
                OUT_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0] A,
    output logic [OUT_WIDTH-1:0] RD
);

logic [11:0] addr = A[11:0] ;

logic [DATA_WIDTH-1:0] array [2**12-1:0];

initial begin
        $display ("Loading Instr_Mem.");
        $readmemh("counter.mem", array); 
end;

assign RD = {array [addr+3], array [addr+2], array [addr+1], array[addr+0]};

endmodule
