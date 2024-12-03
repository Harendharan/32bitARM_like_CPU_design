# 32bitARM_like_CPU_design

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

---

## Micro Architecture 

![WhatsApp Image 2024-12-02 at 18 05 23_78d8007b](https://github.com/user-attachments/assets/6bb2e541-1912-4ee8-b1e5-d6959ad55d76)


## 

























