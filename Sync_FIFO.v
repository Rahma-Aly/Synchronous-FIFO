module Sync_FIFO #(parameter ADDR_WIDTH = 9, DATA_WIDTH = 32)(
	input wire                   clk,
	input wire                   rst_n,
	input wire                   Write_EN,
	input wire                   Read_EN,
	input wire [DATA_WIDTH-1:0]  DataIn,
	output wire [DATA_WIDTH-1:0] DataOut,
	output wire                  Full,
	output wire                  Empty
);
	
	

	
	wire [ADDR_WIDTH:0] write_addr,read_addr;
	
	RAM #(
	    .ADDR_WIDTH(ADDR_WIDTH),
	    .DATA_WIDTH(DATA_WIDTH)
	) RAM_instance(
	    .clk(clk),
	    .rst_n(rst_n),
	    .Write_EN(Write_EN & !Full),
	    .Read_EN(Read_EN & !Empty),
	    .read_addr(read_addr[ADDR_WIDTH-1:0]),
	    .write_addr(write_addr[ADDR_WIDTH-1:0]),
	    .DataIn(DataIn),
	    .DataOut(DataOut)
	);
	
	
	Counter #(
	    .ADDR_WIDTH(ADDR_WIDTH)
	) WAddr_Counter(
	    .En(Write_EN & !Full),
	    .rst_n(rst_n),
	    .clk(clk),
	    .count_out(write_addr)
	);
	
	Counter #(
	    .ADDR_WIDTH(ADDR_WIDTH)
	) RAddr_Counter(
	    .En(Read_EN & !Empty),
	    .rst_n(rst_n),
	    .clk(clk),
	    .count_out(read_addr)
	);
	
	Flag_Control #(
	    .ADDR_WIDTH(ADDR_WIDTH)
	) Flag_Control_instance(
	    .rst_n(rst_n),
	    .clk(clk),
	    .ReadAddr(read_addr),
	    .WriteAddr(write_addr),
	    .Full(Full),
	    .Empty(Empty)
	);
endmodule : Sync_FIFO
