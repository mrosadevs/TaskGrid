# ⚙️ TaskGrid  

> A sleek, cross-platform **task scheduling admin panel** built with **C++** and **Qt Quick (QML)** — designed in **Figma**, powered by **CMake**, and crafted for both style and structure.  

---

## 🧭 Overview  

**TaskGrid** is a desktop productivity app that brings organization and aesthetics together.  
It helps users schedule, track, and manage tasks or class projects through a **visual dashboard** with **drag-and-drop**, **themes**, and **persistent storage**.  

Built from scratch by a three-person dev team as a Programming II project, TaskGrid showcases collaboration, UI design, and modern C++ architecture.

---

## ✨ Features  

### 🎯 Core (MVP)
- 📝 Add / Edit / Delete tasks  
- 📅 Week / Month calendar view  
- ⚡ Quick “Add Task” dialog  
- 💾 Local data persistence (SQLite)  
- 🎨 Theme system — Light / Dark / Cyber  

### 🚀 Planned / Stretch
- 🖱️ Drag & Drop between task columns  
- 🔍 Search & filter bar  
- 📊 Productivity stats dashboard  
- 🧩 Calendar export (.ics or CSV)

---

## 🧰 Tech Stack  

| Layer | Tool / Tech | Purpose |
|-------|--------------|----------|
| **Language** | C++17 | Core logic and data model |
| **GUI Framework** | Qt Quick (QML) | Front-end design and interaction |
| **Database** | SQLite | Persistent local storage |
| **Build System** | CMake + Ninja | Cross-platform compilation |
| **Design** | Figma | UI/UX prototyping |
| **Version Control** | Git + GitHub | Collaboration & versioning |
| **Docs / Planning** | Notion | Project management |

---

## 🧱 Build Instructions  

### 🖥️ macOS  

<pre><code class="language-bash">
brew install qt cmake ninja
cmake -S . -B build -G Ninja -DCMAKE_PREFIX_PATH=$(brew --prefix qt)
cmake --build build
./build/TaskGrid
</code></pre>

### 🪟 Windows  

<pre><code class="language-bash">
# Install Qt 6 via Qt Online Installer
# Example path: C:\Qt\6.7.2\msvc2019_64
cmake -S . -B build -G "Ninja" -DCMAKE_PREFIX_PATH="C:\\Qt\\6.7.2\\msvc2019_64"
cmake --build build
build\TaskGrid.exe
</code></pre>

> 💡 If Ninja is not installed, remove `-G Ninja` or use `"Visual Studio 17 2022"`.

---

## 🧠 Run  

<pre><code class="language-bash">
./build/TaskGrid
</code></pre>

The app loads its UI from `qml/TaskGrid/Main.qml` and connects to the backend C++ model for logic and data handling.

---

## 🧑‍💻 Team  

| Member | Role | Focus |
|---------|------|--------|
| **Offline** | UI/UX Lead + Integrator | Figma design, QML UI, animations, cross-platform polish |
| **Juan** | Core Developer + System Architect | C++ data models, database logic, and architecture |
| **Daniel** | Developer + UI Logic | Dialogs, signal/slot connections, debugging & testing |

---

## 🧩 Contributing  

<pre><code class="language-bash">
# Make sure you’re on dev
git checkout dev
git pull

# Create a feature branch
git checkout -b feature/&lt;your-feature&gt;

# Work and commit small, descriptive changes
git add .
git commit -m "feat: &lt;short-description&gt;"

# Push and open a Pull Request to dev
git push -u origin feature/&lt;your-feature&gt;
</code></pre>

> 🔒 Rule of thumb:  
> Don’t push directly to `dev` or `main`.  
> Use branches + PRs for every feature.

---

## 🗓️ Project Timeline  

| Phase | Date Range | Focus |
|-------|-------------|--------|
| 🧩 Setup | Nov 5 – 8 | Repo, environment, Figma design |
| ⚙️ Core Dev | Nov 9 – 12 | Task model, add/delete, UI link |
| 🎨 Polish | Nov 13 – 16 | Themes, testing, presentation |
| 🧠 Demo | Nov 17 | Final presentation |

---

## 📜 License  
**MIT License** — free for anyone to use, learn from, and build upon.  

---

### ⭐ Credits  
Built with 💻, ☕, and a lot of teamwork by  
**Offline**, **Juan**, and **Daniel** — *Programming II, Fall 2025*.
