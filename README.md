# RISC-V Single Cycle CPU

## Overview
This project implements a single-cycle RISC-V CPU supporting basic instruction extensions and types, including I-type, J-type, UJ-type, and R-type instructions. The CPU is written in Verilog and designed to execute a subset of the RISC-V ISA.

## Features
- **Single-cycle architecture**
- **Instruction support:**
  - I-type (Immediate instructions)
  - R-type (Register-Register operations)
  - J-type (Jump instructions)
  - UJ-type (Upper immediate jump instructions)
- **Basic ALU operations**
- **Instruction fetch, decode, execute, memory, and write-back stages**
- **Register file with 32 registers (x0-x31)**
- **Memory interface for instruction and data access**

## Supported Instructions
### I-Type Instructions
- `ADDI` - Add immediate
- `ANDI` - AND immediate
- `ORI` - OR immediate
- `XORI` - XOR immediate
- `SLTI` - Set less than immediate
- `SLLI` - Shift left logical immediate
- `SRLI` - Shift right logical immediate
- `SRAI` - Shift right arithmetic immediate
- `LW` - Load word

### R-Type Instructions
- `ADD` - Add
- `SUB` - Subtract
- `AND` - AND
- `OR` - OR
- `XOR` - XOR
- `SLL` - Shift left logical
- `SRL` - Shift right logical
- `SRA` - Shift right arithmetic
- `SLT` - Set less than

### J-Type and UJ-Type Instructions
- `JAL` - Jump and link
- `JALR` - Jump and link register
- `LUI` - Load upper immediate
- `AUIPC` - Add upper immediate to PC

## Project Structure
```
├──top.v
├── top_tb.sv
├── README.md          # This file

## Simulation & Testing
To test the CPU, use a Verilog simulator such as ModelSim, VCS, or Icarus Verilog.

### Running the Testbench
1. Install [Icarus Verilog](http://iverilog.icarus.com/) or another Verilog simulator.
2. Compile the testbench:
   ```sh
   iverilog top.v top_tb.sv
   ```
3. Run the simulation:
   ```sh
   vvp a.out
   ```
4. Use a waveform viewer (e.g., GTKWave) to inspect the signal behavior:
   ```sh
   gtkwave top_tb.vcd
   ```

## Future Enhancements
- Implementing a 5-stage pipeline architecture
- Supporting more RISC-V extensions (e.g., M extension for multiplication and division)
- Adding exception handling and CSR registers
- Optimizing performance with hazard detection and forwarding

## Author
Muhammad Ousaif - officialousaif@gmail.com
