// lib/features/tasks/presentation/providers/task_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';
import 'package:startupapp/features/tasks/data/repositories/task_repository.dart';
import 'package:startupapp/features/tasks/domain/entities/task.dart';

final taskRepositoryProvider = Provider<TaskRepository?>((ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  final projectId = ref.watch(selectedProjectIdProvider);
  if (user == null || projectId == null) return null;
  return TaskRepository(ref.watch(firestoreProvider), user.uid, projectId);
});

final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchAll();
});

final nextActionsProvider = Provider<List<Task>>((ref) {
  final all = ref.watch(tasksStreamProvider).valueOrNull ?? [];
  return all.where((t) => t.isNextAction && !t.completed).toList();
});

final selectedCalendarDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final selectedCalendarMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});