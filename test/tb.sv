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


// testbench stimulus	
	initial begin
		rst_sequence(); // consumes 3 clock cycles

	end
	
// variable dump
	initial begin

	end



endmodule: gasket_tb
