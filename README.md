# 🐍 Snake Game – MASM Assembly (Irvine32)

A classic **Snake Game** built using **MASM x86 Assembly** and the **Irvine32 library**.  
Developed collaboratively by **Uzair & Rahul**.  
This project focuses on real-time logic, low-level programming, and interactive console design.

---

## 🎮 Features

### ✅ Gameplay Features
- Real-time **Score** & **High Score** tracking  
- Smooth snake movement  
- Random **apple spawning**  
- Accurate boundary & self-collision detection  
- Multiple **difficulty levels** (Easy, Medium, Hard)  
- **Skip-Time** (speed boost) feature  

### ⏸ Control Features
- Pause & Resume system  
- Responsive keyboard input  
- Clean console UI  

### 📁 Technical Features
- File handling for storing/loading high scores  
- Efficient register and memory usage  
- Optimized loops for smooth runtime  
- Modular and structured assembly code

---

## 🛠 Tech Stack
- **MASM (Microsoft Macro Assembler)**  
- **Irvine32 Library**  
- **x86 Assembly**  
- **Windows Console**

---

## 📁 Project Structure
```
📦 Snake-Game-Assembly
 ┣ 📜 snake.asm
 ┣ 📜 apple.asm      (optional if modularized)
 ┣ 📜 score.txt      (stores high score)
 ┣ 📜 README.md
 ┗ 📁 assets         (if any)
```

---

## 🚀 How to Run
1. Install **MASM** and set up the **Irvine32 library**  
2. Ensure `Irvine32.inc`, `Irvine32.lib`, and `kernel32.lib` are available  
3. Compile using:
   ```
   ml /c /coff snake.asm
   link /SUBSYSTEM:CONSOLE snake.obj Irvine32.lib
   ```
4. Run the generated `.exe`

---

## 👥 Team
- **Uzair Ibrahim** – Game logic, score system, debugging  
- **Rahul** – Movement logic, collision system, UI improvements  

---

## 🌟 What We Learned
Working on this project strengthened our understanding of:
- Low-level CPU operations  
- Register manipulation  
- Optimized loops & branching  
- Debugging at instruction-level  
- How real-time programs work under the hood  

Assembly teaches you that **every single instruction matters**.

---

## 🎬 Demo
(Add screenshots or GIF here)

---

## 📄 License
Open-source project — feel free to fork, modify, and improve!

