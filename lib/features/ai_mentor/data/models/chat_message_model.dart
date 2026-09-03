// lib/features/ai_mentor/data/models/chat_message_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.sender,
    required super.text,
    required super.timestamp,
  });

  factory ChatMessageModel.fromMap(String id, Map<String, dynamic> map) {
    return ChatMessageModel(
      id: id,
      sender: (map['sender'] as String) == 'user' ? MessageSender.user : MessageSender.ai,
      text: map['text'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender == MessageSender.user ? 'user' : 'ai',
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}