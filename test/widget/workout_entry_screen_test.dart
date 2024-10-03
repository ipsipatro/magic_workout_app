import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_workout_app/cubit/workout_cubit.dart';
import 'package:magic_workout_app/cubit/workout_state.dart';
import 'package:magic_workout_app/enums/exercise.dart';
import 'package:magic_workout_app/enums/weight.dart';
import 'package:magic_workout_app/models/workout.dart';
import 'package:magic_workout_app/screens/workout_entry_screen.dart';
import 'package:magic_workout_app/widgets/custom_drop_down.dart';
import 'package:mocktail/mocktail.dart';

class MockWorkoutCubit extends Mock implements WorkoutCubit {}

void main() {
  late MockWorkoutCubit mockWorkoutCubit;

  setUp(() {
    mockWorkoutCubit = MockWorkoutCubit();
    when(() => mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: []));
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: BlocProvider<WorkoutCubit>.value(
        value: mockWorkoutCubit,
        child: child,
      ),
    );
  }

  testWidgets('renders WorkoutPage correctly with no pre-filled workout', (tester) async {
    // Arrange
    final workout = Workout(exercise: 'Barbell row', weight: '70kg', repetitions: '10');

    when(() => mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: [workout]));

    // Act
    await tester.pumpWidget(makeTestableWidget(const WorkoutEntryScreen()));

    // Assert
    expect(find.text('Enter Workout Details'), findsOneWidget);
    expect(find.byType(CustomDropdown<Exercise>), findsOneWidget);
    expect(find.byType(CustomDropdown<Weight>), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('renders WorkoutPage correctly with a pre-filled workout', (tester) async {
    // Arrange
    final workout = Workout(exercise: 'Barbell row', weight: '70kg', repetitions: '10');
    when(() => mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: [workout]));

    // Act
    await tester.pumpWidget(makeTestableWidget(WorkoutEntryScreen(workout: workout)));

    // Assert
    expect(find.text('Edit Workout'), findsOneWidget);
    expect(find.text('Barbell row'), findsOneWidget);
    expect(find.text('70kg'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
  });

  testWidgets('disables submit button when fields are empty', (tester) async {
    // Arrange
    when(() => mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: []));

    // Act
    await tester.pumpWidget(makeTestableWidget(const WorkoutEntryScreen()));

    // Assert
    final submitButton = find.byType(ElevatedButton).first;
    expect(tester.widget<ElevatedButton>(submitButton).enabled, isFalse);
  });

  testWidgets('enables submit button when all fields are filled', (tester) async {
    // Arrange
    when(() => mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: []));

    // Act
    await tester.pumpWidget(makeTestableWidget(const WorkoutEntryScreen()));
    await tester.tap(find.byType(CustomDropdown<Exercise>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Barbell row').last);
    await tester.pump();
    await tester.tap(find.byType(CustomDropdown<Weight>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('70kg').last); // Select '70kg'
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), '10'); // Enter repetitions
    await tester.pump();

    // Assert
    final submitButton = find.byType(ElevatedButton).first;
    expect(tester.widget<ElevatedButton>(submitButton).enabled, isTrue);
  });
}
