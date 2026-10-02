import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestionnaire_taches/data/task_database.dart';
import 'package:gestionnaire_taches/models/task.dart';

class TasksNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() {
    return TaskDatabase.instance.getTasks();
  }

  Future<void> addTask(String title) async {
    final task = await TaskDatabase.instance.insert(Task(title: title));
    final current = state.value ?? [];
    state = AsyncData([task, ...current]);
  }

  Future<void> toggleTask(Task task) async {
    final updated = task.copyWith(done: !task.done);
    final current = state.value ?? [];
    state = AsyncData([
      for (final t in current) t.id == task.id ? updated : t,
    ]);
    await TaskDatabase.instance.update(updated);
  }

  Future<void> deleteTask(Task task) async {
    final current = state.value ?? [];
    state = AsyncData(current.where((t) => t.id != task.id).toList());
    await TaskDatabase.instance.delete(task);
  }
}

final tasksProvider = AsyncNotifierProvider<TasksNotifier, List<Task>>(
  TasksNotifier.new,
);