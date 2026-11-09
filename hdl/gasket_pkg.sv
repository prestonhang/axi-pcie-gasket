package gasket_pkg;

    parameter DWORD_WIDTH = 32





// 32b header (4 bytes)
typedef struct packed {

    [4:0] type,
    [2:0] fmt // size of the header -- 
              /* Fmt[2:0]	TLP format
                  000b	3DW header without data
                  001b	4DW header without data
                  010b	3DW header with data
                  011b	4DW header with data
              */
} tlp_packet_header;






endpackage