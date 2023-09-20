module Counter#(parameter ADDR_WIDTH = 9)(
    input                       En,
    input                       rst_n,
    input                       clk,
    output reg [ADDR_WIDTH:0]   count_out
);



always @(negedge rst_n or posedge clk) begin
    if (~rst_n) begin
        count_out <= 0;
    end
    else if (En) begin
         count_out <= count_out + 1; 
    end
    else begin
            count_out <= count_out;
    end
end






    
endmodule : Counter
