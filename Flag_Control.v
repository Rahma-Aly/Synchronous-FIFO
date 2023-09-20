module Flag_Control #(parameter ADDR_WIDTH = 9)(
    input                rst_n,
    input                clk, 
    input [ADDR_WIDTH:0] ReadAddr,
    input [ADDR_WIDTH:0] WriteAddr,
    output  reg          Full,
    output  reg          Empty
);




always @(*) begin : Full_Flag_Control 
    if (~rst_n) begin
        Full = 0;
    end
    else if ((WriteAddr [ADDR_WIDTH-1:0] == ReadAddr [ADDR_WIDTH-1:0])&&(WriteAddr [ADDR_WIDTH] != ReadAddr [ADDR_WIDTH])) begin
        Full = 1;
    end
    else begin
        Full = 0; 
    end     
end


always @(*) begin : Empty_Flag_Control 
    if (~rst_n) begin
        Empty = 1;
    end
    else if (ReadAddr == WriteAddr) begin 
        Empty = 1;
    end
    else begin
        Empty = 0; 
    end     
end 




endmodule : Flag_Control
