// ----------------------------------------------------------------------------------
// FILE NAME   :-- sync_fifo_8x32.v
// TYPE        :-- MODULE
// ----------------------------------------------------------------------------------
// KEYWORDS    :-- Synchronous FIFO, memory, buffer, single clock, pointer, active-low reset
// ----------------------------------------------------------------------------------
//DESCRIPTION :-- This module implements a generic, synchronous First-In, First-Out (FIFO)
//                memory buffer. It uses a single clock for all operations and has an
//                asynchronous active-low reset.
//
//               Port Details:
//               - clk (Clock Signal): The main clock for both read and write operations.
//               - rst_n (Reset): Asynchronous active-low reset. When '0', the FIFO resets to its empty state.
//               - wr_en (Write Enable): When asserted ('1'), data is written to the FIFO on the next rising clock edge if not full.
//               - data_in (Data Input): The data bus for writing data into the FIFO.
//               - rd_en (Read Enable): When asserted ('1'), data is read from the FIFO on the next rising clock edge if not empty.
//               - data_out (Data Output): The data bus for reading data. Data is valid on the cycle AFTER rd_en is asserted.
//               - full (Full Signal): Asserted ('1') when the FIFO is full and cannot accept more data.
//               - empty (Empty Signal): Asserted ('1') when the FIFO is empty and no data can be read.
// ---------------------------------------------------------------------------------
module sync_fifo_8x32
#(
    parameter fifo_width = 32,              // Width of the data bus
    parameter fifo_depth = 8,               // Depth of the FIFO
    parameter ptr_w = $clog2(fifo_depth)    // Address width based on depth
)
(
    
    input                       clk,       // Clock signal
    input                       rst_n,     // Active-low reset
    input                       wr_en,     // Write enable
    input      [fifo_width-1:0] data_in,   // Data input
    input                       rd_en,     // Read enable
    output reg [fifo_width-1:0] data_out,  // Data output
    output                      full,      // Full flag
    output                      empty     // Empty flag
);

    // FIFO memory array
    reg [fifo_width-1:0] fifo_mem [fifo_depth-1:0];
    
    // Write and Read Pointers with one extra bit for full/empty detection
    reg [ptr_w:0]   wr_ptr;
    reg [ptr_w:0]   rd_ptr;


    // Assigning full and empty flags
    assign empty = (wr_ptr == rd_ptr);
    assign full  = (wr_ptr[ptr_w] != rd_ptr[ptr_w]) && (wr_ptr[ptr_w-1:0] == rd_ptr[ptr_w-1:0]);
    
    // Code for write and read operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
        begin
            // On reset, clear pointers and output data
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            data_out <= 0;
        end
        else 
        begin
            // --- Write Logic ---
            if (wr_en && !full) begin
                fifo_mem[wr_ptr[ptr_w-1:0]] <= data_in; 
                wr_ptr <= wr_ptr + 1;
            end

            // --- Read Logic ---
            if (rd_en && !empty) begin
                data_out <= fifo_mem[rd_ptr[ptr_w-1:0]];
                rd_ptr <= rd_ptr + 1;
            end
        end
    end
endmodule
    