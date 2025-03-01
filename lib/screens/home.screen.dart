import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubits/task/task_cubit.dart';
import 'package:todo_cubit/screens/widgets/taskdialog.widget.dart';
import 'package:todo_cubit/screens/widgets/taskslist.widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // post-frame callback to ensure the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<TaskCubit>().loadTasks();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TaskLoaded) {
            return TasksListWidget();
          }
          if (state is TaskError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return Center(
            child: Text('No tasks yet.\nAdd one! '),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final taskCubit = context.read<TaskCubit>();
          showDialog(
              context: context,
              builder: (dialogContext) {
                return BlocProvider.value(
                  value: taskCubit,
                  child: TaskDialog(),
                );
              });
        },
        child: Icon(
          Icons.add,
        ),
      ),
    ));
  }
}
