/*
References:
https://raw.githubusercontent.com/osdev-jp/spec/refs/heads/main/PCI_Express_Base_4.0_Rev0.3_February19-2014.pdf
https://support.microchip.com/s/article/Transaction-Layer-Packets
xillybus.com/tutorials/pci-express-tlp-pcie-primer-tutorial-guide-1

*/

import gasket_pkg::*;

interface pcie_if(
    input logic clk,
    input logic rst_n
);

// 3 sets for the data  [3]
// 1 set for the header [1]
logic [3:0] [DWORD_WIDTH - 1: 0] tx_data; 
logic tx_ready; 
logic tx_valid; 
logic tx_last; 

logic [3:0] [DWORD_WIDTH - 1: 0] rx_data;
logic rx_ready;
logic rx_valid;
logic rx_last;


modport RX (
    input  clk,
    input  rst_n,
    input  rx_data,
    output rx_ready,
    input  rx_valid,
    input  rx_last
);

modport TX (
    input  clk,
    input  rst_n,
    output tx_data,
    input  tx_ready,
    output tx_valid,
    output tx_last
);


endinterface