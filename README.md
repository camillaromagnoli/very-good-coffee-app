# Very Good Coffee App ☕
A Flutter application for discovering and saving random coffee images. Built with Clean Architecture, BLoC pattern and modern Flutter best practices.

## Description

This application allows users to discover random coffee images from the [Coffee API](https://coffee.alexflipnote.dev) and save their favorites locally for offline viewing. The app demonstrates Clean Architecture principles, error handling and a modern Material 3 UI.

### Features

- **Random Coffee Discovery**: Load random coffee images from the Coffee API
- **Save Favorites**: Save your favorite coffee images locally using Hive
- **Favorites Gallery**: View all saved coffee images in a beautiful grid layout
- **Offline Support**: Access your saved favorites even without an internet connection
- **Error Handling**: Graceful handling of loading, error, and empty states with user-friendly messages
- **Modern UI**: Clean, Material 3 design with smooth animations and Lottie loading indicators


## Tech Stack

- **Flutter**
- **Clean Architecture**
- **Get It**
- **Injectable**
- **Flutter BLoC**
- **Dio**
- **Hive**
- **GoRouter**
- **Lottie**
- **Equatable**


## Flutter Version

This project requires **Flutter SDK 3.32.0** or higher (which includes Dart SDK 3.8.1 or higher).

To check your Flutter version:
```bash
flutter --version
```

To upgrade Flutter:
```bash
flutter upgrade
```


## Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (^3.8.1 or higher)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- iOS Simulator or Android Emulator (or physical device)
- Xcode (for iOS development on macOS)
- Android Studio (for Android development)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/camillaromagnoli/very-good-coffee-app.git
   cd very_good_coffee_app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Generate code (for dependency injection and localization):**

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Running Tests 🧪

To run all unit and widget tests use the following command:

```bash
flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```bash
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/
# Open Coverage Report
open coverage/index.html
```

## Working with Translations

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "coffeePageTitle": "Coffee",
    "@coffeePageTitle": {
        "description": "Text shown in the AppBar of the Coffee Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "coffeePageTitle": "Coffee",
    "@coffeePageTitle": {
        "description": "Text shown in the AppBar of the Coffee Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:very_good_coffee_app/core/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "coffeePageTitle": "Coffee",
    "@coffeePageTitle": {
        "description": "Text shown in the AppBar of the Coffee Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "coffeePageTitle": "Café",
    "@coffeePageTitle": {
        "description": "Texto mostrado en la AppBar de la página del café"
    }
}
```

---

## Architecture

This app follows **Clean Architecture** principles with a feature-based folder structure:

```
lib/
├── core/
│   ├── design/          # Reusable widgets and design tokens
│   ├── di/              # Dependency injection setup
│   ├── errors/          # Exceptions and failures
│   ├── l10n/            # Localization setup
│   ├── routes/          # App routing configuration
│   ├── usecases/        # Base use case interface
│   └── utils/           # Constants and utilities
├── features/
│   └── coffee/
│       ├── data/        # Data layer
│       │   ├── datasources/    # Remote and local data sources
│       │   ├── models/         # Data models (DTOs)
│       │   └── repositories/    # Repository implementations
│       ├── domain/      # Domain layer (business logic)
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository interfaces
│       │   └── usecases/       # Use cases
│       └── presentation/ # Presentation layer
│           ├── blocs/          # BLoC state management
│           └── pages/          # Screen widgets
└── main.dart
```

### Architecture Layers

1. **Presentation Layer**: UI components, BLoC state management, and user interactions
2. **Domain Layer**: Business logic, entities, and use cases (independent of frameworks)
3. **Data Layer**: Data sources (remote API, local storage), models, and repository implementations

### Key Patterns

- **BLoC Pattern**: State management using `flutter_bloc`
- **Repository Pattern**: Abstraction between data sources and business logic
- **Dependency Injection**: Using `get_it` and `injectable` for service location
- **Use Cases**: Single responsibility business logic operations
- **Error Handling**: Custom exceptions and failure types with user-friendly messages

---

## Project Structure

### Core Module

- **design/**: Reusable widgets (`CoffeeImage`, `LoadingWidget`, `FailureWidget`) and design tokens (spacing, border radius)
- **errors/**: Custom exceptions (`NetworkException`, `ServerException`, `CacheException`) and failure message mapping
- **usecases/**: Base use case interface
- **utils/**: App-wide constants and utilities

### Coffee Feature

#### Data Layer
- **datasources/**: 
  - `coffee_remote_data_source.dart`: Fetches coffee images from API
  - `coffee_local_data_source.dart`: Manages local storage with Hive
- **models/**: `coffee_model.dart` - Data transfer object
- **repositories/**: `coffee_repository_impl.dart` - Repository implementation


## App Flow

1. **Launch App** → Coffee page loads automatically
2. **Load Random Coffee** → Fetches image from API and displays it
3. **Refresh** → "New Coffee" button loads another random image
4. **Save Coffee** → "Save" button stores image locally
5. **View Favorites** → Tap heart icon to see saved coffees
6. **View Full Image** → Tap any favorite to view full-screen

---

