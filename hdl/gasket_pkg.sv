package gasket_pkg;

    parameter DWORD_WIDTH = 32

// Format Field (DW0 [30:29])
typedef enum logic [1:0] {
    FMT_3DW_NO_DATA = 2'b00,  // e.g., MRd32
    FMT_4DW_NO_DATA = 2'b01,  // e.g., MRd64
    FMT_3DW_DATA    = 2'b10,  // e.g., MWr32, CplD
    FMT_4DW_DATA    = 2'b11   // e.g., MWr64
} tlp_fmt_e;

// Type Field (DW0 [28:24])
typedef enum logic [4:0] {
    TYPE_MEM  = 5'b00000,     // Memory Read / Write
    TYPE_IO   = 5'b00010,     // I/O Read / Write
    TYPE_CFG0 = 5'b00100,     // Config Type 0
    TYPE_CFG1 = 5'b00101,     // Config Type 1
    TYPE_CPL  = 5'b01010      // Completion
} tlp_type_e;

// The common TLP Header
// shared among mem wr/rd and completions
typedef struct packed {
    logic        rsvd0;       // [31]    Reserved (0) / Fmt[2] for TLP Prefixes
    logic [1:0]  fmt;         // [30:29] Format (00: 3DW no data, 10: 3DW with data, etc.)
    logic [4:0]  tlp_type;    // [28:24] Type (00000: Mem, 01010: Cpl/CplD, etc.)
    logic        rsvd1;       // [23]    Reserved (0)
    logic [2:0]  tc;          // [22:20] Traffic Class (typically 3'b000)
    logic        rsvd2;       // [19]    Reserved (0) / LN (Lightweight Notification)
    logic        th;          // [18]    TLP Processing Hints (0: no hints)
    logic        td_ext;      // [17]    Reserved (0) / Extended Tag bit [9]
    logic        attr_ext;    // [16]    Reserved (0) / ID-Based Ordering (IDO) Attr[2]
    logic        td;          // [15]    TLP Digest present (1: ECRC appended, 0: none)
    logic        ep;          // [14]    Error Poisoned (1: corrupted data payload, 0: normal)
    logic [1:0]  attr;        // [13:12] Attributes: [13] Relaxed Ordering, [12] No Snoop
    logic [1:0]  at;          // [11:10] Address Translation (00: Untranslated MMIO)
    logic [9:0]  length;      // [9:0]   Payload Length in DWORDs (10'd1 = 1 DW, 10'd0 = 1024 DW)
} tlp_packet_dw0_t;

// 
typedef union packed {
    logic [31:0] raw;             

    struct packed { 
        logic [7:0] req_bus;    
        logic [4:0] req_dev;    
        logic [2:0] req_func;   
        logic [7:0] tag;        
        logic [3:0] last_dw_be; 
        logic [3:0] first_dw_be;
    } mem_req;

    struct packed {
        logic [7:0]  cpl_bus;    
        logic [4:0]  cpl_dev;    
        logic [2:0]  cpl_func;   
        logic [2:0]  status;     
        logic        bcm;        
        logic [11:0] byte_count; 
    } cpl;

} tlp_packet_dw1_u;

typedef struct packed { 
    logic [31:0] data;

    struct packed { 
        logic [29:0] address;
        logic [1:0] reserved;
    } mem_req;

    struct packed {
        logic [15:0] req_id;    
        logic [7:0]  tag;    
        logic        reserved;   
        logic [6:0]  lower_addr;     
    } cpl;

} tlp_packet_dw2_u;

typedef struct packed {
    logic [31:0] raw_data;

} tlp_packet_DW3;

// all in all TLP packet for PCIE  

typedef union packed {

    struct packed{
        tlp_packet_dw0_t dw0;
        tlp_packet_dw1_u dw1;
        tlp_packet_dw2_u dw2;
        tlp_packet_DW3   dw3;
    } payload

    logic [3:0][31:0] tlp_packet;

} tlp_packet_128b_u




endpackage