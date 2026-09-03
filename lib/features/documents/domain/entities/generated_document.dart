// lib/features/documents/domain/entities/generated_document.dart
enum DocumentType { businessPlan, executiveSummary, pitchContent, grantApplication }

extension DocumentTypeLabel on DocumentType {
  String get label {
    switch (this) {
      case DocumentType.businessPlan:
        return 'Business Plan';
      case DocumentType.executiveSummary:
        return 'Executive Summary';
      case DocumentType.pitchContent:
        return 'Pitch Content';
      case DocumentType.grantApplication:
        return 'Grant Application Draft';
    }
  }

  String get description {
    switch (this) {
      case DocumentType.businessPlan:
        return 'Full structured business plan covering market, model, and strategy';
      case DocumentType.executiveSummary:
        return 'A concise one-page summary of your startup';
      case DocumentType.pitchContent:
        return 'Talking points and slide content for your pitch deck';
      case DocumentType.grantApplication:
        return 'A draft application for grants and government schemes';
    }
  }
}

class GeneratedDocument {
  final String id;
  final DocumentType type;
  final String content;
  final DateTime generatedAt;

  const GeneratedDocument({
    required this.id,
    required this.type,
    required this.content,
    required this.generatedAt,
  });
}