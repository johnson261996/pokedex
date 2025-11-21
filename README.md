# 🧩 Pokédex Flutter App

A beautifully designed Flutter application that displays detailed Pokémon information using the PokéAPI. Users can browse Pokémon, view stats, filter by type, and enjoy a smooth, responsive UI across Android and iOS devices.

---

## 🚀 Features

* 📃 **Pokémon List** with images and types
* 🔍 **Search** by name or ID
* 📊 **Stats, abilities, height, weight** and more
* 🔄 **Pull to refresh**
* 🎨 **Modern UI with animations**
* ⚡ **Fast API integration** (PokéAPI)
* 📱 **Responsive layout** for all screen sizes
* 🌙 **Dark theme support**
* 📦 **Hive** Local storage for Favorites

---

## 📸 Screenshots

Home            |  Favourite | Details
:-------------------------:|:-------------------------:|:-------------------------:
![screenshot](assets/screenshots/home.jpg) |  ![screenshot](assets/screenshots/favourite.jpg) | ![screenshot](assets/screenshots/details.jpg)



---

## 🏗 Project Structure

```
lib/
 ├── main.dart
 ├── app/
 │     ├── bindings/
 │     ├── controllers/
 │     ├── routes/
 │     └── views/
 ├── data/
 │     ├── models/
 │     ├── providers/  (network calls)
 │     └── repositories/
 └── utils/


```

---

## 🔧 Installation & Setup

### 1️⃣ Clone the repository

```bash
git clone https://github.com/your-username/pokemonapp.git
cd pokemonapp
```

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Run the app

```bash
flutter run
```

---

## 🌐 API Used

This app uses the official free Pokémon API:

👉 [https://pokeapi.co/](https://pokeapi.co/)

---

## 📚 Packages Used

* `dio` — API calls
* `get` — state management
* `connectivity_plus` —  to discover network connectivity types that can be used.
* `Hive` — Local storage
---

## 📦 Build Release

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```


### Windows

```bash
flutter build windows --release
```
---

## 🤝 Contributing

Feel free to submit issues or pull requests to improve the project.

---

## 📄 License

This project is licensed under the MIT License.





