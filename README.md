# 32bitARM_like_CPU_design

## Instruction Set

### **Data Processing Instruction**

| 31:28       | 27:26                  | 25:20            | 19:16      | 15:12       | 11:0      |
|-------------|------------------------|------------------|------------|-------------|-----------|
| `cond`      | `type of instruction` | `funt`           | `Rn`       | `Rd`        | `Src2`    |
| Condition   | `00` - Data Processing| Function Field   | Source Reg 1 | Destination Reg | Source Reg 2   |

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
| Condition   | `01` - Memory          | Function Field   | Base Reg   | Dest/Source | Offset    |

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

## Micro Architecture : 

![WhatsApp Image 2024-12-02 at 18 05 23_78d8007b](https://github.com/user-attachments/assets/6bb2e541-1912-4ee8-b1e5-d6959ad55d76)


## 

























