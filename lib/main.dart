import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubits/task/task_cubit.dart';
import 'package:todo_cubit/screens/home.screen.dart';
import 'package:todo_cubit/services/database.service.dart';

void main() {
  // Add this line to ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Create the database service once
  final databaseService = DatabaseService();
  runApp(
    BlocProvider(
      create: (context) => TaskCubit(databaseService),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Load tasks when the app starts
    context.read<TaskCubit>().loadTasks();

    return MaterialApp(
      title: "To-Do App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
