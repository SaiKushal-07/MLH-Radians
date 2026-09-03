// lib/features/documents/presentation/providers/document_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/document_gemini_service.dart';
import '../../data/repositories/document_repository.dart';
import '../../domain/entities/generated_document.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../projects/presentation/providers/project_providers.dart';

final documentGeminiServiceProvider = Provider<DocumentGeminiService>((ref) => DocumentGeminiService());
final documentRepositoryProvider = Provider<DocumentRepository>((ref) => DocumentRepository());

final documentsStreamProvider = StreamProvider.autoDispose<List<GeneratedDocument>>((ref) {
  final uid = ref.watch(authStateChangesProvider).value?.uid;
  final projectId = ref.watch(selectedProjectIdProvider);
  if (uid == null || projectId == null) return const Stream.empty();
  return ref.watch(documentRepositoryProvider).watchDocuments(uid, projectId);
});

class DocumentController extends StateNotifier<AsyncValue<void>> {
  DocumentController(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> generate(DocumentType type) async {
    final uid = ref.read(authStateChangesProvider).value?.uid;
    final project = ref.read(selectedProjectProvider);
    if (uid == null || project == null) return;
    state = const AsyncValue.loading();
    try {
      final content = await ref.read(documentGeminiServiceProvider).generate(type, project);
      await ref.read(documentRepositoryProvider).saveDocument(uid, project.id, type, content);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> saveEdit(DocumentType type, String content) async {
    final uid = ref.read(authStateChangesProvider).value?.uid;
    final project = ref.read(selectedProjectProvider);
    if (uid == null || project == null) return;
    await ref.read(documentRepositoryProvider).saveDocument(uid, project.id, type, content);
  }
}

final documentControllerProvider =
    StateNotifierProvider.autoDispose<DocumentController, AsyncValue<void>>((ref) => DocumentController(ref));