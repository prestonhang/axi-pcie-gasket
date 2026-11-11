interface axi_if;

// read address channel
	logic [DWORD_WIDTH-1:0] ARADDR;
	logic [4-1:0] ARCACHE;
	logic [3-1:0] ARPRO;
	logic ARVALID;
	logic ARREADY;

// read data channel
	logic [DWORD_WIDTH-1:0] RDATA;
	logic RRESP;
	logic RVALID;
	logic RREADY;

// write address channel
	logic [DWORD_WIDTH-1:0] AWADDR;
	logic [4-1:0] AWCACHE;
	logic [3-1:0] AWPROT;
	logic AWVALID;
	logic AWREADY;

// write data channel
	logic [DWORD_WIDTH-1:0] WDATA;
	logic [4-1:0] WSTRB;

// write response channel
	logic BRESP;
	logic BVALID;
	logic BREADY;

	modport axi_master(	output ARADDR, ARCACHE, ARPROT, ARVALID, 
						input ARREADY,
						input RDATA, RRESP, RVALID,
						output RREADY,
						output AWADDR, AWCACHE, AWPROT, AWVALID,'
						input AWREADY,
						output WDATA, WSTRB,
						input BRESP, BVALID,
						output BREADY
						);

	modport axi_slave(	input ARADDR, ARCACHE, ARPROT, ARVALID, 
						output ARREADY,
						output RDATA, RRESP, RVALID,
						input RREADY,
						input AWADDR, AWCACHE, AWPROT, AWVALID,'
						output AWREADY,
						input WDATA, WSTRB,
						output BRESP, BVALID,
						input BREADY
						);


endinterface
