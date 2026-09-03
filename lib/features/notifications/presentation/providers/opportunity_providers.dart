// lib/features/notifications/presentation/providers/opportunity_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:startupapp/features/notifications/data/repositories/opportunity_repository.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';

final opportunityRepositoryProvider = Provider<OpportunityRepository?>((ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  final projectId = ref.watch(selectedProjectIdProvider);
  if (user == null || projectId == null) return null;
  return OpportunityRepository(ref.watch(firestoreProvider), user.uid, projectId);
});

final opportunitiesStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(opportunityRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchAll();
});