module sram #(
    parameter int DEPTH     = 1024,
    parameter int DATA_W    = 32,
    parameter bit INIT_ZERO = 1'b1,
    localparam int ADDR_W   = $clog2(DEPTH),
    localparam int NBYTES   = DATA_W / 8
) (
    input  logic              clk,
    input  logic              en,
    input  logic [NBYTES-1:0] we,
    input  logic [ADDR_W-1:0] addr,
    input  logic [DATA_W-1:0] wdata,
    output logic [DATA_W-1:0] rdata
);

    logic [DATA_W-1:0] mem [DEPTH];

    initial begin
        if (INIT_ZERO)
            foreach (mem[i]) mem[i] = '0;
    end

    always_ff @(posedge clk) begin
        if (en) begin
            if (we == '0) begin
                rdata <= mem[addr];
            end else begin
                for (int i = 0; i < NBYTES; i++)
                    if (we[i]) mem[addr][i*8 +: 8] <= wdata[i*8 +: 8];
            end
        end
    end

endmodule