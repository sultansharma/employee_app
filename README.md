# Employee App

A Flutter-based employee management application with local database storage and state management.

---
![App Screenshot](/screenshot.png)
![App Screenshot](/screenshot2.png)

## 🚀 Project Timeline

### Day 1: Initial Setup
- Completed basic project structure.
- Integrated local database using Isar.

### Day 2: UI & Database Functionality
- Finished nearly all UI components.
- Successfully implemented database operations (Add/Delete employees).

### Day 3: Database Functionality
- Core functionality works seamlessly on mobile.
- Encountered issues with the web version due to the latest Isar version not being compatible with Flutter Web.
- Tried Hive but no luck ,After trying many others like drift , sqflite etc. finally **Localstore** worked.
---

## 📌 Features

- ✅ **Employee List Management**: View and manage a list of employees.
- ✅ **Add, Edit, and Delete Employees**: Easily modify employee records.
- ✅ **Start Date & Optional End Date Selection**: Pick dates with past days disabled.
- ✅ **Local Database for Offline Storage**: Store data locally using 'LocalStore'.
- ✅ **Responsive UI**: Also created Desktop and tablet view to make UI more reactive.

---



## 📋 Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- Dart SDK
- A code editor (e.g., VS Code or Android Studio)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/sulatansharma/employee-app.git