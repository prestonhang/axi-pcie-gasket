import gasket_pkg::*

module gasket_tb (axi_if.master bus);
	parameter CLK_PERIOD = 10; // 10ns period clk
	
	logic clk = 0;
    logic rst_n = 1;


// clock instantiation
	always #(CLK_PERIOD/2) clk = ~clk;

// interface instantiation
	pcie_if pcie_bus (clk, rst_n);
	axi_if axi_bus();

// DUT instantiation
	top  (clk, rst_n);


// reset sequence, consumes 3 clock cycles (3*CLK_PERIOD)
	task automatic rst_sequence();
		#CLK_PERIOD rst_n = 0; // rst_n is initialized to '1', so drive it to '0' after 1 CLK_PERIOD
		#CLK_PERIOD rst_n = 1; // always return rst_n to '1' for future reset sequences
		#CLK_PERIOD; // extra clock cycle for buffer
	endtask: rst_sequence

//
	task automatic axi_write();
	
	endtask: axi_write

/*
this task drives the read address on the axi bus to the slave, as well as driving read address valid, and read ready
valid and ready are 1 by default - can leave the last two fields blank when calling this task
*/
	task automatic axi_read_req(input addr_t read_addr, input bit valid = 1, input bit ready = 1);
		bus.ARADDR <= read_addr; 
		bus.ARVALID <= valid;
		bus.RREADY <= ready;
	endtask: axi_read

/* TASK DESCRIPTION

*/
	task automatic axi_read_ack();
		do(@(posedge clk)) while (bus.ARREADY ~= 1'b1);
		bus.ARADDR <= '0; 
		bus.ARVALID <= '0;
	endtask: axi_read_ack

/* TASK DESCRIPTION

*/
	task automatic axi_read_data(output data_t read_data);
		do(@(posedge clk)) while (bus.RVALID ~= 1'b1);
		read_data <= bus.RDATA
	endtask: axi_read_data

/* TASK DESCRIPTION

*/
	task automatic axi_write_req();

	endtask axi_write_req

/* TASK DESCRIPTION

*/
	task automatic axi_write_ack();

	endtask: axi_write_ack

/* TASK DESCRIPTION

*/
	task automatic axi_write_data();

	endtask: axi_write_data


// testbench stimulus	
	initial begin
		rst_sequence(); // consumes 3 clock cycles

	end
	
// variable dump
	initial begin

	end



endmodule: gasket_tb
