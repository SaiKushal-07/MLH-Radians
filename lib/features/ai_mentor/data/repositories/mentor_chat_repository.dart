// lib/features/ai_mentor/data/repositories/mentor_chat_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';
import '../models/chat_message_model.dart';

class MentorChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _chatCollection(String uid, String projectId) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('projects')
        .doc(projectId)
        .collection('mentor_chat');
  }

  Stream<List<ChatMessage>> watchMessages(String uid, String projectId) {
    return _chatCollection(uid, projectId)
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => ChatMessageModel.fromMap(d.id, d.data()))
            .toList());
  }

  Future<void> addMessage(String uid, String projectId, ChatMessage message) async {
    final model = ChatMessageModel(
      id: message.id,
      sender: message.sender,
      text: message.text,
      timestamp: message.timestamp,
    );
    await _chatCollection(uid, projectId).add(model.toMap());
  }

  Future<void> clearChat(String uid, String projectId) async {
    final snap = await _chatCollection(uid, projectId).get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }
}