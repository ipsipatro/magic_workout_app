import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:magic_workout_app/cubit/workout_cubit.dart';
import 'package:magic_workout_app/cubit/workout_state.dart';
import 'package:magic_workout_app/models/workout.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  late Storage storage;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  group('WorkoutCubit', () {
    late WorkoutCubit workoutCubit;

    setUp(() {
      storage = MockStorage();

      when(() => storage.write(any<String>(), any<dynamic>())).thenAnswer((_) async {});

      when(() => storage.read(any<String>())).thenReturn(null);

      HydratedBloc.storage = storage;
      workoutCubit = WorkoutCubit();
    });

    tearDown(() {
      workoutCubit.close();
    });

    test('initial state is correct', () {
      expect(workoutCubit.state, isA<WorkoutState>());
    });

    test('addWorkout adds a new workout', () {
      workoutCubit.addWorkout(Workout(exercise: 'Barbell row', weight: '70kg', repetitions: '10'));
      expect(workoutCubit.state.workouts.length, 1);
      expect(workoutCubit.state.workouts[0], isA<Workout>());
      expect(workoutCubit.state.workouts[0].exercise, 'Barbell row');
    });

    test('deleteWorkout removes a workout', () {
      workoutCubit.addWorkout(Workout(exercise: 'Bench press', weight: '50kg', repetitions: '8'));
      workoutCubit.deleteWorkout(0);
      expect(workoutCubit.state.workouts.length, 0);
    });

    test('updateWorkout updates an existing workout', () {
      workoutCubit.addWorkout(Workout(exercise: 'Deadlift', weight: '80kg', repetitions: '5', id: 'test_id'));
      workoutCubit.updateWorkout(Workout(exercise: 'Deadlift', weight: '85kg', repetitions: '6', id: 'test_id'));
      expect(workoutCubit.state.workouts[0].weight, '85kg');
      expect(workoutCubit.state.workouts[0].repetitions, '6');
    });
  });
}
