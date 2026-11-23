/********************************
* axi_fsm_read.sv
* 
* Accept and latch the AXI read address.
* Request an MRd transmission from the PCIe module.
* Wait for confirmation that the MRd was transmitted.
* Wait for a matching PCIe completion.
* Capture the returned data and completion status.
* Return the data/status through AXI R.
* Hold the AXI response stable until RREADY is asserted.
*********************************/
module axi_fsm_read (
    axi_if.slave bus,
    pcie_if.TX pcie
);

import gasket_pkg::*;

typedef enum logic [1:0] {
    IDLE,       // Awaiting action
    TX_MRD,     // Transmit Memory Read
    WAIT_CPLD,  // Wait for Completion w/ Data
    DRIVE_DATA  // Drive Data back to AXI Manager
} READ_STATE;

READ_STATE current_state, next_state;

logic [DWORD_WIDTH-1:0] araddr_latched;

logic [DWORD_WIDTH-1:0] rdata;
logic rresp;

always_ff @(posedge bus.clk or negedge bus.rst_n) begin
    if (!bus.rst_n) begin
        current_state <= IDLE;
        araddr_latched <= '0;
        rdata <= '0;
        rresp <= 0;
    end
    else begin
        // Process handshake on clk cycle
        if (current_state == IDLE && bus.ARVALID && bus.ARREADY) begin
            araddr_latched <= bus.ARADDR;
        end
        else if (current_state == WAIT_CPLD) begin
            // TODO: set to Cpld - where is Cpld coming from?
            rdata <= '0;
            rresp <= '0;
        end

        current_state <= next_state;
    end
end

// Ready high only if we are in IDLE
assign bus.ARREADY = (current_state == IDLE);

// Valid high when we are Transmitting MRD
assign pcie.tx_valid = (current_state == TX_MRD);

always_comb begin
    next_state = current_state;

    case (current_state)
        IDLE: begin
            next_state = (bus.ARVALID) ? TX_MRD : IDLE;
        end
        TX_MRD: begin
            // Transmit Mrd
            // TODO: Setup MRd headers
            pcie.tx_data[3] = '0;
            pcie.tx_data[2] = '0;
            pcie.tx_data[1] = araddr_latched;
            pcie.tx_data[0] = '0;
            pcie.tx_last = 1;

            next_state = (pcie.tx_ready) ? WAIT_CPLD : TX_MRD;
        end
        WAIT_CPLD: begin
            // TODO: Check CPLD Tag, if tags match, go to next state
            //next_state = () ? DRIVE_DATA : WAIT_CPLD;
        end
        DRIVE_DATA: begin
            // Drive AXI Outputs
            bus.RDATA = rdata;
            bus.RRESP = rresp;
            next_state = bus.RREADY ? IDLE : DRIVE_DATA;
        end
        default:
            next_state = IDLE;
    endcase
end

endmodule