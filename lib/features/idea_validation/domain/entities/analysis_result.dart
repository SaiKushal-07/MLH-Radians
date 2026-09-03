import 'package:flutter/foundation.dart';

@immutable
class ScoreMetrics {
  final int marketSaturation;
  final int ipCollisionRisk;
  final int technicalFeasibility;
  final int vcInvestability;

  const ScoreMetrics({
    required this.marketSaturation,
    required this.ipCollisionRisk,
    required this.technicalFeasibility,
    required this.vcInvestability,
  });

  double get overallDefensibility {
    final invertedSaturation = 100 - marketSaturation;
    final invertedCollision = 100 - ipCollisionRisk;
    return (invertedSaturation + invertedCollision + technicalFeasibility + vcInvestability) / 4;
  }
}

enum PivotVector { b2bEnterprise, hyperLocal, contrarian }

extension PivotVectorLabel on PivotVector {
  String get label {
    switch (this) {
      case PivotVector.b2bEnterprise:
        return 'B2B / Enterprise';
      case PivotVector.hyperLocal:
        return 'Hyper-Local / Grassroots';
      case PivotVector.contrarian:
        return 'Contrarian / Anti-Trend';
    }
  }
}

@immutable
class Pivot {
  final PivotVector vector;
  final String title;
  final String description;

  const Pivot({
    required this.vector,
    required this.title,
    required this.description,
  });
}

@immutable
class AnalysisResult {
  final String id;
  final String rawIdea;
  final String industry;
  final ScoreMetrics scores;
  final List<String> collisions;
  final List<String> flaws;
  final List<Pivot> pivots;
  final String verdict;
  final DateTime createdAt;

  const AnalysisResult({
    required this.id,
    required this.rawIdea,
    required this.industry,
    required this.scores,
    required this.collisions,
    required this.flaws,
    required this.pivots,
    required this.verdict,
    required this.createdAt,
  });
}