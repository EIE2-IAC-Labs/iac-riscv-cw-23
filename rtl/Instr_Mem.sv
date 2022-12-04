module Instr_Mem # (
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 8,
                OUT_WIDTH = 32
)(
    input logic [ADDRESS_WIDTH-1:0] A,
    output logic [OUT_WIDTH-1:0] RD
);

logic [DATA_WIDTH-1:0] array [2**16-1:0];

initial begin
        $display ("Loading Instr_Mem.");
        $readmemh("counter.mem", array); 
end;

assign RD = {array [A+3], array [A+2], array [A+1], array[A+0]};

endmodule
