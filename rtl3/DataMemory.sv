module DataMemory #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32,
              STORE_WIDTH = 8
)(
    input logic             clk,
    input logic             WE,
    input logic             addr_mode,
    input logic [ADDRESS_WIDTH-1:0] A,
    input logic [DATA_WIDTH-1:0] WD,
    output logic [DATA_WIDTH-1:0] RD
);

logic [STORE_WIDTH-1:0] dataMemory_array [2**17-1:0];

always_ff @ * //load
    begin
        if (addr_mode) //for byte addressing
            RD = {24'b0, dataMemory_array[A]};
        else //for word addressing 
            RD = {dataMemory_array[A+3], dataMemory_array[A+2], dataMemory_array[A+1], dataMemory_array[A]}
    end

always_ff @(posedge clk) //store
    begin
        if(WE == 1'b1)
            if (addr_mode) //for byte addressing
                dataMemory_array[A] <= WD[7:0];
            else
                dataMemory_array[A] <= WD[7:0];
                dataMemory_array[A+1] <= WD[15:8];
                dataMemory_array[A+2] <= WD[23:16];
                dataMemory_array[A+3] <= WD[31:24];
    end

endmodule
