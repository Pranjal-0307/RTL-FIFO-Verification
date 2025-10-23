// ----------------------------------------------------------------------------------
// FILE NAME   :-- sync_fifo_8x32_tb.v
// TYPE        :-- Testbench
// ----------------------------------------------------------------------------------
// DESCRIPTION :-- A testbench for the synchronous FIFO module (sync_fifo_8x32).
//               This testbench verifies the following scenarios:
//               1. Reset Behavior
//               2. Writing until the FIFO is full and attempting an overflow.
//               3. Reading until the FIFO is empty and attempting an underflow.
//               4. Simultaneous read and write operations.
// ---------------------------------------------------------------------------------
module sync_fifo_8x32_tb;
       parameter fifo_width = 32;
       parameter fifo_depth = 8;
       reg                   clk=0;
       reg                   rst_n;
       reg                   wr_en;
       reg                   rd_en;
       reg  [fifo_width-1:0] data_in;
       wire [fifo_width-1:0] data_out;
       wire                  full; 
       wire                  empty;

       integer i;

    // Instantiate the FIFO module
    sync_fifo_8x32 #(fifo_width, fifo_depth) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .data_in(data_in),
        .rd_en(rd_en),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );     
    
    // Clock generation
    always 
    begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end
    
    initial 
    begin
        $dumpfile("sync_fifo_8x32.vcd");  // VCD file for waveform viewing
        $dumpvars(0, sync_fifo_8x32_tb);
        $display("---------------------------------------------------");
        $display("-------Simulation of Synchronous-FIFO ------------------");        
        $display("---------------------------------------------------");
    end

    task write_data(input [fifo_width-1:0] d_in); 
        begin
            @(posedge clk);
            if (!full) begin
                wr_en   = 1;
                data_in = d_in;
                @(posedge clk);
                wr_en   = 0;
                $display("[%0t] Write Data= %d, Full= %d",$time,d_in,full);
            end 
            else begin
                // This is the new warning message you wanted
                $display("[%0t] WARNING: Write skipped, FIFO is FULL.", $time);
            end
        end
    endtask
    task read_data(); 
        begin
            @(posedge clk);
            if (!empty) begin
                rd_en = 1;
                @(posedge clk);
                rd_en = 0;
                $display("[%0t] Read Data= %d, Empty= %d",$time, data_out,empty);
            end
            else begin
                // This is the new warning message for the read task
                $display("[%0t] WARNING: Read skipped, FIFO is EMPTY.", $time);
            end
        end
    endtask
    //Create stimulus
    initial 
    begin
        // Initialize signals
        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        // Apply reset
        #12;
        rst_n = 1;
        //Scenario 1: Full and Empty verification
        // Write data into FIFO
        $display("-----Scenario 1: Full And Empty Verification-----");
        for (i = 0; i < fifo_depth+1; i = i + 1)
        begin    // We get Full condition at 8th write
            write_data(i**2);
        end
        $display("[%0t] FIFO should now be FULL. (Full: %b, Empty: %b)", $time, full, empty);
        
        // Read data from FIFO
        for (i = 0; i < fifo_depth+1; i = i + 1) 
        begin // We get Empty condition at 8th read  
            read_data();
        end
        $display("[%0t] FIFO should now be EMPTY. (Full: %b, Empty: %b)", $time, full, empty);
        //Scenario 2:Basic Read And Write
        $display("-----Scenario 2:Basic Write And Read-----");
        for (i = 0; i < fifo_depth; i = i + 1)
        begin
            write_data(i**2);
            read_data();
        end
        //Scenario 3: Random Read And Write
        $display("-----Scenario 3:Random Write And Read-----");
        write_data(1);
        write_data(10);
        write_data(100);    
        read_data();
        read_data();
        read_data();
 #200 $finish; // End simulation after 200 time units
    end
        // End simulation
   endmodule