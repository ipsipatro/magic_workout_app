import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Workout extends Equatable {
  final String exercise;
  final String weight;
  final String repetitions;
  final String id;

  Workout({
    required this.exercise,
    required this.weight,
    required this.repetitions,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'exercise': exercise,
      'weight': weight,
      'repetitions': repetitions,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      exercise: map['exercise'] as String,
      weight: map['weight'] as String,
      repetitions: map['repetitions'] as String,
    );
  }

  @override
  List<Object?> get props => [exercise, weight, repetitions];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Workout) return false;
    return other.exercise == exercise && other.weight == weight && other.repetitions == repetitions && other.id == id;
  }

  @override
  int get hashCode => exercise.hashCode ^ weight.hashCode ^ repetitions.hashCode ^ id.hashCode;
}
