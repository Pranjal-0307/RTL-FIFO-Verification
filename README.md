# 💾 Verilog Synchronous FIFO (8x32)

This project is a complete RTL implementation of a parameter-driven, synchronous FIFO (First-In, First-Out) memory buffer in Verilog.  
A FIFO is a fundamental building block in digital design, essential for handling data flow between modules operating at different speeds or with bursty data.

This repository includes both the synthesizable RTL design and a robust, self-checking testbench to verify its functionality under various conditions.

---

## ⚙️ Core Features

- 📏 **Parameterized Design:** Easily change `fifo_width` (default: 32) and `fifo_depth` (default: 8) in the design.  
- 🚩 **Status Flags:** Provides reliable `full` and `empty` output signals.  
- 🧠 **Smart Pointers:** Uses the standard "extra bit" pointer comparison method for robust full/empty detection.  
- ⏱️ **Fully Synchronous:** All read and write operations are synchronized to a single clock (`clk`).  
- 🔄 **Asynchronous Reset:** Includes an active-low reset (`rst_n`) to initialize the FIFO to its empty state.

---

## ▶️ How to Run the Simulation

This project can be compiled and run from any standard terminal using **Icarus Verilog**.

```bash
# 1. Compile the design and testbench
#    (We must include the rtl/ and tb/ paths)
iverilog -o result rtl/sync_fifo_8x32.v tb/sync_fifo_8x32_tb.v

# 2. Run the compiled simulation
vvp result

# 3. View the generated waveform
gtkwave sync_fifo_8x32.vcd
