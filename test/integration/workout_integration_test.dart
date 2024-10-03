import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magic_workout_app/cubit/workout_cubit.dart';
import 'package:magic_workout_app/cubit/workout_state.dart';
import 'package:magic_workout_app/models/workout.dart';
import 'package:magic_workout_app/screens/workout_entry_screen.dart';
import 'package:magic_workout_app/screens/workout_list_screen.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'workout_integration_test.mocks.dart';

@GenerateMocks([WorkoutCubit])
void main() {
  group('Workout Page Integration Test', () {
    late MockWorkoutCubit mockWorkoutCubit;

    setUp(() {
      mockWorkoutCubit = MockWorkoutCubit();
      when(mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: []));
      when(mockWorkoutCubit.stream).thenAnswer((_) => Stream.value(WorkoutState(workouts: [])));
    });

    testWidgets('Should display WorkoutPage and handle workout submission', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WorkoutCubit>(
            create: (_) => mockWorkoutCubit,
            child: const WorkoutEntryScreen(),
          ),
        ),
      );

      expect(find.text('Select Exercise'), findsOneWidget);

      expect(find.text('Select Weight'), findsOneWidget);

      expect(find.byType(TextFormField), findsOneWidget);

      await tester.tap(find.text('Select Exercise'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bench press').last);
      await tester.pumpAndSettle();
      expect(find.text('Bench press'), findsOneWidget);

      await tester.tap(find.text('Select Weight'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('70kg').last);
      await tester.pumpAndSettle();
      expect(find.text('70kg'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '10');
      await tester.pumpAndSettle();
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('Should display WorkoutListPage and handle delete action', (WidgetTester tester) async {
      final workouts = [
        Workout(id: '1', exercise: 'Bench press', weight: '70kg', repetitions: '10'),
      ];

      when(mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: workouts));
      when(mockWorkoutCubit.stream).thenAnswer((_) => Stream.value(WorkoutState(workouts: workouts)));
      when(mockWorkoutCubit.deleteWorkout(any)).thenReturn(null);

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WorkoutCubit>(
            create: (_) => mockWorkoutCubit,
            child: const WorkoutListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Bench press'), findsOneWidget);
      expect(find.text('70kg kg - 10 reps'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      verify(mockWorkoutCubit.deleteWorkout(0)).called(1);
    });

    testWidgets('Should display empty list message', (WidgetTester tester) async {
      when(mockWorkoutCubit.state).thenReturn(WorkoutState(workouts: []));
      when(mockWorkoutCubit.stream).thenAnswer((_) => Stream.value(WorkoutState(workouts: [])));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<WorkoutCubit>(
            create: (_) => mockWorkoutCubit,
            child: const WorkoutListScreen(),
          ),
        ),
      );

      expect(find.text('No workouts added yet'), findsOneWidget);
    });
  });
}
