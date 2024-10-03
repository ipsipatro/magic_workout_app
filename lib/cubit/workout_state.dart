import 'package:magic_workout_app/models/workout.dart';

class WorkoutState {
  final List<Workout> workouts;

  WorkoutState({required this.workouts});

  WorkoutState copyWith({List<Workout>? workouts}) {
    return WorkoutState(
      workouts: workouts ?? this.workouts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkoutState) return false;
    return other.workouts == workouts;
  }

  @override
  int get hashCode => workouts.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'workouts': workouts
          .map((w) => {
                'exercise': w.exercise,
                'weight': w.weight,
                'repetitions': w.repetitions,
              })
          .toList(),
    };
  }

  static WorkoutState fromMap(Map<String, dynamic> map) {
    return WorkoutState(
      workouts: List<Workout>.from(
        (map['workouts'] as List).map(
          (item) => Workout(
            exercise: item['exercise'],
            weight: item['weight'],
            repetitions: item['repetitions'],
          ),
        ),
      ),
    );
  }
}
