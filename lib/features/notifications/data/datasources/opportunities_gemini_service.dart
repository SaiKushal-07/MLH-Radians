// lib/features/notifications/data/datasources/opportunities_gemini_service.dart
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpportunitiesGeminiService {
  final GenerativeModel _model;
  OpportunitiesGeminiService()
      : _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
          generationConfig: GenerationConfig(responseMimeType: 'application/json'),
        );

  Future<List<Map<String, dynamic>>> generate({
    required String industry,
    required String stage,
  }) async {
    final prompt = '''
You are a startup opportunity curator for India-based first-time entrepreneurs.
Given: Industry = "$industry", Stage = "$stage".
Return a JSON array of 6 realistic, currently-relevant startup opportunities relevant to this industry and stage.
Each item must be an object with exactly these keys:
"title" (string), "description" (string, 1-2 sentences), "source" (string, e.g. "Startup India", "MSME", "Y Combinator"),
"category" (one of: "Government Scheme", "Grant", "Incubator", "Accelerator", "Competition", "Hackathon", "Funding", "Workshop"),
"deadline" (string, approximate e.g. "Rolling basis" or a plausible month/year).
Return ONLY the JSON array, no other text.
''';
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '[]';
    try {
      final decoded = jsonDecode(text) as List;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}