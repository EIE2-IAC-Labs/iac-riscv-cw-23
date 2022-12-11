module DataMemory #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 8
)(
    input logic             clk,
    input logic             WE,
    input logic             addr_mode,
    input logic [ADDRESS_WIDTH-1:0] A,
    input logic [DATA_WIDTH-1:0] WD,
    output logic [DATA_WIDTH-1:0] RD
);

logic [DATA_WIDTH-1:0] dataMemory_array [2**17-1:0];

always_ff @ *
    begin
        RD = dataMemory_array[A];
    end

always_ff @(posedge clk)
    begin
        if(WE == 1'b1)
            dataMemory_array[A] <= WD;
    end

endmodule
