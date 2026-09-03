// lib/features/ai_mentor/presentation/providers/mentor_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/mentor_gemini_service.dart';
import '../../data/repositories/mentor_chat_repository.dart';
import '../../domain/entities/chat_message.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../projects/presentation/providers/project_providers.dart';

final mentorGeminiServiceProvider = Provider<MentorGeminiService>((ref) {
  return MentorGeminiService();
});

final mentorChatRepositoryProvider = Provider<MentorChatRepository>((ref) {
  return MentorChatRepository();
});

final mentorChatStreamProvider = StreamProvider.autoDispose<List<ChatMessage>>((ref) {
  final uid = ref.watch(authStateChangesProvider).value?.uid;
  final projectId = ref.watch(selectedProjectIdProvider);
  if (uid == null || projectId == null) return const Stream.empty();
  return ref.watch(mentorChatRepositoryProvider).watchMessages(uid, projectId);
});

class MentorChatController extends StateNotifier<AsyncValue<void>> {
  MentorChatController(this.ref) : super(const AsyncValue.data(null));
  final Ref ref;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final uid = ref.read(authStateChangesProvider).value?.uid;
    final project = ref.read(selectedProjectProvider);
    if (uid == null || project == null) return;

    state = const AsyncValue.loading();
    try {
      final repo = ref.read(mentorChatRepositoryProvider);
      final gemini = ref.read(mentorGeminiServiceProvider);

      final userMsg = ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sender: MessageSender.user,
        text: text.trim(),
        timestamp: DateTime.now(),
      );
      await repo.addMessage(uid, project.id, userMsg);

      final history = ref.read(mentorChatStreamProvider).value ?? [];
      final reply = await gemini.sendMessage(
        project: project,
        history: history,
        newMessage: text.trim(),
      );

      final aiMsg = ChatMessage(
        id: '${DateTime.now().microsecondsSinceEpoch}_ai',
        sender: MessageSender.ai,
        text: reply,
        timestamp: DateTime.now(),
      );
      await repo.addMessage(uid, project.id, aiMsg);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearChat() async {
    final uid = ref.read(authStateChangesProvider).value?.uid;
    final project = ref.read(selectedProjectProvider);
    if (uid == null || project == null) return;
    await ref.read(mentorChatRepositoryProvider).clearChat(uid, project.id);
  }
}

final mentorChatControllerProvider =
    StateNotifierProvider.autoDispose<MentorChatController, AsyncValue<void>>((ref) {
  return MentorChatController(ref);
});

final suggestedQuestionsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final project = ref.watch(selectedProjectProvider);
  if (project == null) return [];
  return ref.watch(mentorGeminiServiceProvider).suggestedQuestions(project);
});