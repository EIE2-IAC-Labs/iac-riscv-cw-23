# Team 23
Github repo master: Hanbo

Editor & writeup: Anish

# Summary of our approach (needs to be edited at the end) #
1. **Planning Single-Cycle RV321 Design**: We looked at our working design of Lab 4 and made note of differences in design to the final project. We then wrote down all the new changes we needed to make and assigned it.
2. **Implementing RV321 Design (For our own machine code)**: We then documented the changes we made, each of us contributing to the writeup of the task we completed. 
3. **Implementing RV321 Design (For Reference Program)**
4. **Implementing Pipelining**

# 1. Planning Single-Cycle RV321 Design #
The planning section was done together as a group.
<img width="900" alt="image" src="https://user-images.githubusercontent.com/69715492/205291667-2c9d8855-a6cf-4c51-a933-b5d381ea13d6.png">

Looking at the brief and comparing our Lab 4 design with the required project design, we have the following requirements:
* *Coming up with a machine code*
* *Add Jump Multiplexer*: with inputs PC+4 and Result which outputs WD3 (write data of register file). This will be used to write the return address after a jump to the register file, when a jump takes place
* *Add Trigger Multiplexer*: multiplexer with select line based on trigger
* *Add Return Multiplexer*
* *Changes in Control Unit*: for implementing JAL, Load and Store
* *Adding Data Memory and Multiplexer*

<img width="600" alt="image" src="https://user-images.githubusercontent.com/69715492/205308394-d7acb6d3-dbe2-4608-9d8b-682ef67b2c0d.png">


# 2. Implementing RV321 Design (For Team Code) #
For this stage of the project, we are all committing directly to the main branch. Since we are all working on individual modules, there won't be conflicts.

We delegated the tasks modularly:

* **Creating Machine Code**: *Entire team*
* **ALU**: *Diyang*; adding load immediate instruction into ALU
* **Control Unit**: *Pengyuan*; implementing control signals for JAl and Load/Store instructions plus jump and return multiplexers
* **Data Memory and Trigger Multiplexer**: *Anish*; created data memory module and trigger multiplexer
* **Top-level module checks and Testing**: *Hanbo*; ensuring variable names are consistent, debugging, simulating on GTK wave and checking that machine code works

## Creating Machine Code ##
Working together, we devised the following machine code. 

<img width="250" alt="image" src="https://user-images.githubusercontent.com/69715492/205517888-6aca9d06-e639-4c04-9c5a-2a6ac62d4b65.png">

## Changes in ALU ##

## Control Unit ##

graph note: X represents don't care.

### 1. implement Immediate type (Op = 7'b0010011)
R-type instruction should do some ALU operation with rs1 and Sign-extended Immediate and store it into the destination register rd. 
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform I-type instruction. (Orange Line)
![I-Type](/image/I-Type.jpg)

### 2. implement Load Word (Op = 7'b0000011)
Load word instruction should load the value of (memory address: [value in register file (rs1) + Immediate]) into destination register rd. 
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform load word. (Orange Line)
![Load_Word](/image/load_word.jpg)

### 3. implement Store Word (Op = 7'b0100011)
Store word instruction should store the value of register file rs2 to (memory address: [value in register file (rs1) + Immediate]).
Next cycle = PC + 4.
![Store_Word](/image/store_word.jpg)

The following graph shows how the control unit signals controls the entire program to perform store load. (Orange Line)

### 4. implement Register type (Op = 7'b0110011)
R-type instruction should do some ALU operation with rs1 and rs2 and store it into the destination register rd. 
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform R-type instruction. (Orange Line)
![R-Type](/image/R-Type.jpg)

### 5. implement Branch Equal (Op = 7'b1100011)
Branch Equal instruction should compare two register value rs1 and rs2. If they are equal, next cycle jumps to PC + Immediate.

The following graph shows how the control unit signals controls the entire program to perform BEQ. (Equal ? Orange Line : Purple Line)
![Branch_Equal](/image/branch_equal.jpg)

### 6. implement Jump and Link Register or Return (Op = 7'b1100111)
Jump and Link instruction should obtain two goals. 
1. The counter should jump to register file rs1 + immediate, normally (return address value ra + Immediate).
2. return address register ra (0x01) should store the address of the next cycle (current PC + 4)

The following graph shows how the control unit signals controls the entire program to perform jump and link register.
Orange line performs the first goal.
Purple line performs the second goal.
![Jump_and_Link_Register](/image/jump_and_link_register.jpg)

### 7. implement Jump and Link (Op = 7'b1101111)
Jump and Link instruction should obtain two goals. 
1. The counter should jump to current PC value + Immediate
2. return address register ra (0x01) should store the address of the next cycle (current PC + 4)

The following graph shows how the control unit signals controls the entire program to perform jump and link.
Orange line performs the first goal.
Purple line performs the second goal.
![Jump_and_Link](/image/jump_and_link.jpg)

### 8. implement Load Upper Immediate (Op = 7'b0110111)
Load Upper Immediate instruction should load the {20 bit immediate, 12'b0} into destination register rd.
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform LUI. (Orange Line)
![Load_Upper_Immediate](/image/load_upper_immediate.jpg)


Main Decoder Table:

Sign Extension Table:

## Data Memory and Trigger Multiplexer ##
- implement load and store

## Top-level module checks and Testing ##
# 3. Implementing RV321 Design (For Reference Program) #

# 4. Implementing Pipelining #
