Here is a complete `README.md` file describing everything you've built in your Flutter + SQLite wardrobe app:

---

```markdown
# 🧥 MyWardrobe App

MyWardrobe is a Flutter app that allows users to manage a digital wardrobe by adding, editing, picking, and deleting items of clothing. The app uses SQLite for local storage and persists data even after the app is closed.

---

## 🚀 Features

- 🏠 **Home View**
  - Displays all added items in a grid layout.
  - Filters by color and search keywords.
  - “Pick” button adds an item to the cart.
  - Each item includes buttons to:
    - ✏️ Edit item
    - 🗑️ Delete item

- 🛒 **Cart View**
  - Shows only "picked" items.
  - Each item includes:
    - ✏️ Edit item
    - ❌ Remove from cart (without deleting)

- ➕ **Add Item View**
  - Uploads image from gallery.
  - Adds name, color, type.
  - Saves image permanently in app storage.
  - Persists data in SQLite.

- ✏️ **Edit Item View**
  - Loads existing item data.
  - Allows updating name, color, type, and image.

- 👤 **Profile View** (Placeholder)
- ❤️ **Favorites View** (Placeholder)
- 🧭 **Bottom Navigation Bar**
  - Available on Home, Cart, Add, Edit, and Profile screens.

- 🌙 **Theme Support**
  - Light & Dark modes using custom `AppColors`.
  
- 🎬 **Splash View**
  - Displayed before navigation to RootPage.

---

## 🧱 Folder Structure

```

lib/
├── core/
│   └── utils/
│       └── app\_colors.dart
├── features/
│   ├── data/
│   │   ├── db\_helper.dart
│   │   └── item\_model.dart
│   └── view/
│       ├── home/
│       │   ├── home\_view\.dart
│       │   ├── add\_item\_view\.dart
│       │   ├── edit\_item\_view\.dart
│       │   └── favorite\_item\_view\.dart
│       ├── cart/
│       │   └── cart\_view\.dart
│       ├── profile/
│       │   └── profile\_view\.dart
│       └── splash/
│           └── splash\_view\.dart
├── root/
│   └── root\_page.dart
├── main.dart

````

---

## 🧠 Data Model

**ItemModel** contains:
- `id`: int (Primary key)
- `name`: String
- `color`: String
- `type`: String
- `imagePath`: String (Local file path)
- `isPicked`: int (0 = not picked, 1 = picked)

---

## 🗃️ SQLite Database

- **Table**: `items`
- **Helper**: `DBHelper` class
- Methods:
  - `insertItem()`
  - `getAllItems()`
  - `getPickedItems()`
  - `searchItems()`
  - `updateItem()`
  - `deleteItem()`
  - `removeFromCart()` ✅ NEW

---

## 📦 Dependencies

Ensure you have these in your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite:
  path:
  image_picker:
  go_router:
  path_provider:
````

---

## 🛠️ How to Run

1. Clone the project
2. Run `flutter pub get`
3. Run `flutter run` on emulator or real device
4. Add items, edit, pick to cart, or delete them!

---

## 🔥 Next Ideas

* Add Firebase sync or auth.
* Add tagging and filtering.
* Add sorting by recently added.
* Add animations and loading placeholders.

---

## 👤 Developed by

**Riyam Hazim** – Flutter + Django Developer
Learning UI/UX and AI integration for meaningful apps 💡

```

Let me know if you'd like this saved as a file or want a downloadable version.
```
