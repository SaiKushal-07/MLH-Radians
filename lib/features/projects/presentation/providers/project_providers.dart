// lib/features/projects/presentation/providers/project_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:startupapp/features/projects/data/repositories/project_repository.dart';
import 'package:startupapp/features/projects/domain/entities/project.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final projectRepositoryProvider = Provider<ProjectRepository?>((ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  if (user == null) return null;
  return ProjectRepository(ref.watch(firestoreProvider), user.uid);
});

final projectsStreamProvider = StreamProvider<List<Project>>((ref) {
  final repo = ref.watch(projectRepositoryProvider);
  if (repo == null) return const Stream.empty();
  return repo.watchProjects();
});

/// Currently selected project id (drives the whole project dashboard).
final selectedProjectIdProvider = StateProvider<String?>((ref) => null);

final selectedProjectProvider = Provider<Project?>((ref) {
  final id = ref.watch(selectedProjectIdProvider);
  final projects = ref.watch(projectsStreamProvider).valueOrNull ?? [];
  if (id == null) return null;
  try {
    return projects.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});

class CreateProjectState {
  final bool isLoading;
  final String? error;
  const CreateProjectState({this.isLoading = false, this.error});
}

class CreateProjectController extends StateNotifier<CreateProjectState> {
  final Ref ref;
  CreateProjectController(this.ref) : super(const CreateProjectState());

  Future<String?> create({
    required String name,
    required String problem,
    required String solution,
    required String targetCustomers,
    required String industry,
    required String stage,
    required String description,
  }) async {
    final repo = ref.read(projectRepositoryProvider);
    if (repo == null) {
      state = const CreateProjectState(error: 'Not signed in.');
      return null;
    }
    state = const CreateProjectState(isLoading: true);
    try {
      final project = await repo.createProject(
        name: name,
        problem: problem,
        solution: solution,
        targetCustomers: targetCustomers,
        industry: industry,
        stage: stage,
        description: description,
      );
      state = const CreateProjectState(isLoading: false);
      return project.id;
    } catch (e) {
      state = CreateProjectState(isLoading: false, error: 'Failed to create project.');
      return null;
    }
  }
}

final createProjectControllerProvider =
    StateNotifierProvider<CreateProjectController, CreateProjectState>(
  (ref) => CreateProjectController(ref),
);