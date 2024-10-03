import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:magic_workout_app/cubit/workout_cubit.dart';
import 'package:magic_workout_app/screens/workout_entry_screen.dart';
import 'package:magic_workout_app/screens/workout_list_screen.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: directory,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorkoutCubit(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Workout App',
          routes: {
            '/': (context) => const WorkoutEntryScreen(),
            '/workoutList': (context) => const WorkoutListScreen(),
          },
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            appBarTheme: const AppBarTheme(
              color: Colors.deepPurple,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            textTheme: const TextTheme(
              titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black),
              labelLarge: TextStyle(color: Colors.white, fontSize: 16),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                fixedSize: const Size(280, 60),
              ),
            ),
          ),
          initialRoute: '/'),
    );
  }
}
