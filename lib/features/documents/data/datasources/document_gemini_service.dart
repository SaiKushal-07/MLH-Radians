// lib/features/documents/data/datasources/document_gemini_service.dart
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../projects/domain/entities/project.dart';
import '../../domain/entities/generated_document.dart';

class DocumentGeminiService {
  GenerativeModel _buildModel() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    return GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);
  }

  String _promptFor(DocumentType type, Project project) {
    final base = '''
Startup Name: ${project.name}
Stage: ${project.stage}
Problem: ${project.problem}
Solution: ${project.solution}
Target Customers: ${project.targetCustomers}
''';

    switch (type) {
      case DocumentType.businessPlan:
        return '''
Write a complete, well-structured business plan for this startup, in Markdown with headers.
Include sections: Executive Summary, Problem & Solution, Market Opportunity, Business Model, Go-To-Market Strategy, Competitive Landscape, Operations Plan, Financial Overview, and Roadmap.
$base
Be specific and realistic for this startup's stage. Do not include placeholder brackets — invent reasonable specifics grounded in the details given.
''';
      case DocumentType.executiveSummary:
        return '''
Write a concise, compelling one-page Executive Summary (under 400 words) in Markdown for this startup, suitable for investors and partners.
$base
''';
      case DocumentType.pitchContent:
        return '''
Write pitch deck content for this startup as Markdown, structured as slide-by-slide talking points (Title, Problem, Solution, Market, Product, Business Model, Traction, Team, Ask).
$base
Each slide should have a heading and 3-5 punchy bullet points.
''';
      case DocumentType.grantApplication:
        return '''
Write a draft grant / government scheme application for this startup, in Markdown, covering: Startup Overview, Problem Statement, Innovation/Solution, Market Potential, Use of Funds, Expected Impact, and Team Readiness.
$base
Keep tone formal and persuasive, suitable for a real grant application first draft.
''';
    }
  }

  Future<String> generate(DocumentType type, Project project) async {
    final model = _buildModel();
    final response = await model.generateContent([Content.text(_promptFor(type, project))]);
    return response.text?.trim() ?? 'Could not generate content. Please try again.';
  }
}