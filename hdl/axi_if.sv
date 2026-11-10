interface axi_if;

	// read address + control
        logic [DWORD_WIDTH-1:0] rd_addr_ctrl; // CHANGE WIDTH
        // read data channel    
        logic [DWORD_WIDTH-1:0] rd_data_ch;

        // write address + contro
        logic [DWORD_WIDTH-1:0] wr_addr_ctrl; // CHANGE WIDTH
        // write data channel
        logic [DWORD_WIDTH-1:0] wr_data_ch
        // write response channnel
        logic [DWORD_WIDTH-1:0] wr_resp_ch; // CHANGE WIDTH

	modport axi_port (input rd_addr_ctrl, wr_addr_ctrl, wr_data_ch,
				output rd_data_ch, wr_resp_ch);

	modport tb_port (input rd_data_ch, wr_resp_ch,
				output rd_addr_ctrl, wr_addr_ctrl, wr_data_ch);

endinterface
