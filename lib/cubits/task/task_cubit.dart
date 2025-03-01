import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_cubit/models/task.model.dart';
import 'package:todo_cubit/services/database.service.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final DatabaseService _databaseService;
  TaskCubit(this._databaseService) : super(TaskInitial());

  Future<void> loadTasks() async {
    try {
      emit(TaskLoading());
      final tasks = await _databaseService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('$e'));
    }
  }

  Future<void> addTask(title, description) async {
    try {
      final task = Task(title: title, description: description);
      await _databaseService.insertTask(task);
      await loadTasks();
    } catch (e) {
      emit(TaskError('$e'));
    }
  }

  Future<void> toggleTask(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _databaseService.updateTask(updatedTask);
      await loadTasks();
    } catch (e) {
      emit(TaskError('$e'));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _databaseService.deleteTask(id);
      await loadTasks();
    } catch (e) {
      emit(TaskError('$e'));
    }
  }
}
