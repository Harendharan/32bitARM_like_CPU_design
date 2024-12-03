# 32bitARM_like_CPU_design

## Instruction Set

### **Data Processing Instruction**
| 31:28 | 27:26 | 25 | 24:21 | 20 | 19:16 | 15:12 | 11:0 | | cond | 00 | I | cmd | S | Rn | Rd | Src2 |
- **31:28** - `cond` (Condition Code)
- **27:26** - `type of instruction` (`00` - Data Processing)
- **25:20** - `funt`  
  - **25** - `I` (Immediate or Register)
  - **24:21** - `cmd` (Command)
  - **20** - `S` (Signed)
- **19:16** - `Rn` (Source Register 1)
- **15:12** - `Rd` (Destination Register)
- **11:0** - `Src2` (Second Operand)  
  - **If Immediate (I=1):**  
    - **11:8** - `rot` (Rotation)
    - **7:0** - `imm8` (8-bit Immediate Value)
  - **If Register (I=0):**  
    - **11:7** - `shamt5` (Shift Amount)
    - **6:5** - `sh` (Shift Type)
    - **4:0** - `Rm` (Second Source Register)

---

### **Memory Instruction**
- **31:28** - `cond` (Condition Code)
- **27:26** - `type of instruction` (`01` - Memory)
- **25:20** - `funt`  
  - **25** - `I` (Immediate or Register)
  - **24:20** - `P`, `U`, `B`, `W`, `L`  
    - **P**: Pre/Post Indexing
    - **U**: Up/Down
    - **B**: Byte/Word Access
    - **W**: Write-back
    - **L**: Load/Store
- **19:16** - `Rn` (Base Register)
- **15:12** - `Rd` (Destination or Source Register)
- **11:0** - `Src2` (Offset)  
  - **If Immediate (I=1):**  
    - **11:0** - `imm12` (12-bit Immediate Offset)
  - **If Register (I=0):**  
    - **11:7** - `shamt5` (Shift Amount)
    - **6:5** - `sh` (Shift Type)
    - **4:0** - `Rm` (Offset Register)

---

### **Branch Instruction**
- **31:28** - `cond` (Condition Code)
- **27:26** - `type of instruction` (`10` - Branch)
- **25:24** - `0L`  
  - **25** - Always `0`
  - **24 (L)**:  
    - `1`: Branch with Link (Function Call)
    - `0`: Regular Branch
- **23:0** - `Imm24` (Immediate Offset)  
  - Offset is sign-extended to 32 bits and left-shifted by 2.
  - Branch target address is:  
    \[
    \text{Target Address} = \text{PC} + (\text{Imm24} \ll 2)
    \]
    
Istruction types summary:

Data Processing: ADD SUB AND ORR 

Memory Operation: STR and LDR 

Branch: B 

Conditional mnemonics from ARM LRM: 

![mnemonics](https://github.com/user-attachments/assets/e8a8261a-a35b-4f18-aeb7-ca446522d544)
ref: Digital Design and Computer Architecture ARM edition by Harris


## Micro Architecture : 

![WhatsApp Image 2024-12-02 at 18 05 23_78d8007b](https://github.com/user-attachments/assets/6bb2e541-1912-4ee8-b1e5-d6959ad55d76)


## 

























