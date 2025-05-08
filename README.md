# PDF Tailor – A Customizable PDF Reader

> **An offline Flutter-based PDF reader for students, TAs, and educators that enhances readability, accessibility, and productivity.**

## 🚀 Project Overview

PDF Tailor allows users to download, organize, style, and annotate PDF files—offline. Born from the frustrations of black-and-white study materials, this tool aims to enhance readability with features like dark mode, annotation, and intuitive organization.

## 📦 Download the App

You can download the latest version of our application from the **Releases** section of this repository!

## ✨ Key Features

- 🎨 **Background Color Modes** – Light, Dark, and Sepia filters using transformation matrices.
- 📝 **PDF Annotation** – Add, move, resize, and persist text boxes across sessions.
- 📂 **File Management** – Organize PDFs into folders, favorite important documents, and track recent files.
- 🔍 **Zoom Controls** – Keyboard shortcuts + UI buttons for PDF zooming and fitting.
- ⚠️ **Smart File Handling** – Detects deleted files and updates UI accordingly.

## 🧠 Why It Stands Out

Unlike mainstream PDF readers:
- Focused on readability (dark mode and sepia).
- Minimalist and intuitive UI.
- Offline-first with lightweight local storage (HiveDB).
- Tailored to academic workflows (e.g., cheat sheets, lecture annotations).

## 🧱 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: HiveDB (NoSQL local storage)

## 📈 Development Milestones
### Milestone 1: Foundational Features
- **PDF Viewer Integration**  
  Implemented core functionality for reading local PDF files with zoom and scroll.
- **Dark, Light, and Sepia Modes**  
  Developed a transformation matrix algorithm to apply real-time visual filters to PDFs, improving readability.
- **Zoom Controls**  
  Added UI buttons and keyboard shortcuts (`Ctrl +`, `Ctrl -`, `Ctrl 0`) to zoom in, zoom out, and fit to screen.

### Milestone 2: Usability & Storage
- **Favorites and Recent Files Tracking**  
  Enabled users to mark documents as favorites and access recently opened files easily using HiveDB.
- **Directory Picker & File Importing**  
  Integrated OS-level file picker for loading PDFs from local storage.
- **Local Persistence with HiveDB**  
  Introduced schema-based NoSQL storage for maintaining file metadata (favorites, last viewed page, etc.).
- **Persistent UI State**  
  Stored last zoom level and page visited for each PDF session.

### Milestone 3: Annotation & Folder System
- **Text Box Annotations**  
  Implemented drag-and-drop resizable text boxes that persist across sessions.
- **Folder-Based File Organization**  
  Allowed users to group and navigate PDFs by folders for better categorization (e.g., modules, topics).
- **State Restoration**  
  On reopening a file, restored:
  - Last opened page
  - Previous zoom level
  - Background styling mode
  - Text box positions and content
- **File Deletion Handling**  
  Automatically detected deleted files from the system and updated the UI gracefully to prevent crashes.

## 🔐 Software Engineering Principles

- **MVC Pattern** for modularity and maintainability
- **DRY Principle** via component abstraction (e.g., side nav)
- **ClickUp** for project tracking; **GitHub PRs** for team collaboration

## 📎 Links

- 🧠 [Figma Design](https://www.figma.com/file/DT9utFP1LzuFQiio9x30xP/The-PDF-Tailor)
- 🧩 [Database Diagrams](https://app.quickdatabasediagrams.com/#/d/RF7NQk)
- 🌀 [Miro User Flow](https://miro.com/app/board/uXjVMGtjR6s=/?share_link_id=317114513411)

