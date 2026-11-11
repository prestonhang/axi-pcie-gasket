module axi_fsm_read (
    input logic clk,
    input logic rst_n,
    pcie_if.TX tlp
);

typedef enum logic [1:0] {
    IDLE,       // Awaiting action
    TX_MRD,     // Transmit Memory Read
    WAIT_CPLD,  // Wait for Completion w/ Data
    DRIVE_DATA  // Drive Data back to AXI Manager
} READ_STATE;

READ_STATE current_state, next_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end

always_comb begin
    next_state = current_state;

    // TODO
    case (current_state)
        IDLE:
            next_state = TX_MRD;
        TX_MRD:
            next_state = WAIT_CPLD;
        WAIT_CPLD:
            next_state = DRIVE_DATA;
        DRIVE_DATA:
            next_state = IDLE;
        default:
            next_state = IDLE;
    endcase
end

endmodule