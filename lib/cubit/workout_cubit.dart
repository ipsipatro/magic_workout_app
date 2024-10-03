import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:magic_workout_app/models/workout.dart';
import 'workout_state.dart';

class WorkoutCubit extends HydratedCubit<WorkoutState> {
  WorkoutCubit() : super(WorkoutState(workouts: []));

  void addWorkout(Workout workout) {
    final updatedWorkouts = List<Workout>.from(state.workouts)..add(workout);
    emit(state.copyWith(workouts: updatedWorkouts));
  }

  void updateWorkout(Workout workout) {
    final updatedWorkouts = state.workouts.map((w) {
      return w.id == workout.id ? workout : w;
    }).toList();
    emit(state.copyWith(workouts: updatedWorkouts));
  }

  void deleteWorkout(int index) {
    final updatedWorkouts = List<Workout>.from(state.workouts)..removeAt(index);
    emit(state.copyWith(workouts: updatedWorkouts));
  }

  @override
  Map<String, dynamic>? toJson(WorkoutState state) {
    return state.toMap();
  }

  @override
  WorkoutState? fromJson(Map<String, dynamic> json) {
    return WorkoutState.fromMap(json);
  }
}
