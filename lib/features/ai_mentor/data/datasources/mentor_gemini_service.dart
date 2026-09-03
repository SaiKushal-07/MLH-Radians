// lib/features/ai_mentor/data/datasources/mentor_gemini_service.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../projects/domain/entities/project.dart';
import '../../domain/entities/chat_message.dart';

class MentorGeminiService {
  GenerativeModel _buildModel() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    return GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  }

  String _systemContext(Project project) {
    return '''
You are an experienced startup mentor and advisor embedded inside a startup companion app.
You are mentoring the founder of the following startup:

Name: ${project.name}
Current Stage: ${project.stage}
Problem: ${project.problem}
Solution: ${project.solution}
Target Customers: ${project.targetCustomers}

Give practical, specific, encouraging advice tailored to their current stage in the roadmap:
Idea -> Validation -> Business Planning -> Registration -> MVP -> Funding -> Launch -> Growth.
Keep answers concise (3-6 sentences unless the founder asks for depth), actionable, and avoid generic fluff.
If asked something unrelated to their startup, gently steer back to being useful for their journey.
''';
  }

  Future<String> sendMessage({
    required Project project,
    required List<ChatMessage> history,
    required String newMessage,
  }) async {
    final model = _buildModel();

    final contentHistory = <Content>[
      Content.text(_systemContext(project)),
    ];

    for (final msg in history) {
      contentHistory.add(
        msg.sender == MessageSender.user
            ? Content.text(msg.text)
            : Content.model([TextPart(msg.text)]),
      );
    }

    final chat = model.startChat(history: contentHistory);
    final response = await chat.sendMessage(Content.text(newMessage));
    return response.text?.trim() ?? "Sorry, I couldn't generate a response. Please try again.";
  }

  Future<List<String>> suggestedQuestions(Project project) async {
    final model = _buildModel();
    final prompt = '''
Based on this startup's current stage (${project.stage}) and details below, suggest exactly 4 short, specific questions (max 10 words each) a founder might want to ask their AI mentor right now.
Problem: ${project.problem}
Solution: ${project.solution}
Return ONLY a JSON array of 4 strings, nothing else, no markdown fences.
''';
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      var text = response.text?.trim() ?? '[]';
      text = text.replaceAll('```json', '').replaceAll('```', '').trim();
      final List<dynamic> parsed = text.isEmpty ? [] : jsonDecode(text) as List<dynamic>;
      return parsed.map((e) => e.toString()).take(4).toList();
    } catch (_) {
      return [
        'What should I focus on this week?',
        'How do I validate my idea faster?',
        'What funding options fit my stage?',
        'How do I find early customers?',
      ];
    }
  }
}