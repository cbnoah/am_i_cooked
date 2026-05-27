# Am I Cooked

## Description
A revolutionary cooking app built with Flutter. "Am I Cooked" allows users to discover new recipes, manage their favorites, and track their culinary progress through an integrated gamification system.

## Features
- **Recipe Discovery**: Browse a wide range of recipes with detailed instructions and ingredients.
- **Favorites Management**: Save your favorite recipes for quick access.
- **User Authentication**: Secure login and registration system.
- **Recipe Creation & Editing**: Share your own culinary creations with the community.
- **Dynamic Theming**: Support for Material 3 and adaptive themes.
- **Deep Linking**: Share recipes easily with custom URI schemes.

## Installation
```bash
flutter pub get
```

## Project Structure
```text
am_i_cooked/
├── android/              # Android specific configuration
├── ios/                  # iOS specific configuration
├── assets/               # Images and fonts
├── lib/
│   ├── components/       # Reusable UI widgets (XP bar, cards, etc.)
│   ├── config/           # API and global configurations
│   ├── models/           # Data models (Recipe, User, etc.)
│   ├── pages/            # Application screens
│   ├── providers/        # Riverpod state management
│   ├── service/          # API services (Auth, etc.)
│   ├── theme/            # Theme definitions
│   ├── utils/            # Helper functions
│   └── main.dart         # Application entry point
├── test/                 # Unit and widget tests
└── pubspec.yaml          # Project dependencies and assets
```

## Configuration
### Environment Variables
The application requires an API URL to be defined during build or run:
```bash
--dart-define=API_URL=https://your-api-url.com
```

## Getting Started
### Development mode
```bash
flutter run --dart-define=API_URL=https://your-api-url.com
```

### Production build
```bash
flutter build apk --dart-define=API_URL=https://your-api-url.com
```

## Technologies
- **Flutter** - UI Framework
- **Riverpod** - State management
- **Go Router** - Declarative routing
- **Dio** - HTTP client for API requests
- **Material 3** - Modern design system
- **Flutter Secure Storage** - Secure data persistence

## Authors

- Noah CHARRIN--BOURRAT
- Mathieu BERIAC
- Raphaël BONNET
- Loïc ANDRIANARIVONY
