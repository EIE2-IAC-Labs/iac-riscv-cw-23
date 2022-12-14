### Summary list of things I did ###
RTL:
Instruction Memory (mostly from lab 4, added machine code to mem)
Top level module and testbench file (raised the issues with our initial version)

helped Diyang with program counter

RTL2:
Top level module (Fixes for RTL such as adding address widths)
helped with ALU (testing and checking for errors)

RTL3:
Top level sv and testbench file (make sure variable names are consistent, add/remove wires as needed, initialise testing environment)

Pipelining:
Flipflop 3 (Simple flipflop with the necessary wires)
helped with top level module and debugging

Pipelining2:
Changed Data Memory to enable byte and word addressing

Data Caching:
Led planning of how data caching should be implemented and looked at implementations for both F1 and reference program.

Note: If we were to incorporate a special feature, such as byte and word addressing modes for the data memory, we would first consult with the team to ensure that everyone agrees. We would then implement the change and communicate so that it is reflected in other relevant modules, such as the top-level module where new wires may need to be added. This approach ensures that our changes are efficient, consistent and coordinated across the project.

### Things I learned ###
At the beginning of the project, I discovered that using branching made it easy to keep track of the different versions of the project. However, upon further consideration, I realized that due to our clear division of tasks and effective teamwork, we could simply commit directly to the main branch. This approach offers several advantages, as outlined in the project's readme.

One of the key lessons I have learned from this project is the importance of working together in person. Initially, we did much of our testing and work remotely. As the person responsible for creating the top-level modules, I had to communicate with each team member and coordinate their efforts, which often resulted in long delays and misunderstandings. However, when we began working together in the same physical space, these issues were greatly reduced. It became much easier to communicate and coordinate our efforts, and we were able to identify and resolve any problems quickly and efficiently.

Another I encountered during this project was the time-consuming and difficult process of debugging. Even when the code and modules appeared to be error-free, issues would still arise. As we progressed, we improved our skills and became more efficient at identifying and resolving errors.

Finally, on a more technical note, we learned that while sending code to be pushed by someone else may seem cumbersome, the lightweight nature of this project and the different requirements for the CPU made this approach beneficial. It allowed us to avoid risks such as encountering conflicts when merging or accidentally rewriting commits. This decision saved us a significant amount of time and I am glad that we were able to adopt it early on in the project.

If given the opportunity to complete this project again, I would ensure that the team works together in person from the very beginning. This would enable us to coordinate our efforts more effectively and allow for more time to be dedicated to debugging. Additionally, since we now have experience using tools like gtkwave and know what to look for when debugging, we would be able to complete the project more quickly and efficiently.

Overall, it was very enjoyable to work as a team and work on different parts of the CPU, I definitely gained a lot of valuable experience.

### Explanations ### 

The RTL was designed to implement the F1 code. Given the many possible ways to implement the F1 sequence, we held a team meeting to decide on the machine code. The CPU we used for this project is similar to the one we created in Lab 4, so we were able to reuse most of the files. The instruction memory module was copied directly from Lab 4 and only required the .mem file to be filled with the correct machine code for our instructions. I used an online converter to generate the machine code, and Diyang helped me verify that the conversion was correct. I also created the top-level module and testbench to connect all the modules together. Anish performed initial debugging and testing when we were all working together in the lab.

During the development of this project, I considered adding a multiplexer called trigger select to the top-level module, which would allow the F1 program to count up when the trigger line is high (i.e., when the button is pressed). However, we learned that adding a trigger multiplexer to our CPU caused issues with the load/store instructions. We quickly created a new iteration of the CPU (rtl2) to address these issues. I revised the Top.sv module to include bug fixes, such as adding [2:0] to the widths of the wires. I also assisted Anish with verifying the changes to the ALU.

For RTL3, which was needed to implement the reference program, only minor changes were necessary, such as removing unused wires and adding inputs like addr_mode. The testbench did not require many changes either.

For the pipelining of the F1 program, each team member implemented one flip flop, and I was responsible for the third flip flop between the execute and memory cycles. The module was straightforward, and I simply needed to ensure that the inputs and outputs had the correct wires and widths. I also helped with the top.sv file and debugging, as we worked on this together as a team.

For the pipelining of the reference program, I made changes to the data memory module to enable word and byte addressing. This was necessary to avoid using 2^32 addresses when loading data, as Anish had done in rtl3.

I led the planning for data caching and contributed to the development of the cache controller, which is described in more detail in the readme file.