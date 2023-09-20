module RAM #(parameter ADDR_WIDTH = 9, DATA_WIDTH = 32)(
    input                       clk,
    input                       rst_n,
    input                       Write_EN,
    input                       Read_EN,
    input      [ADDR_WIDTH-1:0] read_addr,
    input      [ADDR_WIDTH-1:0] write_addr,
    input      [DATA_WIDTH-1:0] DataIn, 
    output reg [DATA_WIDTH-1:0] DataOut

);

   reg [DATA_WIDTH-1:0] dataReg [(2**ADDR_WIDTH)-1:0]; 
   integer i;
   
   always @(posedge clk or negedge rst_n) begin : write_block
       if (~rst_n) begin
           for (i = 0; i < (2**ADDR_WIDTH); i = i +1) begin
               dataReg[i] <= 0;
           end
       end
       else if (Write_EN) begin
               dataReg[write_addr]<= DataIn;
           end
   end
   
    always @(posedge clk or negedge rst_n) begin : Read_block
       if (~rst_n) begin
           DataOut  <= 'b0;
       end
       else if (Read_EN) begin
               DataOut <= dataReg[read_addr];
           end 
   end
   
    
endmodule : RAM
