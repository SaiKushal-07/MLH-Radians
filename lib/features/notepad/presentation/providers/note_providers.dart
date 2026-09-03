// lib/features/notepad/presentation/providers/note_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/note_repository.dart';
import '../../domain/entities/note.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../projects/presentation/providers/project_providers.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) => NoteRepository());

final notesStreamProvider = StreamProvider.autoDispose<List<Note>>((ref) {
  final uid = ref.watch(authStateChangesProvider).value?.uid;
  final projectId = ref.watch(selectedProjectIdProvider);
  if (uid == null || projectId == null) return const Stream.empty();
  return ref.watch(noteRepositoryProvider).watchNotes(uid, projectId);
});

class NoteController extends StateNotifier<AsyncValue<void>> {
  NoteController(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> addNote(String title, String content) async {
    final uid = ref.read(authStateChangesProvider).value?.uid;
    final projectId = ref.read(selectedProjectIdProvider);
    if (uid == null || projectId == null) return;
    state = const AsyncValue.loading();
    try {
      await ref.read(noteRepositoryProvider).addNote(uid, projectId, title, content);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateNote(Note note) async {
    final uid = ref.read(authStateChangesProvider).value?.uid;
    final projectId = ref.read(selectedProjectIdProvider);
    if (uid == null || projectId == null) return;
    await ref.read(noteRepositoryProvider).updateNote(uid, projectId, note);
  }

  Future<void> deleteNote(String noteId) async {
    final uid = ref.read(authStateChangesProvider).value?.uid;
    final projectId = ref.read(selectedProjectIdProvider);
    if (uid == null || projectId == null) return;
    await ref.read(noteRepositoryProvider).deleteNote(uid, projectId, noteId);
  }
}

final noteControllerProvider =
    StateNotifierProvider.autoDispose<NoteController, AsyncValue<void>>((ref) => NoteController(ref));