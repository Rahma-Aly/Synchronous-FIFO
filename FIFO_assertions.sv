module FIFO_assertions #(parameter ADDR_WIDTH = 5, DATA_WIDTH = 16)(
	input wire                  clk,
	input wire                  rst_n,
	input wire                  Empty,
	input wire                  Full,
	input wire                  Write_EN,
	input wire                  Read_EN,
	input wire [ADDR_WIDTH:0]   write_addr,
	input wire [ADDR_WIDTH:0]   read_addr
	
);
	 /*-----------------------------Assertions---------------------------------------*/
	 //check the o/p values after a reset  
    property check_init_values;
       @(posedge clk)
        ~rst_n |-> (Empty and !Full and (read_addr == 'b0) and (write_addr == 'b0) );  
    endproperty
    
    VarInit_Values: assert property (check_init_values) $display("VAR_INIT_VALUES: passed"); 
                      else $error("Intitial state is not correct");
    
    //check that the full flag is not asserted whenever write address is less than depth of fifo
    property   check_full_flag;
        @(posedge clk)
        disable iff(~rst_n)
         (write_addr < (2**ADDR_WIDTH)) |-> !(Full);
    endproperty
    
    notFull_flag: assert property (check_full_flag) $display("notFull_flag: passed"); 
                    else $error("Full is asserted before all entries are written");
       
    //check that the full flag is asserted when write addr = depth of fifo
    property is_full;
        @(posedge clk) disable iff(~rst_n)
        (write_addr == (2**ADDR_WIDTH)-1) |=> (Full);
    endproperty
    
    Check_Full : assert property(is_full) $display("CHECK_FULL: passed"); 
                  else $error("full flag not asserted when fifo is full ");
     //check that full remains asserted even if write en = 1 and that the write address is not incremented       
    property write_after_full;
        @(posedge clk) disable iff (~rst_n)
        (Full & Write_EN & !Read_EN) |=> Full 
        and ($past(write_addr)== write_addr);
    endproperty
    
    Check_Write_After_Full : assert property(write_after_full) $display("Check_Full_After_Write: passed"); 
                             else $error("full flag is deasserted after writing in a full fifo and write address was incremented ");
    
    //check if empty flag is asserted
    property check_empty_flag;
        @(posedge clk) disable iff(~rst_n)
         /*(write_addr == 'b0) or*/ (read_addr == write_addr) |->  Empty;
    endproperty
    
    Empty_check: assert property (check_empty_flag) $display("Empty check: passed"); 
                  else $error("empty flag is not asserted correctly");
    //check that empty remains asserted after reading an empty fifo, read address remains the same
    property read_after_empty;
        @(posedge clk) disable iff(~rst_n)
        (Empty & !Write_EN & Read_EN) |=> Empty and ($past(read_addr)== read_addr);
    endproperty
    
    check_read_after_empty: assert property (read_after_empty) $display("check_read_after_empty: passed");
                            else $error("empty flag is deasserted after reading in an empty fifo and read address was incremented ");
    
      
endmodule : FIFO_assertions
