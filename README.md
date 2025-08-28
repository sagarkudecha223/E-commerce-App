# 🍔 Flutter E-Commerce Food Delivery App

A modern and scalable **Flutter-based food delivery app** powered by **BLoC**, **Firebase Authentication**, **Realtime Database**, and **Cloud Firestore**.

🚧 **Status:** Work in Progress (Development Phase)

---

## 📱 Download APK

👉 [**Download Latest APK**](https://drive.google.com/file/d/16D9ypehDwdgTSu8Z9W2NuRlhXLdu1JvW/view?usp=sharing)

> You may need to enable **"Install from unknown sources"** on your device.

---

## 🖼️ App Screenshots

📸 [**View App Screenshots**](https://drive.google.com/drive/folders/1qlaeV9rCtbCIUDHglvbovK8ZM54t5xvw?usp=drive_link)

---

## ✨ Features (Planned & In Progress)

### 🔐 Authentication
- [x] **Email & Password Login / Sign Up**
- [x] **Google Sign-In**
- [ ] Password Reset
- [ ] Phone Authentication

### 🏠 Home Screen
- Bottom navigation bar with:
  - 🛒 **Shop**
  - 🔍 **Explore**
  - 🧺 **Cart**
  - ❤️ **Favorites**
  - 👤 **Profile**

- **Drawer Navigation** with:
  - Orders
  - Settings
  - Help & Support
  - Logout
  - etc.

### 🍱 Food Categories (Tabs)
- Snacks
- Meals
- Vegan
- Desserts
- Drinks

### 🧾 Item Card Functionality
- [x] Add to Cart
- [x] Add to Favorites
- [ ] Product Details Modal/View
- [ ] Quantity Selector
- [ ] Availability Status

### 🛒 Cart Management
- View items in cart
- Remove items
- View total price
- (Coming soon) Checkout flow

---

## 🧠 State Management

This app uses the **BLoC pattern** (`flutter_bloc`) for clean and scalable state management.

### Blocs Used:
- `AuthBloc` – Handles login, signup, and auth state
- `CartBloc` – Manages cart items and total price
- `FavoritesBloc` – Manages favorite items
- `FoodBloc` – Fetches food categories and items
- `NavigationBloc` – Controls bottom nav state

---

## 🔥 Firebase Integration

### Firebase Services:
- **Authentication**: Email/password and Google Sign-In
- **Realtime Database**: Cart and favorite storage (sync across devices)
- **Cloud Firestore**: Food item catalog, categories, dynamic updates

---

## 📦 Tech Stack

| Technology       | Purpose                              |
|------------------|--------------------------------------|
| Flutter          | UI development                       |
| Firebase         | Backend services                     |
| flutter_bloc     | State management                     |
| firebase_auth    | Authentication                       |
| cloud_firestore  | Product data storage                 |
| firebase_database| Cart and favorites sync              |
| google_sign_in   | Google login support                 |

---

## 🧱 Folder Structure

