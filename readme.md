# SRpaint

SRpaint is a flexible DOS drawing program, designed for the 8086 processor and written in MASM assembly. It supports adjustable brush widths and heights

 <tr> <td><img src="https://github.com/user-attachments/assets/3d1ddb6c-3e0c-48d1-8adf-3449a733c0bb" alt="shrek" height="150"></td> <td><img src="https://github.com/user-attachments/assets/b0d541ce-9702-40a3-b467-61040bdc6b78" alt="kanji" height="150"></td> <td><img src="https://github.com/user-attachments/assets/66e5daf9-a278-4fed-a769-b68d02adbd90" alt="abstract art" height="150"></td> </tr> </table>

---

## User Manual

- **To launch the program**:  
  Download `paint.exe` and insert it into your chosen DOS emulation/installation (e.g., DOSBox).  

- **Controls**:  
  - Left mouse click: Draw  
  - Right mouse click: Change color to the cursor position

- **Keybinds**:

    | key | action                 |
    |-----|------------------------|
    | `Q` | Quit                   |
    | `I` | Decrease brush height* |  
    | `O` | Increase brush height* |  
    | `K` | Decrease brush width*  |
    | `L` | Increase brush width*  |
    | `C` | Clear screen           |
    | `A` | Square mode            |
    | `S` | Vertical brush mode    |
    | `D` | Horizontal brush mode  |

> *Affects both width and height in square mode

- **explanation of modes**:
  - Each mode has a different default brush shape. Any changes to the shape will persist after switching modes, while it's preview remains the same.

## How to Build the Program?

1. Install MASM 6.11  
2. Run the following commands to compile:  

   ```bash
   masm paint.asm;
   link paint.obj;

## MASM

For a refferance on how the interrupts work I recommend [this site](http://www.ctyme.com/intr/int.htm) alongisde wikipedia for when the interrupt description is too vague.

For learning the basics of masm, I recommend masm 6.0 programmer's guide.

The best DOS tool for analyzing assembly code is insight

## Version History
- V0.8 -> first version published to this repository; written in nasm .com files
- V0.9 -> rewriting the same code for masm .exe files, dividing the code into PROCs for readability and minor improvements.
