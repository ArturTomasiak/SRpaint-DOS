# SRpaint

SRpaint is a flexible DOS drawing program, designed for the 8086 processor and written in NASM assembly. It supports adjustable brush widths and heights

 <tr> <td><img src="https://github.com/user-attachments/assets/b0d541ce-9702-40a3-b467-61040bdc6b78" alt="shrek" height="150"></td> <td><img src="https://github.com/user-attachments/assets/b0d541ce-9702-40a3-b467-61040bdc6b78" alt="kanji" height="150"></td> <td><img src="https://github.com/user-attachments/assets/66e5daf9-a278-4fed-a769-b68d02adbd90" alt="abstract art" height="150"></td> </tr> </table>

> [!NOTE]
> Work in progress; saving, loading and exporting as png is yet to be implemented alongside rewriting the code for masm (as 8086 nasm is limiting)

---

## User Manual

- **To launch the program**:  
  Download `paint.com` and insert it into your chosen DOS emulation/installation (e.g., DOSBox).  

- **Controls**:  
  - Left mouse click: Draw  
  - Right mouse click: Change color to the cursor position  

- **Keybinds**:  
  - `Q`: Quit  
  - `I`: Decrease brush height*  
  - `O`: Increase brush height*  
  - `K`: Decrease brush width*  
  - `L`: Increase brush width*

> *Affects both width and height in square mode
  
  - `C`: Clear screen  
---
Each mode has a different default brush shape. Any changes to the shape will persist after switching modes, while it's preview remains the same.
  - `A`: Square mode  
  - `S`: Vertical brush mode  
  - `D`: Horizontal brush mode

## How to Build the Program?

1. Install an i386 build of NASM.  
2. Run the following command to compile:  
   ```bash
   nasm paint.asm -o paint.com

## NASM

For a refferance on how the interrupts work I recommend [this site](http://www.ctyme.com/intr/int.htm) alongisde wikipedia for when the interrupt description is too vague.
