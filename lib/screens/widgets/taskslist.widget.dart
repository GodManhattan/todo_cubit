import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit/cubits/task/task_cubit.dart';

class TasksListWidget extends StatelessWidget {
  const TasksListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          final tasks = state.tasks;

          if (tasks.isEmpty) {
            return const Center(
              child: Text("No tasks yet.\nAdd some!"),
            );
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      task.description,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) {
                      context.read<TaskCubit>().toggleTask(task);
                    }),
                trailing: IconButton(
                  onPressed: () {
                    context.read<TaskCubit>().deleteTask(task.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
