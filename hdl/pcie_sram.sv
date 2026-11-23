/*
PCIe-to-SRAM endpoint (completer)

Receives request TLPs from the gasket, carries them out on the SRAM,
and returns completion TLPs for reads.

OUTLINE -- fill in each section.
*/

import gasket_pkg::*;

module pcie_sram #(
    // ------------------------------------------------------------------
    // 1. Parameters
    // ------------------------------------------------------------------
    // TODO: BAR0 base address
    // TODO: SRAM depth (words) -> 4 KB BAR
    // TODO: Completer ID (bus/dev/func of this endpoint)
) (
    // ------------------------------------------------------------------
    // 2. Ports
    // ------------------------------------------------------------------
    // TODO: PCIe link. Needs a modport from the ENDPOINT's point of view:
    //       requests IN  (gasket's tx_* side)
    //       completions OUT (gasket's rx_* side)
);

    // ------------------------------------------------------------------
    // 3. Local params / constants
    // ------------------------------------------------------------------
    // TODO: address width from depth, BAR size in bytes
    // TODO: completion status codes (SC, UR)

    // ------------------------------------------------------------------
    // 4. Request decode (combinational)
    // ------------------------------------------------------------------
    // TODO: view incoming data as tlp_packet_128b_u
    // TODO: pull out fmt, type, length, byte enables, requester ID, tag,
    //       address, write data
    // TODO: classify: memory write? memory read? posted or non-posted?
    // TODO: is the address inside BAR0? is length supported (1 DW)?
    // TODO: handshake: when is a request accepted?

    // ------------------------------------------------------------------
    // 5. SRAM instance
    // ------------------------------------------------------------------
    // TODO: instantiate sram
    // TODO: en / we / addr / wdata from the decode above
    //       (word address = offset from BAR0, byte bits dropped)

    // ------------------------------------------------------------------
    // 6. Saved request info
    // ------------------------------------------------------------------
    // TODO: registers to hold what the completion needs after the request
    //       is gone (requester ID, tag, lower address, byte count, status)

    // ------------------------------------------------------------------
    // 7. Control FSM
    // ------------------------------------------------------------------
    // TODO: state enum (e.g. idle / wait for SRAM read / send completion)
    // TODO: state register + reset
    // TODO: next-state logic
    //         - write accepted        -> ?
    //         - read accepted         -> ?
    //         - bad non-posted request -> ?
    //         - completion not yet taken (ready low) -> ?
    // TODO: when is the endpoint ready to accept a new request?

    // ------------------------------------------------------------------
    // 8. Completion builder
    // ------------------------------------------------------------------
    // TODO: DW0: fmt/type for CplD (or Cpl for errors), length
    // TODO: DW1: completer ID, status, BCM, byte count
    // TODO: DW2: requester ID, tag, lower address
    // TODO: DW3: SRAM read data
    // TODO: helper functions for byte count / lower address from byte enables

    // ------------------------------------------------------------------
    // 9. Completion output
    // ------------------------------------------------------------------
    // TODO: drive data / valid / last; hold until the gasket is ready

    // ------------------------------------------------------------------
    // 10. Assertions (optional, good for verification grade)
    // ------------------------------------------------------------------
    // TODO: e.g. completion data stable while valid && !ready
    // TODO: e.g. no new request accepted while a completion is pending

endmodule
