# Team 23

**Note for examiner**
* folder rtl contains failed attempt for implementing RV321 for our own machine code
* folder rtl2 contains successful files for implementing RV321 for our own machine code
* folder pipelining contains ...


**Github repo master:** Hanbo

**Editor & writeup:** Anish

# Summary of our approach (needs to be edited at the end) #
1. **Planning Single-Cycle RV321 Design**: We looked at our working design of Lab 4 and made note of differences in design to the final project. We then wrote down all the new changes we needed to make and assigned it.
2. **Implementing RV321 Design (For our own machine code)**: We then documented the changes we made, each of us contributing to the writeup of the task we completed. 
3. **Implementing Pipelining**: Made initial changes (and planned diagram), added 4 flip-flops, debugged and tested for our own machine code.
4. **Implementing RV321 Design (For Reference Program)**

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

<img width="700" alt="image" src="https://user-images.githubusercontent.com/69715492/205524118-b47edd9a-36bd-4335-912b-f155458627d5.png">


# 2. Implementing RV321 Design (For Team Code) #
For this stage of the project, we are all committing directly to the main branch. Since we are all working on individual modules, there won't be conflicts.

We delegated the tasks modularly:

* **Creating Machine Code**: *Entire team*
* **ALU**: *Diyang*; adding load immediate instruction into ALU
* **Control Unit**: *Pengyuan*; implementing control signals for JAl and Load/Store instructions plus jump and return multiplexers
* **Data Memory and Trigger Multiplexer**: *Anish*; created data memory module and trigger multiplexer
* **Top-level module checks and Testing**: *Hanbo*; ensuring variable names are consistent, debugging, simulating on GTK wave and checking that machine code works

## Creating Machine Code ##
Working together, we devised the following machine code: 

<img width="1000" alt="image" src="https://user-images.githubusercontent.com/69715492/205523581-99092f7e-366d-4db3-82bd-83c75c2459d6.png">

Understanding value in s10 (affected by TRIGGERSEL):

<img width="700" alt="image" src="https://user-images.githubusercontent.com/69715492/205524215-d20d5b89-de3a-4d5e-b5aa-3488bca13f44.png">

Visualising the code:

<img width="300" alt="image" src="https://user-images.githubusercontent.com/69715492/205523623-83de2227-cbae-41fd-8c02-9a4c03533594.png">

**EDIT: having debugged, we now find that adding the Trigger Multiplexer causes issues with our load/store instructions. As we can see from the diagram, when the button has not been pressed, TRIGGERSEL = 0, bypassing the entire data memory. To quickly ensure that our architecture still works when excluding the Trigger, we swapped the connection is the trigger multiplexer and used the following machine code:**

<img width="450" alt="image" src="https://user-images.githubusercontent.com/69715492/206568737-fea95457-b2e5-450b-8e81-e8efd493852b.png">

**FINAL NOTE: All the images of our altered diagram should have the Trigger Multiplexer's connections swapped.** 

## ALU ##

Here is the work done to implement the instructions for ALU:

<img width="500" alt="image" src="https://user-images.githubusercontent.com/69715492/206415370-461033bf-37f3-47a6-adad-67aa61d8e2ab.png">

## Control Unit ##

*__graph note: X represents don't care.__*

*__TRIGGER MUX IS NOT USED IN FINAL VERSION__*

### 1. Implement Immediate type (Op = 7'b0010011)
R-type instruction should do some ALU operation with rs1 and Sign-extended Immediate and store it into the destination register rd. 
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform I-type instruction. (Orange Line)
<p align="center"> <img width="600" height = "500" alt="image" src="/image/I-Type.jpg" > </p><BR>

### 2. Implement Load Word (Op = 7'b0000011)
Load word instruction should load the value of (memory address: [value in register file (rs1) + Immediate]) into destination register rd. 
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform load word. (Orange Line)
<p align="center"> <img width="600" height = "500" alt="image" src="/image/load_word.jpg" > </p><BR>

### 3. Implement Store Word (Op = 7'b0100011)
Store word instruction should store the value of register file rs2 to (memory address: [value in register file (rs1) + Immediate]).
Next cycle = PC + 4.
<p align="center"> <img width="600" height = "500" alt="image" src="/image/store_word.jpg" > </p><BR>

The following graph shows how the control unit signals controls the entire program to perform store load. (Orange Line)

### 4. Implement Register type (Op = 7'b0110011)
R-type instruction should do some ALU operation with rs1 and rs2 and store it into the destination register rd. 
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform R-type instruction. (Orange Line)
<p align="center"> <img width="600" height = "500" alt="image" src="/image/R-Type.jpg" > </p><BR>

### 5. Implement Branch Equal (Op = 7'b1100011)
Branch Equal instruction should compare two register value rs1 and rs2. If they are equal, next cycle jumps to PC + Immediate.

The following graph shows how the control unit signals controls the entire program to perform BEQ. (Equal ? Orange Line : Purple Line)
<p align="center"> <img width="600" height = "530" alt="image" src="/image/branch_equal.jpg" > </p><BR>

### 6. Implement Jump and Link Register or Return (Op = 7'b1100111)
Jump and Link instruction should obtain two goals. 
1. The counter should jump to register file rs1 + immediate, normally (return address value ra + Immediate).
2. return address register ra (0x01) should store the address of the next cycle (current PC + 4)

The following graph shows how the control unit signals controls the entire program to perform jump and link register.
Orange line performs the first goal.
Purple line performs the second goal.
<p align="center"> <img width="600" height = "500" alt="image" src="/image/jump_and_link_register.jpg" > </p><BR>

### 7. Implement Jump and Link (Op = 7'b1101111)
Jump and Link instruction should obtain two goals. 
1. The counter should jump to current PC value + Immediate
2. return address register ra (0x01) should store the address of the next cycle (current PC + 4)

The following graph shows how the control unit signals controls the entire program to perform jump and link.
Orange line performs the first goal.
Purple line performs the second goal.
<p align="center"> <img width="600" height = "550" alt="image" src="/image/jump_and_link.jpg" > </p><BR>

### 8. Implement Load Upper Immediate (Op = 7'b0110111)
Load Upper Immediate instruction should load the {20 bit immediate, 12'b0} into destination register rd.
Next cycle = PC + 4.

The following graph shows how the control unit signals controls the entire program to perform LUI. (Orange Line)
<p align="center"> <img width="600" height = "550" alt="image" src="/image/load_upper_immediate.jpg" > </p><BR>


### Main Decoder Table:
<p align="center"> <img width="1000"  alt="image" src="/image/main_decoder.png" > </p><BR>
  
### ALU Decoder Table:
<p align="center"> <img width="1000"  alt="image" src="/image/ALU_decoder.png" > </p><BR>
  
### Sign Extension Table:
<p align="center"> <img width="1000" alt="image" src="/image/Sign_extend_table.png" > </p><BR>
  
## Data Memory and Trigger Multiplexer ##
To implement this part of the diagram:

<img width="650" alt="image" src="https://user-images.githubusercontent.com/69715492/205657403-f537a965-a0ce-4cee-ad0c-cddad9dfcb57.png">

I created the data memory module:
  
<img width="400" alt="image" src="https://user-images.githubusercontent.com/69715492/205657566-42f1e839-1761-4426-bae9-ffe70a26ab92.png">

And made the relevant changes to the top-level module:
  
<img width="500" alt="image" src="https://user-images.githubusercontent.com/69715492/205657959-eff001e3-7c11-482c-92c6-49e8a3371108.png">

## Miscellaneous Changes ##
**Changing number of addresses in instruction memory and data memory:**

<img width="250" alt="image" src="https://user-images.githubusercontent.com/69715492/205651392-47f099cd-d671-482f-86c7-e90a06c45245.png">

This tells us:
* Data memory is (00000 to 1FFFF) = 131072 addresses = 2^17 addresses
  
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/69715492/205653093-2482f388-e6ba-4ea2-94c8-8bd36123258c.png">

  
* Instruction memory is (000 to FFF) = 4096 addresses = 2^12 addresses
  
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/69715492/205653229-e3545dde-71f1-4bd1-a2f0-0d2bee2cd398.png">


## Top-level module checks and Testing ##
While debugging we identified the following issues with our code:
* Some minor syntax errors
* For Jump/Branch type instructions the concatenation in the sign-extend module was incorrect
  <img width="500" alt="image" src="https://user-images.githubusercontent.com/69715492/206418713-da0a2eda-4655-4a1d-8cf1-19fc5d1f5a69.png">
* We had some inconsistencies with bit widths between the top-level module and the control unit 
  
**We have successfully implemeted RV321 with our own program. All the files for this are in folder rtl2**

# 3. Implementing Pipelining #
## Initial Changes ##
<img width="600" alt="image" src="https://user-images.githubusercontent.com/69715492/206428450-1f6a8ad3-4965-43c2-ada9-2ab15996b618.png">

* In order to implement the first flip-flop (connected to instruction memory), we had to change our architecture to no longer have a top-level module for the program counter components. *File PC_top has to be removed.* Instead we add that code directly to the top level module:
  
  <img width="600" alt="image" src="https://user-images.githubusercontent.com/69715492/206432170-0462d4cf-84d3-46ad-8306-8a589c022f17.png">

* Then we realised there is a disparity between our control signals and the diagram provided. Thus we also changed our control unit. 
  1. The control unit in single cycle version controls PCsrc directly. However, it is now controlled by both branch and jump logic. This is due to the zero signal cannot feedback to the control unit as they are now excuting asynchronously. Thus, we add two new logic of Branch and Jump.
  2. To perfrom jump instruction, we use MUXJUMP and JUMPRT in previous version. In this new version, we keep the two control signals and make them go through all flipflops because they are used in the last stage of the machine.
  3. The diagram provided can only implement branch eqaul. In our new version, we add another control signal called BranchMUX to controls PCsrc signal to be 1 or zero depending on funct3 (beq or bne).  
  
  ![b85f91011e03a511967e1c536b2daa7](https://user-images.githubusercontent.com/106196514/206676978-5aad2ac0-0ada-4c98-a711-bfdd100c435b.png)
  
* Finally we realised our architecture had the "Return multiplexer", which connects Result to PC Target. With this new pipelined version, we realised PCTarget needs to be extended through two flip-flops to get PCTargetW.
* We settled on this diagram, to implement pipelining:

<img width="700" alt="image" src="https://user-images.githubusercontent.com/69715492/206700038-34f7117a-52e2-4777-9af3-36a46d27cc94.png">

## Adding the 4 Flip-Flops ##
For the 4 Flip-Flops, we create four separate modules for each of them. Each have a bunch of inputs and outputs following the architecture. Then, there is a always_ff @(posedge clk) that upadtes output with input at positive clock edge. A demonstration of one of the flip-flop is given below.

<img width="200" alt="image" src="https://user-images.githubusercontent.com/69715492/206700108-054e0e57-f527-499f-aedc-7b31bd14ce71.png">

## Top level module and Testing ##
**To make the top-level**
* We added all the new internal signals, for example:
  
  <img width="200" alt="image" src="https://user-images.githubusercontent.com/69715492/206701511-30b1448f-be32-42cf-a699-924df9f05c04.png">

* We also added the new modules and matched them with the relevant signals, for example:
  
  <img width="200" alt="image" src="https://user-images.githubusercontent.com/69715492/206701575-b058749d-34ec-44b4-b372-48c508848aa1.png">

* To test we used the following machine code:
  <img width="700" alt="image" src="https://user-images.githubusercontent.com/69715492/206701410-7daa3f93-ccdb-4b00-9a74-8296ca523056.png">
  
**While testing we uncovered the following errors**
* We had not updated the select lines in the multiplexers to the delayed signals
* Our machine code had 0x10 immediate when it should have been 0xa
* Our machine code did not have NOPs
* We had not updated the inputs to modules like ALU and Data Memory with the new input signals

# 4. Implementing RV321 Design (For Reference Program) #

# 5. Implementing Caching #
## Planning
We design our data cache system for spatial locality.
C = 8 words
Block size: 4
Blocks needed: 2
To accomodate temporal locality, the current used value will be stored in data cache.

### Miss rate calculations
2/8 = 25% for each subroutine
Both misses are compulsory misses due to first time fetch.

## Implementation
We first check if there is desired cached data in our desired memory address, if so, load cached data into register file.
If not, we store the current value along with 3 other spatially related values in a set in data cache.
