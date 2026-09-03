// lib/features/expenses/presentation/providers/expense_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:startupapp/features/expenses/data/repositories/expense_repository.dart';
import 'package:startupapp/features/expenses/domain/entities/expense.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository?>((ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  final projectId = ref.watch(selectedProjectIdProvider);
  if (user == null || projectId == null) return null;
  return ExpenseRepository(ref.watch(firestoreProvider), user.uid, projectId);
});

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchAll();
});