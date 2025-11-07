# Countries Flutter App

A Flutter application samples with **Clean Architecture** and **MVVM** that allows users to browse, search, and learn about countries around the world. The app fetches data from the [REST Countries API](https://restcountries.com/) and presents it in a clean, user-friendly interface.

## Features

- **List Countries**: View a comprehensive list of countries in a responsive grid layout.
- **Search Functionality**: Dynamically search for countries by their name, capital city, or country code.
- **Detailed View**: Tap on a country to see more details, including its official name, population, region, languages, and more in a modal view.
- **Dark/Light Mode**: Seamlessly switch between dark and light themes. The selected theme is persisted across app launches.
- **Error Handling**: Displays user-friendly messages for network errors or when no search results are found.
- **Loading Indicators**: Shows a loading spinner while fetching data.
- **Offline Mode**: Load data including flag image cache from local storage if available.

## Screenshots

**Mobile App**

<p align="center">
  <img src="screenshots/home_light_app_1.png" alt="App Light 1" height="400"/>
  <img src="screenshots/home_light_app_2.png" alt="App Light 2" height="400"/>
  <img src="screenshots/home_dark_app_1.png" alt="App Dark 1" height="400"/>
  <img src="screenshots/home_dark_app_2.png" alt="App Dark 2" height="400"/>
</p>

**Web and Desktop**

<p align="center">
  <img src="screenshots/home_light_web_1.png" alt="App Light 1" width="400"/>
  <img src="screenshots/home_light_web_2.png" alt="App Light 2" width="400"/>
  <img src="screenshots/home_dark_web_1.png" alt="App Dark 1" width="400"/>
  <img src="screenshots/home_dark_web_2.png" alt="App Dark 2" width="400"/>
</p>

## Tech Stack & Architecture

This project follows the principles of **Clean Architecture** to create a scalable and maintainable codebase. The code is separated into three main layers: Data, Domain, and Presentation (Features).

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management & DI**: [GetX](https://pub.dev/packages/get)
- **Architecture**: Clean Architecture (Data, Domain, Presentation)
- **Networking**: [Dio](https://pub.dev/packages/dio) & [Retrofit](https://pub.dev/packages/retrofit) for type-safe API calls.
- **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart) for robust error handling.
- **Local Storage**: [get_storage](https://pub.dev/packages/get_storage) for persisting the theme preference and data from API.
- **Cache Images**: [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)
- **Code Generation**: [build_runner](https://pub.dev/packages/build_runner), [json_serializable](https://pub.dev/packages/json_serializable).
- **Testing**: [flutter_test](https://pub.dev/packages/flutter_test), [mockito](https://pub.dev/packages/mockito) for unit testing.

## Project Structure

```
lib/
├── core/              # Core utilities, DI, extensions, theme, widgets
├── data/              # Data layer: API services, models, repositories
│   ├── models/
│   ├── network/
│   └── repositories/
├── domain/            # Domain layer: entities, use cases, repository contracts
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── features/          # Presentation layer: UI (pages, widgets) and ViewModels
│   ├── home/
│   └── initializer/
└── main.dart          # App entry point
```

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flutter SDK (version 3.8.1 or higher)
- A code editor like VS Code or Android Studio

### Installation

1.  **Clone the repository:**

    ```sh
    git clone https://github.com/budinormansyah/countries-flutter-mvvm.git
    cd countries
    ```

2.  **Install dependencies:**

    ```sh
    flutter pub get
    ```

3.  **Run the code generator:**

    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```sh
    flutter run
    ```
