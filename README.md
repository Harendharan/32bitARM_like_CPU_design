# 32bitARM_like_CPU_design
The 32-bit ARM-like CPU design project aims to simulate a basic CPU architecture inspired by the ARM instruction set, focusing on data processing, memory access, and branching operations. This project explores the core elements of CPU design, including instruction decoding, execution, memory management, and control flow. The CPU supports a instruction types such as Data processing, Memory and Branch instructions. By implementing a simple functional processor, this project provides insight into the operation of microprocessors and serves as a foundation for more advanced CPU designs.

**Instructor**: Rajdeep Mazumder (WhyRD)

**edaplayground**: https://www.edaplayground.com/x/9uJ4

---

## Instruction Set

### **Data Processing Instruction**

| 31:28       | 27:26                  | 25:20            | 19:16      | 15:12       | 11:0      |
|-------------|------------------------|------------------|------------|-------------|-----------|
| `cond`      | `type of instruction` | `funt`           | `Rn`       | `Rd`        | `Src2`    |
| Condition   | `00` - Data Processing| Function Field   | First Source Register  | Destination Register | Operand   |

#### **Details of `funt` (25:20) and `Src2` (11:0):**

- **Function Field (`funt`):**
  | Bit      | Field       | Description                                   |
  |----------|-------------|-----------------------------------------------|
  | 25       | `I`         | Immediate (`1`) or Register (`0`)             |
  | 24:21    | `cmd`       | Command (e.g., ADD, SUB, AND, ORR)            |
  | 20       | `S`         | Signed (`1`) or Unsigned (`0`)                |

- **Second Operand (`Src2`):**
  - **If Immediate (`I=1`):**
    | Bit    | Field       | Description                                   |
    |--------|-------------|-----------------------------------------------|
    | 11:8   | `rot`       | Rotation                                      |
    | 7:0    | `imm8`      | 8-bit Immediate Value                         |

  - **If Register (`I=0`):**
    | Bit    | Field       | Description                                   |
    |--------|-------------|-----------------------------------------------|
    | 11:7   | `shamt5`    | Shift Amount                                  |
    | 6:5    | `sh`        | Shift Type                                    |
    | 4:0    | `Rm`        | Second Source Register                        |

---

### **Memory Instruction**

| 31:28       | 27:26                  | 25:20            | 19:16      | 15:12       | 11:0      |
|-------------|------------------------|------------------|------------|-------------|-----------|
| `cond`      | `type of instruction` | `funt`           | `Rn`       | `Rd`        | `Src2`    |
| Condition   | `01` - Memory          | Function Field   | Base Reg   | Destination/Source | Offset    |

#### **Details of `funt` (25:20) and `Src2` (11:0):**

- **Function Field (`funt`):**
  | Bit      | Field       | Description                                   |
  |----------|-------------|-----------------------------------------------|
  | 25       | `I`         | Immediate (`1`) or Register (`0`)             |
  | 24       | `P`         | Pre/Post Indexing                             |
  | 23       | `U`         | Up (`1`) or Down (`0`) Offset                 |
  | 22       | `B`         | Byte (`1`) or Word (`0`) Access               |
  | 21       | `W`         | Write-back (`1`) or No Write-back (`0`)       |
  | 20       | `L`         | Load (`1`) or Store (`0`)                     |

- **Second Operand (`Src2`):**
  - **If Immediate (`I=1`):**
    | Bit    | Field       | Description                                   |
    |--------|-------------|-----------------------------------------------|
    | 11:0   | `imm12`     | 12-bit Immediate Offset                       |

  - **If Register (`I=0`):**
    | Bit    | Field       | Description                                   |
    |--------|-------------|-----------------------------------------------|
    | 11:7   | `shamt5`    | Shift Amount                                  |
    | 6:5    | `sh`        | Shift Type                                    |
    | 4:0    | `Rm`        | Offset Register                               |

---

### **Branch Instruction**

| 31:28       | 27:26                  | 25:24      | 23:0       |
|-------------|------------------------|------------|------------|
| `cond`      | `type of instruction` | `0L`       | `Imm24`    |
| Condition   | `10` - Branch          | Link Field | Offset     |

#### **Details of `0L` (25:24) and `Imm24` (23:0):**

- **Link Field (`0L`):**
  | Bit      | Field       | Description                                   |
  |----------|-------------|-----------------------------------------------|
  | 25       | `0`         | Always `0`                                    |
  | 24       | `L`         | Branch with Link (`1`) or Regular Branch (`0`)|

- **Immediate Offset (`Imm24`):**
  | Bit      | Field       | Description                                   |
  |----------|-------------|-----------------------------------------------|
  | 23:0     | `Imm24`     | Sign-extended and left-shifted by 2           |
  |          |             | Target Address: `PC + (Imm24 << 2)`           |

---

## Mnemonics
    
### **Instruction mnemonics from ARM LRM (Used in design)**

Data Processing: ADD SUB AND ORR 

Memory Operation: STR and LDR 

Branch: B 

### **Conditional mnemonics from ARM LRM**

![WhatsApp Image 2024-12-03 at 13 30 34_e0b9d3fd](https://github.com/user-attachments/assets/6a794e82-798c-4c2c-afeb-7da60a956cea)

ref: Digital Design and Computer Architecture ARM edition by Harris

---
## Micro Architecture Top View

![32cpu overview](https://github.com/user-attachments/assets/456d560d-4701-4ff0-9988-70b5811e8e6b)

---

## Datapath

### Memory Instruction Datapath

Memory instructions (`LDR` and `STR`) involve transferring data between registers and memory. The datapath for these instructions revolves around decoding the instruction, calculating the effective address using the base register (`Rn`) and an offset, and performing the appropriate memory access operation. Control signals like `I`, `P`, `U`, `W`, and `L` determine the exact behavior of the operation.

#### LDR (Load Instruction)

- **Effective Address Calculation**: 
  - If `I=1`: Compute the effective address by adding/subtracting the 12-bit immediate (`imm12`) to/from the base register (`Rn`).
  - If `I=0`: Use the base register (`Rn`) and a shifted offset from `Rm` (based on `shamt5` and `sh`).
- **Memory Access**: Read data from memory using the computed address.
- **Destination Register Update**: Load the read data into the destination register (`Rd`).
- **Optional Write-Back**: If `P=0` and `W=1`, update the base register (`Rn`) with the effective address.

  ![WhatsApp Image 2024-12-03 at 18 35 55_247a0e6e](https://github.com/user-attachments/assets/107fb7a7-cb54-463d-9e51-3b0236eec4d4)


#### STR (Store Instruction)

- **Effective Address Calculation**: 
  - Similar to `LDR`, compute the effective address using either an immediate offset or a shifted register offset.
- **Memory Access**: Write data from the source register (`Rd`) into memory at the computed address.
- **Optional Write-Back**: If `P=0` and `W=1`, update the base register (`Rn`) with the effective address.

![WhatsApp Image 2024-12-03 at 18 37 24_38eb6853](https://github.com/user-attachments/assets/d230fa4f-2d10-499a-82f6-935742a4cc53)

---

### Data Processing Instruction Datapath

Data processing instructions involve arithmetic, logical, and data manipulation operations. The datapath for these instructions processes operands from either immediate values or registers, executes the specified command (`cmd`), and stores the result in the destination register (`Rd`). The control signal `I` determines whether the second operand (`Src2`) is immediate or register-based.

#### Immediate Mode (`I=1`)

- **Operand Fetch**: 
  - Extract the 8-bit immediate value (`imm8`) and rotate it by the specified `rot` value (4 bits) to align it for the operation.
  - Retrieve the first source operand from the register (`Rn`).
- **Operation Execution**: Perform the specified command (`cmd`) such as ADD, SUB, AND, ORR, etc., using the first source operand (`Rn`) and the processed immediate value.
- **Result Storage**: Write the computed result into the destination register (`Rd`).
- **Flags Update**: If `S=1`, update condition flags (e.g., Zero, Negative, Carry, Overflow).

![WhatsApp Image 2024-12-03 at 19 02 43_943340b4](https://github.com/user-attachments/assets/171349bb-2e1e-4788-bed5-d77650705454)


#### Register Mode (`I=0`)

- **Operand Fetch**: 
  - Retrieve the first source operand from the register (`Rn`).
  - Obtain the second operand from the register (`Rm`) and apply the specified shift (`sh`) and shift amount (`shamt5`) for alignment.
- **Operation Execution**: Execute the specified command (`cmd`) using the first source operand (`Rn`) and the shifted second operand (`Rm`).
- **Result Storage**: Store the result in the destination register (`Rd`).
- **Flags Update**: If `S=1`, update condition flags based on the result.

![WhatsApp Image 2024-12-03 at 19 15 38_a337ae8d](https://github.com/user-attachments/assets/51f844d5-2fb0-42f9-b88a-1d02c183a089)

---

### Branch Instruction Datapath

Branch instructions enable program flow control by updating the program counter (PC) to jump to a target address. For a regular branch (`B`), the instruction computes the target address using the immediate offset (`Imm24`) and updates the PC accordingly. The `L` bit is set to `0` for regular branches.

#### Regular Branch (`B`)

- **Offset Calculation**: 
  - Extract the 24-bit immediate offset (`Imm24`) from the instruction.
  - Sign-extend `Imm24` to 32 bits and left-shift it by 2 to align it to word boundaries.
- **Target Address Computation**: 
  - Add the computed offset to the current value of the PC to determine the target address (`PC + (Imm24 << 2)`).
- **PC Update**: 
  - The PC is updated to the calculated target address, effectively jumping to the new instruction location.

![WhatsApp Image 2024-12-03 at 19 19 19_dd399a67](https://github.com/user-attachments/assets/a26d63bb-0c6f-48e8-a16b-dfdc4bf1eb21)

### Final Datapath

![WhatsApp Image 2024-12-04 at 13 19 17_d4c7edb9](https://github.com/user-attachments/assets/3967fe60-2d40-46bf-a6ef-821620513a0e)

---

## Micro Architecture 

Integrating controler with the datapath gives us the main Micro Architecture. Here Controller is treated as a Black Box.

![WhatsApp Image 2024-12-02 at 18 05 23_78d8007b](https://github.com/user-attachments/assets/6bb2e541-1912-4ee8-b1e5-d6959ad55d76)

---

## Demystifying Controller

Removing the Controller BlackBox, we unveil two critical components inside: **Decoder** and **Conditional Logic**. These work together to control the flow of operations based on the current instruction and condition flags.

![Controller Overview](https://github.com/user-attachments/assets/822ba4a9-3815-4601-95b2-6be4fa1eacb4)

### Decoder

The **Decoder** module is responsible for interpreting the instruction passed to the controller and generating the corresponding control signals. This is achieved through its subcomponents: **PC Logic**, **Main Decoder**, and **ALU Decoder**. 

- **PC Logic** decides whether the next instruction should be fetched from the next sequential address or jump based on certain conditions.
- **Main Decoder** decodes the operation field and function codes from the instruction, producing control signals like `RegWrite`, `MemWrite`, `ALUSrc`, and `ImmSrc`.
- **ALU Decoder** specifically manages control signals related to the ALU operation, determining which arithmetic or logical function the ALU should perform (e.g., ADD, SUB, AND, ORR). 

![Decoder](https://github.com/user-attachments/assets/cb1800fd-5518-4de5-950b-f219fbace3ef)

### PC Logic
The **PC Logic** is crucial in controlling the program counter. It decides whether to update the PC to the next sequential address or to jump to a new address depending on branch conditions or other control signals. This logic interacts directly with the flags set by the ALU and condition checks from the `Condlogic`.

### Main Decoder
The **Main Decoder** extracts operation and function bits from the instruction and produces various control signals. For instance, it might set the ALU source or define how the result should be stored (e.g., to registers or memory). Based on the instruction type (e.g., data-processing, load/store), it configures these control signals accordingly.

### ALU Decoder
The **ALU Decoder** focuses on translating the function code to a specific ALU operation, such as addition, subtraction, logical AND, or OR. It checks the instruction's function field and determines what kind of operation the ALU should perform. It also determines whether the result should affect condition flags like zero, negative, carry, or overflow.

### Conditional Logic

The **Conditional Logic** block ensures that certain operations (like writing to registers or memory) occur only if certain conditions, based on the flags set by previous operations, are met. These conditions could be checks for equality (EQ), negative result (MI), or overflow (VS), among others. This logic evaluates the condition code and decides whether the operation should proceed.

**Inside Conditional Logic:**

1. **Flag Storage (Flip-Flops)**: 
   - **Flip-Flops (flopenr)** store condition flags (e.g., zero, negative, carry, overflow) set by the ALU or other operations. These flip-flops are controlled by the `FlagWrite` signal, which enables updating of flags when needed.
   - The flags are updated only if `FlagWrite` is asserted, which is typically determined by the type of instruction or operation being executed (e.g., comparison, arithmetic, or logical operations).

2. **Conditional Check (`condcheck`)**:
   - The **condcheck** block evaluates the stored flags and compares them with the condition codes (`Cond`), determining whether the specific operation should proceed based on the current state of the flags.
   - For example, if the condition is "zero" (EQ), the `CondEx` signal is asserted when the zero flag is set. This means the operation will proceed if the condition is met.

3. **Control Signal Generation**:
   - Based on the evaluated condition (`CondEx`), the **Conditional Logic** generates control signals like `RegWrite`, `MemWrite`, and `PCSrc`.
   - If `CondEx` is true (i.e., the condition is met), these signals may be asserted to enable register writes, memory writes, or branch operations (e.g., updating the program counter).

![Conditional Logic](https://github.com/user-attachments/assets/19cf078c-eeef-4539-b367-ea0597210f24)

---

### Connections in Conditional Logic

In the **Conditional Logic** module, the **flip-flops (FF)** play a crucial role in storing and passing the flags set by the ALU operation. Specifically, the **flopenr** modules are used to store the 2-bit flags (`FlagWrite`) for each condition (e.g., `neg`, `zero`, `carry`, `overflow`). These flags are written to flip-flops based on the control signal and then used by the `condcheck` module to determine if the condition for branching or other control signals is met.

- **Flip-flops (flopenr)**: These are used to store the current state of flags (`Flags[3:2]` for certain flags and `Flags[1:0]` for others). The flags are written into flip-flops only when the `FlagWrite` control signal is asserted, indicating that the flags should be updated.
  
- **Conditional Check (`condcheck`)**: This block reads the stored flag values (`Flags`) and evaluates the condition code (`Cond`). It outputs the `CondEx` signal, which determines whether a particular control operation should be executed based on the condition flags.

  - For example, if the condition is for "zero" (EQ), the `CondEx` signal is asserted when the zero flag is set, signaling that the operation (such as memory write, register write, or PC update) should proceed.

- **Control Signals**: Based on the evaluated condition (`CondEx`), other control signals like `RegWrite`, `MemWrite`, and `PCSrc` are conditionally asserted. For instance, if `CondEx` is true, `RegWrite` and `MemWrite` might be enabled.

---

## Verilog Implementation

![WhatsApp Image 2024-12-02 at 18 15 42_c1fb8306](https://github.com/user-attachments/assets/7102e175-f1f8-4995-846a-c8371fcbb7ea)

### 1. Top-Level CPU Architecture
The design of a 32-bit CPU in a single Verilog file (`cpu.v`) includes both the **datapath** and **controller** modules combined into one unit. The CPU interacts with **instruction memory (imem)** and **data memory (dmem)**, with the combined module orchestrating data processing and control flow.

#### Components:
- **Datapath**: Responsible for executing operations on data. This includes the ALU (Arithmetic Logic Unit), register file, memory interfaces, and multiplexers to route data where needed.
- **Controller**: Manages the operation of the datapath. It generates control signals that dictate the functionality of the datapath components based on the current instruction.
- **Data Memory (dmem)**: Stores and retrieves data during execution.
- **Instruction Memory (imem)**: Stores the program code (instructions) for the CPU. In our program, `memfile.dat` is used to dump the instructions (binary or hexadecimal machine code) into the instruction memory.
- **memfile.dat** (only HEX CODE):

![WhatsApp Image 2024-12-05 at 19 48 28_3b65e2bb](https://github.com/user-attachments/assets/e45fb323-1813-4704-af78-666a6b1853f4)


ref: Digital Design and Computer Architecture ARM edition by Harris

---

### 2. Combined Datapath and Controller (`cpu.v`)
In this implementation, both the **datapath** and the **controller** are encapsulated within a single Verilog module, `cpu.v`. This setup simplifies the design by reducing the need for separate modules and direct connections between the datapath and controller. However, it still follows the basic principles of CPU design.

#### Key Components Inside `cpu.v`:
- **Program Counter (PC)**: Holds the address of the next instruction to be fetched.
- **Instruction Register (IR)**: Holds the fetched instruction from imem.
- **Register File**: Stores general-purpose registers (e.g., R0 to R15).
- **ALU**: Performs arithmetic or logical operations based on control signals.
- **Multiplexers (MUX)**: Routes the appropriate data (e.g., selecting between ALU results and register file outputs).
- **Data Memory (DMEM)**: Interface for reading from and writing to data memory.
- **Controller Logic**: Decodes the instruction and generates control signals for:
  - Register writes
  - Memory access (read/write)
  - ALU operation selection
  - Multiplexer selection for data routing
  - Program Counter (PC) updates (increment or branch)

---

### 3. Data Flow in `cpu.v`
The flow of data within the CPU can be broken down into the following steps:

1. **Fetch**: 
   - The **Program Counter (PC)** points to the next instruction address, which is sent to **Instruction Memory (imem)**.
   - The instruction fetched from imem is placed into the **Instruction Register (IR)**.
   
2. **Decode**: 
   - The controller decodes the instruction by reading the opcode and identifying the instruction type.
   - Based on the instruction, the controller generates the necessary control signals.
   
3. **Execute**: 
   - The ALU performs operations (like addition, subtraction, logical operations) on data fetched from the **Register File** or provided as immediate values.
   - Data memory operations like **load** and **store** are also executed during this phase (if applicable).

4. **Memory Access (if applicable)**: 
   - If the instruction involves data manipulation, **Data Memory (dmem)** is accessed (e.g., reading or writing data).
   
5. **Write-back**: 
   - The result of the ALU operation (or data from dmem) is written back to the **Register File** if necessary.

6. **PC Update**:
   - The **Program Counter (PC)** is updated based on the instruction (incremented for sequential execution, or updated with a new address for Branch instructions).

---

### 4. Control Signals
The **controller** within `cpu.v` generates various control signals that regulate the operation of the datapath components:
- **ALU Control**: Determines the type of operation the ALU should perform (e.g., ADD, SUB, AND, OR).
- **Register Write**: Controls whether data should be written to the **Register File**.
- **Memory Read/Write**: Specifies if data should be read from or written to **Data Memory (dmem)**.
- **PC Control**: Dictates whether the **Program Counter (PC)** should be incremented or jump to a new address (for branch instruction).

---

## Verification

All the individuals components are verified and uploaded in the folders namely `CPU components` , `dmem` and `imem` in this repo.
The main **TOP Module** is verified with a simple verification testbench by debugging the contents of the general purpose registers and RAM .

### Description of the Testbench

This testbench is designed to test the functionality of the `top` module, which includes a CPU, memory (both instruction and data), and various other components. The testbench verifies if a specific register in the CPU or specific location in the RAM contains the expected value.

#### Key Components of the Testbench

##### Instantiation of the DUT (Device Under Test):
   - The `top` module is instantiated as `dut` (device under test). The `top` module includes the entire system, including the CPU and other connected components such as memories.
   - The `top` module takes `clk` (clock) and `reset` as inputs, which are provided by the testbench.
     
     ```
     top dut(clk, reset);
     ```

##### Initial Reset
   - The `reset` signal is asserted high (`reset <= 1`) for 10 time units to initialize the system. After that, the reset is deasserted (`reset <= 0`), allowing the system to start running.
   - This simulates the startup behavior where the system is first reset and then allowed to begin normal operation.
  
     ```
     initial begin
      reset <= 1; 
  	  #10;
      reset <= 0;
     end
     ```

##### Clock Generation
   - The clock signal `clk` is generated using an `always` block with a period of 10 time units (5 time units for high and low). This generates a continuous clock pulse to drive the system.
  
     ```
     always #5 clk=~clk;
     ```

##### Verification of CPU
   - After the system has run for a period of time (10,000 time units in this case), the values of General purpose Registers from the CPU's register file and RAM are checked.

 ![WhatsApp Image 2024-12-07 at 12 56 10_5cb560f3](https://github.com/user-attachments/assets/1d789d77-711b-4f7a-93ae-dabf247d043e)


1. **Test Case 1: SUB R0, R15, R15**
   - **Instruction**: `R0 = 0`
   - **Verification**: Checks if register `R0` contains `0`.
   - **Expected Outcome**: Passes if `R0 = 0`.

2. **Test Case 2: ADD R3, R0, #12**
   - **Instruction**: `R3 = 12`
   - **Verification**: Checks if register `R3` contains `12`.
   - **Expected Outcome**: Passes if `R3 = 12`.

3. **Test Case 3: ORR R4, R7, R2**
   - **Instruction**: `R4 = 3 OR 5 = 7`
   - **Verification**: Checks if register `R4` contains `7`.
   - **Expected Outcome**: Passes if `R4 = 7`.

4. **Test Case 4: ADD R5, R5, R4**
   - **Instruction**: `R5 = 4 + 7 = 11`
   - **Verification**: Checks if register `R5` contains `11`.
   - **Expected Outcome**: Passes if `R5 = 11`.

5. **Test Case 5: SUB R7, R7, R2**
   - **Instruction**: `R7 = 12 - 5 = 7`
   - **Verification**: Checks if register `R7` contains `7`.
   - **Expected Outcome**: Passes if `R7 = 7`.

6. **Test Case 6: STR R7, [R3, #84]**
   - **Instruction**: `mem[12+84] = 7`
   - **Verification**: Checks if memory location `RAM[24]` contains `7`.
   - **Expected Outcome**: Passes if `RAM[24] = 7`.

7. **Test Case 7: LDR R2, [R0, #96]**
   - **Instruction**: `R2 = mem[96] = 7`
   - **Verification**: Checks if register `R2` contains `7`.
   - **Expected Outcome**: Passes if `R2 = 7`.

8. **Test Case 8: STR R2, [R0, #100]**
   - **Instruction**: `mem[100] = 7`
   - **Verification**: Checks if memory location `RAM[25]` contains `7`.
   - **Expected Outcome**: Passes if `RAM[25] = 7`.


##### Test Completion
   - The `$finish` system task is called at the end of the test to stop the simulation.

```
$finish;
```

#### Output
When the test completes, the terminal will display the following messages:

![image](https://github.com/user-attachments/assets/13222a9e-c5bb-41bf-8000-8d68c9e11bf2)

---

## Certification

![1734621516830-certificate](https://github.com/user-attachments/assets/71cb4012-300d-4d67-b7d3-922a9a9ec4d1)

---









