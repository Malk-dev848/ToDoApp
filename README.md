# 📅 To-Do List App with Image Attachments (Flutter)

## 🚀 Overview

A clean and functional To-Do List app built with Flutter. Users can manage their tasks, attach images, and filter tasks based on status or priority. Supports light/dark themes and stores data locally using Hive.

---

## 📚 Features

* Add, edit, and delete tasks
* Mark tasks as complete or incomplete
* Assign task priorities: Low, Medium, High
* Set due dates
* Attach images from gallery or camera
* View image thumbnails in list view
* Filter tasks by status or priority
* Search tasks by title
* Light/Dark theme toggle
* Local data persistence using Hive

---

## 🔧 Architecture & Design Decisions

### 🔄 State Management

* Used `StatefulWidget` for local screen-level state.
* Simple and efficient for this scale.

### 📂 Data Persistence

* **Hive** used for fast, structured local storage.
* Task model includes title, due date, priority, status, and image path.

### 📷 Image Handling

* Used `image_picker` to allow image selection from both gallery and camera.
* Stored image paths are loaded using `FileImage`.

### 🔍 Filtering & Search

* Tasks filtered via status/priority dropdowns and a search bar.
* Real-time filtering with `ValueListenableBuilder`.

### 🚩 Navigation

* Two main screens:

  * `TaskListScreen`: Lists tasks and manages filters.
  * `AddEditTaskScreen`: Form for adding/editing tasks.

### 🎨 UI/UX

* Clean Material Design layout.
* Responsive UI with basic animations.
* Validations for task fields with helpful error feedback.
* Delete confirmation dialogs and visual cues for actions.

### ⚡ Error Handling

* Form validations ensure title and priority inputs.


---

## 🛋️ Packages Used

| Package         | Purpose                           |
| --------------- | --------------------------------- |
| `hive`          | Local data persistence            |
| `hive_flutter`  | Flutter integration for Hive      |
| `image_picker`  | Select images from gallery/camera |
| `path_provider` | File system paths (optional use)  |

---

## 🚤 Getting Started

```bash
flutter pub get
flutter run
```

Ensure you set up Hive with `flutter packages pub run build_runner build` if using generated adapters.

---

