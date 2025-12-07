🐍 Snake Game – MASM Assembly (Irvine32)

A classic Snake Game built entirely in MASM x86 Assembly using the Irvine32 library.
This project was developed collaboratively by Uzair & Rahul, with a focus on understanding low-level programming, real-time logic, and interactive console design.

🎮 Features
✅ Gameplay Features

Real-time Score & High Score tracking

Smooth snake movement with proper boundary & self-collision logic

Random apple generation

Multiple difficulty levels (Easy, Medium, Hard)

Skip-Time (speed boost) for fast-paced gameplay

⏸ Control Features

Pause & Resume functionality

Responsive keyboard handling

Clean, interactive UI in console mode

📁 Technical Features

File handling to store & load High Scores

Efficient memory & register usage

Optimized loops for smooth runtime

Fully structured Assembly code

🛠 Tech Stack

MASM (Microsoft Macro Assembler)

Irvine32 Library

x86 Assembly

Windows Console

📌 Project Structure
📦 Snake-Game-Assembly
 ┣ 📜 snake.asm
 ┣ 📜 apple.asm   (if modularized)
 ┣ 📜 score.txt   (stores high score)
 ┣ 📜 README.md
 ┗ 📁 assets (if any)

🎯 How to Run

Install MASM + Irvine32 setup

Place Irvine32.inc, Irvine32.lib, and kernel32.lib in your project directory

Compile using:

ml /c /coff snake.asm
link /SUBSYSTEM:CONSOLE snake.obj Irvine32.lib


Run the generated .exe

👥 Team

Uzair Ibrahim – Logic design, coding, debugging, score system

Rahul – Movement logic, collision handling, UI improvements

🌟 What We Learned

Building this game in Assembly challenged us to work with:

Low-level CPU operations

Precise memory control

Efficient branching & looping

Debugging at instruction level

Assembly teaches you that every instruction matters 💻✨

🎬 Demo

(Add screenshots or GIF here)

📄 License

This project is open-source. Feel free to fork and improve it!
