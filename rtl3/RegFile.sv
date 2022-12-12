module RegFile #(
    parameter ADDRESS_WIDTH = 16,
             //a0_WIDTH = 5,
              DATA_WIDTH = 32
              
) (
    input logic clk,
    input logic [ADDRESS_WIDTH-1:0] AD1,
    input logic [ADDRESS_WIDTH-1:0] AD2,
    input logic [ADDRESS_WIDTH-1:0] AD3,
    input logic WE3, //write enable
    input logic [DATA_WIDTH-1:0] WD3,
    output logic [DATA_WIDTH-1:0] RD1,
    output logic [DATA_WIDTH-1:0] RD2,
    output logic [DATA_WIDTH-1:0] a0
);

logic [DATA_WIDTH-1:0] regfile_array [2**ADDRESS_WIDTH-1:0];

//read ports should be asynchronous
always_ff @ *
    begin
        RD1 = regfile_array[AD1];
        RD2 = regfile_array[AD2];
    end

always_ff @(posedge clk)
    begin
        if(WE3 == 1'b1)
            regfile_array[AD3] <= WD3;
    end

    //synchronous
    assign a0 = regfile_array[{16'b01010}];

always_ff @ * begin    

    $display ("%h", regfile_array[{16'b01100}]);
    
end


endmodule
