module DataMemory #(
    parameter ADDRESS_WIDTH = 32,
    DATA_WIDTH = 32,
    STORE_WIDTH = 8
) (
    input  logic                     clk,
    input  logic                     WE,
    input  logic                     addr_mode,
    input  logic [ADDRESS_WIDTH-1:0] A,
    input  logic [   DATA_WIDTH-1:0] WD,
    output logic [   DATA_WIDTH-1:0] RD
);

  logic [STORE_WIDTH-1:0] dataMemory_array[2**17-1:0];

  initial begin
    $display("Loading DataMemory.");
    $readmemh("triangle.mem", dataMemory_array, 17'h10000, 17'h1FFFF);
  end


  always_ff @ * //load
    begin
    if (addr_mode)  //for byte addressing
      RD = {24'b0, dataMemory_array[A]};
    else  //for word addressing 
      RD = {
        dataMemory_array[A+3], dataMemory_array[A+2], dataMemory_array[A+1], dataMemory_array[A]
      };
  end

  always_ff @(posedge clk) //store
    begin
    if (addr_mode == 1'b1 && WE == 1'b1) begin
      //for byte addressing
      dataMemory_array[A] <= WD[7:0];
    end else if (addr_mode == 1'b0 && WE == 1'b1) begin
      dataMemory_array[A]   <= WD[7:0];
      dataMemory_array[A+1] <= WD[15:8];
      dataMemory_array[A+2] <= WD[23:16];
      dataMemory_array[A+3] <= WD[31:24];
    end
  end

/*
  logic a;

  always_ff @(posedge clk) begin
    if (dataMemory_array[{17'h10001}] == 0) begin
      a <= 1;

    end
    if (a == 1) $finish;

    //$display ("%h", dataMemory_array[{17'h10001}]);

  end
*/

endmodule
