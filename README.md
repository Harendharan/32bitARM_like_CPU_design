# 32bitARM_like_CPU_design

## Instruction Set

### **Data Processing Instruction**

| Bits      | Field               | Description                                   |
|-----------|---------------------|-----------------------------------------------|
| 31:28     | `cond`              | Condition Code                                |
| 27:26     | `type of instruction` | `00` - Data Processing                      |
| 25:20     | `funt`              | Function Field                                |
| 25        | `I`                 | Immediate (`1`) or Register (`0`)             |
| 24:21     | `cmd`               | Command                                       |
| 20        | `S`                 | Signed (`1`) or Unsigned (`0`)                |
| 19:16     | `Rn`                | Source Register 1                             |
| 15:12     | `Rd`                | Destination Register                          |
| 11:0      | `Src2`              | Second Operand                                |
| 11:8 (I=1)| `rot`               | Rotation (when Immediate)                     |
| 7:0 (I=1) | `imm8`              | 8-bit Immediate Value                         |
| 11:7 (I=0)| `shamt5`            | Shift Amount (when Register)                  |
| 6:5 (I=0) | `sh`                | Shift Type                                    |
| 4:0 (I=0) | `Rm`                | Second Source Register                        |

---

### **Memory Instruction**

| Bits      | Field               | Description                                   |
|-----------|---------------------|-----------------------------------------------|
| 31:28     | `cond`              | Condition Code                                |
| 27:26     | `type of instruction` | `01` - Memory Instruction                   |
| 25:20     | `funt`              | Function Field                                |
| 25        | `I`                 | Immediate (`1`) or Register (`0`)             |
| 24:20     | `P, U, B, W, L`     | Memory Access Flags                           |
|           | `P`                 | Pre/Post Indexing                             |
|           | `U`                 | Up (`1`) or Down (`0`) Offset                 |
|           | `B`                 | Byte (`1`) or Word (`0`) Access               |
|           | `W`                 | Write-back (`1`) or No Write-back (`0`)       |
|           | `L`                 | Load (`1`) or Store (`0`)                     |
| 19:16     | `Rn`                | Base Register                                 |
| 15:12     | `Rd`                | Destination (Load) or Source (Store) Register |
| 11:0      | `Src2`              | Offset                                        |
| 11:0 (I=1)| `imm12`             | 12-bit Immediate Offset                       |
| 11:7 (I=0)| `shamt5`            | Shift Amount (when Register)                  |
| 6:5 (I=0) | `sh`                | Shift Type                                    |
| 4:0 (I=0) | `Rm`                | Offset Register                               |

---

### **Branch Instruction**

| Bits      | Field               | Description                                   |
|-----------|---------------------|-----------------------------------------------|
| 31:28     | `cond`              | Condition Code                                |
| 27:26     | `type of instruction` | `10` - Branch Instruction                   |
| 25:24     | `0L`                | Link Field                                    |
| 25        | `0`                 | Always `0`                                    |
| 24        | `L`                 | Branch with Link (`1`) or Regular Branch (`0`)|
| 23:0      | `Imm24`             | Immediate Offset                              |
|           |                     | Sign-extended and left-shifted by 2           |
|           |                     | Target Address: `PC + (Imm24 << 2)`           |

---
    
### Istruction mnemonics from ARM LRM (Used in design):

Data Processing: ADD SUB AND ORR 

Memory Operation: STR and LDR 

Branch: B 

---

### Conditional mnemonics from ARM LRM: 

![WhatsApp Image 2024-12-03 at 13 30 34_e0b9d3fd](https://github.com/user-attachments/assets/6a794e82-798c-4c2c-afeb-7da60a956cea)

![mnemonics](https://github.com/user-attachments/assets/e8a8261a-a35b-4f18-aeb7-ca446522d544)
ref: Digital Design and Computer Architecture ARM edition by Harris

---

## Micro Architecture : 

![WhatsApp Image 2024-12-02 at 18 05 23_78d8007b](https://github.com/user-attachments/assets/6bb2e541-1912-4ee8-b1e5-d6959ad55d76)


## 

























