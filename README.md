# Sooki

A modern mobile application built with Flutter.

## Architecture

This project uses a clean architecture approach with:

- **Dependency Injection**: get_it + injectable for DI
- **API Layer**: Dio client with custom interceptors and error handling
- **Data Models**: Freezed for immutable DTOs with JSON serialization
- **Functional Programming**: fpdart for Either-based error handling

## Project Structure

```
lib/
├── backend_integration/
│   ├── apis/                 # API service classes
│   ├── dio/                  # Dio HTTP client setup
│   │   ├── client/          # Client configuration
│   │   └── interceptors/    # Request/response interceptors
│   ├── dtos/                # Data transfer objects (Freezed models)
│   └── dependency_injection/ # DI setup
└── main.dart
```

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate code (for DTOs and DI):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```
