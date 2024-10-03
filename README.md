# Magic Workout App

**Description**: A Flutter app for tracking workouts, enabling users to log exercise details efficiently.

## Table of Contents

- [Architecture](#architecture)
- [Third-Party Packages](#third-party-packages)
- [Getting Started](#getting-started)
- [License](#license)

## Architecture

The architecture of the magic_workout_app I have used based on the Cubit state management pattern, utilizing the Flutter Bloc library. This approach ensures a clear separation of concerns, improving the maintainability and scalability of the app. The key components include:

Cubit: Manages state for workouts, allowing actions like adding, deleting, and editing workouts.
State Management: Utilizes WorkoutState to hold workout data.
UI Layer: Flutter widgets that react to state changes.
Dependency Injection: Implements BlocProvider to manage dependencies efficiently.

### Key Components:

- **Cubit**: Manages the application's state and business logic. It has methods to save, retrieve and update data, enabling a reactive programming model.
- **Screens**: Contanins the two screens one for workout entry and another one to view and edit list of workouts.
- **Widgets**: Contains some custom widget
- **Constants**: For all strings in the app
- **Enums**: FFor enums I have used for dropdowns.
- **Models**: Represents the data structures used in the app, such as `Workout`.

## Tests

- There is a test folder inside the app which contains 3 different types of tests
  1: Unit
  2: Widget
  3: Integration

## Third-Party Packages

1. **equatable**:

   - **Reason**: Simplifies equality comparisons for classes, particularly useful for BLoC state classes.

2. **flutter_bloc**:

   - **Reason**: Provides a way to manage state using the BLoC pattern, making state management easier and more structured. I have used it for using Cubit in the app.

3. **hydrated_bloc**:

   - **Reason**: Allows automatic persistence of BLoC states, ensuring that user data is saved even if the app is closed. Using hydrated bloc I;m persisting data for the app.

4. **path_provider**:

   - **Reason**: Provides access to commonly used locations on the filesystem, such as temporary and application directories.

5. **uuid**:

   - **Reason**: Generates unique identifiers for workouts, ensuring that each entry can be tracked independently.I have used it for generating unique id for the workouts.

6. **mocktail** and **mockito**:

   - **Reason**: Facilitates unit testing by allowing the creation of mock objects.

7. **bloc_test**:

   - **Reason**: Provides utilities to test BLoCs more easily and effectively.

8. **build_runner**:
   - **Reason**: Used for code generation.To generate mocks we need this

## Getting Started

To run the app, clone the repository and run the following commands:

flutter pub get
flutter run

To run Tests:
flutter pub run build_runner build
flutter test
