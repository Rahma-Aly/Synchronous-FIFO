`timescale 1ns/1ns
`include "FIFO_assertions.sv"
module Sync_FIFO_tb#(parameter ADDR_WIDTH = 5, DATA_WIDTH = 16)();
	
	
    reg                         Write_EN, clk, rst_n, Read_EN;
    reg     [DATA_WIDTH-1:0]    DataIn;
    wire    [DATA_WIDTH-1:0]    DataOut;
    wire                        Empty,Full;
    integer i;

     localparam CLK_PERIOD = 100;
    /*------------------------ clock configuration-------------------------------*/
    initial begin
       clk = 1'b1;
        forever  #(CLK_PERIOD/2) clk = !clk;       // 1 usec
    end
    /*---------------------------clocking block-------------------------------------*/
    default clocking ck_FIFO @(posedge clk);
        default input #(40) output #(10);
        output negedge rst_n;
        output  Write_EN, Read_EN,DataIn;
        input   DataOut,Full,Empty;
    endclocking
    /*----------------------Module instantiation ----------------------------------*/ 
    Sync_FIFO #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) Sync_FIFO_instance(
        .clk(clk),
        .rst_n(rst_n),
        .Write_EN(Write_EN),
        .Read_EN(Read_EN),
        .DataIn(DataIn),
        .DataOut(DataOut),
        .Full(Full),
        .Empty(Empty)
    );
    
    /*-----------------------binding assertions-------------------------------------*/
    bind Sync_FIFO_instance FIFO_assertions #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) FIFO_assertions_instance(
        .clk(clk),
        .rst_n(rst_n),
        .Empty(Empty),
        .Full(Full),
        .Write_EN(Write_EN),
        .Read_EN(Read_EN),
        .write_addr(Sync_FIFO_instance.write_addr),
        .read_addr(Sync_FIFO_instance.read_addr)
    );

    /*--------------------------------Stimulus------------------------------------------*/        
    initial begin
        rst_n = 1'b1;
        Read_EN = 1'b0;
        Write_EN = 1'b0;
        DataIn = 'd0;
        
        ck_FIFO.rst_n <= 'b0;
        #(CLK_PERIOD/2);
        ck_FIFO.rst_n <= 'b1;
        
        //----------------Fill the fifo to raise the full flag-------//
        ck_FIFO.Write_EN <= 1'b1;
        for (i=0 ; i<(2**ADDR_WIDTH);i=i+1 ) 
        begin
            ##1 ck_FIFO.DataIn <= 'b00000001+i; //wait 1 clk cycle then drive the data
        end
        
        ##2  ck_FIFO.Write_EN <= 1'b0;
        //-------------read all the fifo to raise check the empty----------//
        ck_FIFO.Read_EN <= 1'b1;
        ## ((2**ADDR_WIDTH)+1)  ck_FIFO.Read_EN <= 1'b0; //+1 to try reading empty fifo
        
        //write 1 data then read it
        ck_FIFO.Write_EN <= 1'b1;
        ck_FIFO.DataIn <= 'b10;
        ##1  ck_FIFO.Write_EN <= 1'b0;
        ck_FIFO.Read_EN <= 1'b1;
        ## 1  ck_FIFO.Read_EN <= 1'b0; 
        
    end
    
    
endmodule : Sync_FIFO_tb
