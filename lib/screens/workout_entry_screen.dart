import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magic_workout_app/constants/strings.dart';
import 'package:magic_workout_app/cubit/workout_cubit.dart';
import 'package:magic_workout_app/enums/exercise.dart';
import 'package:magic_workout_app/enums/weight.dart';
import 'package:magic_workout_app/models/workout.dart';
import 'package:magic_workout_app/widgets/custom_drop_down.dart';

class WorkoutEntryScreen extends StatefulWidget {
  final Workout? workout;

  const WorkoutEntryScreen({super.key, this.workout});

  @override
  State<WorkoutEntryScreen> createState() => _WorkoutEntryScreenState();
}

class _WorkoutEntryScreenState extends State<WorkoutEntryScreen> {
  Exercise? selectedExercise;
  Weight? selectedWeight;
  final TextEditingController repetitionController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    isEditing = widget.workout != null;

    if (isEditing) {
      selectedExercise = Exercise.values.firstWhere((e) => e.label == widget.workout!.exercise);
      selectedWeight = Weight.values.firstWhere((w) => w.label == widget.workout!.weight);
      repetitionController.text = widget.workout!.repetitions;
    }

    repetitionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    repetitionController.dispose();
    super.dispose();
  }

  void resetForm() {
    setState(() {
      selectedExercise = null;
      selectedWeight = null;
      repetitionController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editWorkout : AppStrings.enterWorkoutDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 200,
              child: Image.asset('assets/images/workout.png'),
            ),
            const SizedBox(height: 20),
            CustomDropdown<Exercise>(
              label: AppStrings.selectExercise,
              value: selectedExercise,
              items: Exercise.values,
              itemLabel: (Exercise exercise) => exercise.label,
              onChanged: (Exercise? newValue) {
                setState(() {
                  selectedExercise = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomDropdown<Weight>(
              label: AppStrings.selectWeight,
              value: selectedWeight,
              items: Weight.values,
              itemLabel: (Weight weight) => weight.label,
              onChanged: (Weight? newValue) {
                setState(() {
                  selectedWeight = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: repetitionController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.enterRepetitions,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedExercise != null && selectedWeight != null && repetitionController.text.isNotEmpty)
              Text(
                'Selected: ${selectedExercise!.label} - ${selectedWeight!.label}, Repetitions: ${repetitionController.text}',
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: (selectedExercise != null && selectedWeight != null && repetitionController.text.isNotEmpty)
                  ? () {
                      var workout = Workout(
                        id: widget.workout?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        exercise: selectedExercise!.label,
                        weight: selectedWeight!.label,
                        repetitions: repetitionController.text,
                      );

                      if (isEditing) {
                        context.read<WorkoutCubit>().updateWorkout(workout);
                      } else {
                        context.read<WorkoutCubit>().addWorkout(workout);
                      }

                      resetForm();
                      Navigator.of(context).pushReplacementNamed('/workoutList');
                    }
                  : null,
              child: Text(isEditing ? AppStrings.updateWorkout : AppStrings.submitWorkout),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/workoutList');
              },
              child: const Text(AppStrings.viewWorkoutList),
            ),
          ],
        ),
      ),
    );
  }
}
