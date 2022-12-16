# Summary of what I did #
* I was the **main editor** for the team documentation and at times, took the lead as project manager, arranging meetings and setting team deadlines
* **rtl**: Edited ALU. Led the debugging and helped with testbench
* **rtl2**: Debugged the ALU, changed the TRIGGERSEL multiplexer, helped with debugging the top-level module and helped final testing of new rtl2 design
* **rtl3**: Changed the data memory to include byte and word addressing and led the debugging against the reference code
* **pipelining**: I made the first flip-flop and put everything altogether in the top-level module
* **pipelining2**: I helped change the data memory to include byte and word addressing as well
* **caching**: I helped plan our approach and created the cache_controller module

# Explanations #
During the final year project last year, I led my team as **project manager** and in turn, **editor** of our report. I thoroughly enjoyed the role because I like planning and organising. For this coursework I employed the following things I learned from my experience last year:
* Documenting along as we made progress. It was easy to do lots of lab work without documentation but that leads to having a lot of write-up piled up and the writer forgetting things we had done in that session. Thus, by documenting the work as we went, I made it easy for whoever was doing the write-up to just have a small amount to write after that session and be able to write down all the relevant points while it was still fresh on their mind.
* Arranging regular meeting sessions. This served a few purposes. During team projects it was inevitable for a team member to miss sessions so meetings make it easy to keep everyone up to speed with progress and give a chance for healthy discussion. Furthermore, keeping tabs on progression made it far easier to plan and make deadlines.
* Outlining our aims clearly in bullet points so team members knew exactly what the remaining tasks were. This made it easy for me to coordinate our approach.

For **rtl**, I added the opcode associate with load upper immediate and used the simple assignment operator to implement it. I helped edit the testbench to include the vbdBar() function so we could turn on the F1 lights. And I led our debugging. This involved running GTKWave and checking if the signals matched as the instruction went through the architecture. 

During the debugging we quickly realised we had the following issues:
* Syntax errors
* TRIGGERSEL multiplexer not working because as a result of the additional multiplexer, data memory was being bypassed. Therefore, because of the addition, the load/store instructions were not being implemented.
* Inconsistencies with bit widths between top-level module and control unit
* Incorrect concatenation in sign-extend module.

Making the following changes in **rtl2** was a success. Some of the errors mentioned above were shared between rtl and rtl2. But in the end, after making the right fixes, rtl2 was able to successfully implement our modified machine code.

My module contribution to **rtl3** was editing the data memory so it could implement byte addressing as well. This involved coordinating with Pengyuan to help feed an extra control input into the data memory which specified address mode. Then I split the elements stored in the array from being 32-bits to 8-bits. This meant that for word addressing the output would have to be 4 corresponding byte addresses concatenated together. My approach was successful (except I forgot to add begin-end statements causing issues, which was corrected during debugging). For rtl3 I used the same debugging approach as rtl and rtl2. I also learned a few new method of debugging and some methods to get rid of the warning signs (discussed under next heading).

For **pipelining**, I started off the module addition with the first flip-flop which was straight-forward. But I set the precedent for how the wires were to be labeled. Then once everyone else had finished the other three flip-flops I put it all together in the top-level module. A mistake I made was although I got the connections into the flip-flops correct I did not update the other modules (multiplexer, ALU, data memory) with the delayed signals. This caused issues which were fixed during debugging.

Changes to **pipelining2** were very minor: I replicated the work I had done with rtl3 for the data memory.

To implement **caching** the team had a lengthy discussion which has been documented in our team readme.md file. I then implemented those ideas in the cache_controller module.

# Things I learned #
**Technical Skills**
* Ofcourse I learned the basics of system verilog and designing processor architecture
* But I found the debugging and testing process far more insightful. Initially I learned how to use GTKWave to plot the wavefunctions and identify discrepancies between expectation and result
* In the process I learned to add libraries in VS Code to clean code, always including begin-end statements, especially within if-else
* I learned how to address "bits not used" from a wire
* I learned how to use the $display() function to my benefit for identifying values within the register file and data memory
* I understood additional commands to add to a .sh file to debug
* I got far more comfortable with the command line and GitHub

**Soft Skills**
* Improved team management
* Better at deadlining and organisations
* Better at keeping up a strong online and in-person communication channel
* Better at documentation, clarity and readability with work produced to be used by others
* More teamwork experience
* Improved perseverance and grit during debugging process

**Things I Would Do Differently**

*While implementing*

* There should have been less of a disconnect between people implementing individual modules and person implementing top-level modules. This would've avoided a few unnecessary errors in the beginning
* Ensuring the entire team had a thorough understanding of the entire architecture even if they're only responsible for a specific component. In this way, for later iterations, a different person could take on something someone else had been responsible for with ease.
* More consistent variable names
* Better documentation about wire widths

*While debugging*

* Longer team sessions together. We realised that often it would take an hour or two to just understand the problem that we were debugging before we got a chance to fix it.
* However with those longer sessions in mind, we should've taken more regular breaks. We noticed that the longer we spent on the problem the more silly mistakes we would make with our execution leading to unnecessary errors.
* Have atleast two people together debugging to identify silly mistakes

