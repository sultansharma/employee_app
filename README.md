# Employee App

A Flutter-based employee management application with local database storage and state management.

---

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

---

## 📌 Features

- ✅ **Employee List Management**: View and manage a list of employees.
- ✅ **Add, Edit, and Delete Employees**: Easily modify employee records.
- ✅ **Start Date & Optional End Date Selection**: Pick dates with past days disabled.
- ✅ **Local Database for Offline Storage**: Store data locally using Isar.

---

## 🛠️ Tech Stack

- **Database**: [Isar](https://isar.dev/) - A fast, local NoSQL database for Flutter (mobile only).
- **State Management**: [BLoC/Cubit](https://bloclibrary.dev/) - For efficient state handling.
- **Icons**: [flutter_svg](https://pub.dev/packages/flutter_svg) - Lightweight SVG icon support.
- **Responsive UI**: [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) - Adaptive design across screen sizes.

---

## ⚠️ Known Issues

- **Web Compatibility**: The latest version of Isar is not fully compatible with Flutter Web, limiting database functionality on browser platforms. Mobile versions (iOS/Android) work as expected.

---

## 📋 Getting Started

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) (latest stable version)
- Dart SDK
- A code editor (e.g., VS Code or Android Studio)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/employee-app.git