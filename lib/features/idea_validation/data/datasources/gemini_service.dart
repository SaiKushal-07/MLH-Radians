import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/analysis_result_model.dart';

class GeminiServiceException implements Exception {
  final String message;
  GeminiServiceException(this.message);
  @override
  String toString() => message;
}

class GeminiService {
  GeminiService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            temperature: 0.85,
          ),
          systemInstruction: Content.system(_systemPrompt),
        );

  final GenerativeModel _model;

  static const String _systemPrompt = '''
You are a ruthless, brutally honest venture capitalist reviewing a raw startup
idea pitched by a hackathon participant. Be sharp, specific, and useful -- not
generic. Return ONLY valid JSON, no markdown fences, no commentary, matching
EXACTLY this schema:

{
  "scores": {
    "marketSaturation": <int 0-100, higher = more saturated/crowded market>,
    "ipCollisionRisk": <int 0-100, higher = more likely to collide with existing patents/products>,
    "technicalFeasibility": <int 0-100, higher = easier to build>,
    "vcInvestability": <int 0-100, higher = more fundable>
  },
  "collisions": [<2 to 4 short strings naming real or archetype existing competitors and what they already do>],
  "flaws": [<2 to 4 short, sharp, specific flaws in the business model or logic>],
  "pivots": [
    {"vector": "B2B/Enterprise", "title": <short pivot name>, "description": <2-3 sentences>},
    {"vector": "Hyper-Local/Grassroots", "title": <short pivot name>, "description": <2-3 sentences>},
    {"vector": "Contrarian/Anti-Trend", "title": <short pivot name>, "description": <2-3 sentences>}
  ],
  "verdict": <one punchy sentence, VC voice, no fluff>
}
''';

  Future<AnalysisResultModel> analyze({
    required String rawIdea,
    required String industry,
  }) async {
    final prompt = 'Industry: $industry\nRaw idea: $rawIdea';
    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text;

    if (text == null || text.isEmpty) {
      throw GeminiServiceException('Empty response from Gemini.');
    }

    try {
      final Map<String, dynamic> json = jsonDecode(_stripFences(text));
      return AnalysisResultModel.fromGeminiJson(
        json: json,
        rawIdea: rawIdea,
        industry: industry,
      );
    } catch (e) {
      throw GeminiServiceException('Failed to parse Gemini response: $e');
    }
  }

  String _stripFences(String text) {
    var t = text.trim();
    if (t.startsWith('```')) {
      t = t.replaceFirst(RegExp(r'^```(json)?'), '').trim();
      if (t.endsWith('```')) {
        t = t.substring(0, t.length - 3).trim();
      }
    }
    return t;
  }
}