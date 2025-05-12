# PC Part Picker - Flutter Edition

This is a Flutter conversion of the PCPartPicker web application. This app allows users to build custom PC configurations by selecting components such as processors, graphics cards, motherboards, RAM, storage, cases, and power supplies.

## Features

- Browse and search for PC components
- View detailed specifications for each component
- Add components to your custom PC build
- Keep track of selected components and total price
- Responsive UI that works on multiple device sizes
- Dark mode support

## Screenshots

[Screenshots will be added here]

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or later)
- Dart SDK (version 3.0.0 or later)
- Android Studio / VS Code with Flutter extensions
- An Android or iOS device/emulator

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/pc_part_picker_flutter.git
   ```

2. Navigate to the project directory
   ```bash
   cd pc_part_picker_flutter
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run the app
   ```bash
   flutter run
   ```

### API Connection

The app connects to the same backend API as the original PC Part Picker application. Make sure the API server is running at `http://localhost:5000` or update the base URL in the provider files if it's running elsewhere.

## Project Structure

```
lib/
  ├── models/         # Data models for PC components
  ├── providers/      # State management using Provider
  ├── screens/        # Application screens
  ├── widgets/        # Reusable UI components
  └── main.dart       # Application entry point
```

## Libraries Used

- **provider**: State management
- **go_router**: Navigation
- **http**: API requests
- **flutter_staggered_grid_view**: Grid layouts
- **carousel_slider**: Image carousels
- **shared_preferences**: Local storage
- **intl**: Formatting (numbers, dates)
- **url_launcher**: Opening URLs
- **animated_text_kit**: Text animations

## Acknowledgements

This project is a Flutter conversion of the original PC Part Picker web application, which served as the design and functional reference.

## License

This project is for educational purposes only.