import gasket_pkg::*;

interface axi_if(input logic clk, input logic rst_n);

// read address channel
	addr_t ARADDR;
	logic [4-1:0] ARCACHE;
	logic [3-1:0] ARPROT;
	logic ARVALID;
	logic ARREADY;

// read data channel
	data_t RDATA;
	logic RRESP;
	logic RVALID;
	logic RREADY;

// write address channel
	addr_t AWADDR;
	logic [4-1:0] AWCACHE;
	logic [3-1:0] AWPROT;
	logic AWVALID;
	logic AWREADY;

// write data channel
	data_t WDATA;
	logic [4-1:0] WSTRB;

// write response channel
	logic BRESP;
	logic BVALID;
	logic BREADY;

	modport master(	output ARADDR, ARCACHE, ARPROT, ARVALID, 
					input ARREADY,
					input RDATA, RRESP, RVALID,
					output RREADY,
					output AWADDR, AWCACHE, AWPROT, AWVALID,
					input AWREADY,
					output WDATA, WSTRB,
					input BRESP, BVALID,
					output BREADY
					);

	modport slave(	input clk, rst_n,
					input ARADDR, ARCACHE, ARPROT, ARVALID, 
					output ARREADY,
					output RDATA, RRESP, RVALID,
					input RREADY,
					input AWADDR, AWCACHE, AWPROT, AWVALID,
					output AWREADY,
					input WDATA, WSTRB,
					output BRESP, BVALID,
					input BREADY
					);

endinterface
