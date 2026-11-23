/********************************
* axi_lite_subordinate.sv
*
* Read/Writes can occur simultaneously

* AXI4-Lite
*   Unable to perform burst transactions
*   No Out-Of-Order
*********************************/
module axi_lite_subordinate(axi_if.axi_slave bus);

    pcie_if pcie (.clk(bus.clk), .rst_n((bus.rst_n)));

    axi_fsm_read read(bus, pcie.TX);
    axi_fsm_write write(bus);

endmodule