module axi_fsm_write (axi_if.slave bus);
    
import gasket_pkg::*;

typedef enum logic [1:0] {
    W_CAPTURE,      // latch both AW and W, since they can arrive separate
    W_SEND_MWR,
    W_DRIVE_BRESP
} WRITE_STATE;

WRITE_STATE current_state, next_state;

logic [DWORD_WIDTH-1:0] awaddr_latched;
logic [DWORD_WIDTH-1:0] wdata_latched;

logic aw;
logic w;

always_ff @(posedge bus.clk or negedge bus.rst_n) begin
    if (!bus.rst_n) begin
        current_state <= W_CAPTURE;
        awaddr_latched <= '0;
        wdata_latched <= '0;
    end
    else begin
        // Process Handshake on Rising Edge
        if (current_state == W_CAPTURE && bus.AWVALID == 1 && bus.AWREADY == 1) begin
            awaddr_latched <= bus.AWADDR;
        end

        if (current_state == W_CAPTURE && bus.WVALID == 1 && bus.WREADY == 1) begin
            wdata_latched <= bus.WDATA;
        end

        current_state <= next_state;

    end
end

assign bus.AWREADY = (current_state == W_CAPTURE);
assign bus.WREADY = (current_state == W_CAPTURE);

always_comb begin
    next_state = current_state;

    // TODO
    case (current_state)
        W_CAPTURE: begin
            next_state = W_SEND_MWR;
        end
        W_SEND_MWR: begin
            next_state = W_DRIVE_BRESP;
        end
        W_DRIVE_BRESP: begin
            next_state = W_CAPTURE;
        end
    endcase
end

endmodule