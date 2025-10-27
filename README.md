# TaskGrid

A cross‑platform **admin panel** for scheduling tasks and class projects — designed in Figma, implemented with **Qt Quick (QML) + C++**.

## Features (MVP)
- Tasks list (title, due, course, status)
- Week/Month calendar view
- Quick add dialog
- Local persistence (SQLite)
- Light/Dark/Cyber themes

## Build (CMake + Qt 6)
```bash
# macOS (Homebrew)
brew install qt cmake ninja
cmake -S . -B build -G Ninja -DCMAKE_PREFIX_PATH=$(brew --prefix qt)
cmake --build build
./build/TaskGrid

# Windows (MSVC + CMake + Qt)
# Install Qt 6 via Qt Online Installer; set CMAKE_PREFIX_PATH to your Qt install (e.g., C:\Qt\6.7.2\msvc2019_64)
cmake -S . -B build -G "Ninja" -DCMAKE_PREFIX_PATH="C:\\Qt\\6.7.2\\msvc2019_64"
cmake --build build
build\TaskGrid.exe
```

> If Ninja is not installed, use the default generator or "Visual Studio 17 2022" on Windows.

## Run
The app loads QML from `qml/TaskGrid/Main.qml` and connects to the C++ model.

## Contributing
- Create a feature branch: `git checkout -b feature/your-thing`
- Commit small, descriptive changes
- Open a Pull Request to `dev`
- One teammate reviews & merges

## License
MIT
