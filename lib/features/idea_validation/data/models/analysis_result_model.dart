import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/analysis_result.dart';

class AnalysisResultModel {
  AnalysisResultModel({
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

  final String id;
  final String rawIdea;
  final String industry;
  final ScoreMetrics scores;
  final List<String> collisions;
  final List<String> flaws;
  final List<Pivot> pivots;
  final String verdict;
  final DateTime createdAt;

  factory AnalysisResultModel.fromGeminiJson({
    required Map<String, dynamic> json,
    required String rawIdea,
    required String industry,
  }) {
    final scoresJson = Map<String, dynamic>.from(json['scores'] as Map);
    return AnalysisResultModel(
      id: '',
      rawIdea: rawIdea,
      industry: industry,
      scores: ScoreMetrics(
        marketSaturation: (scoresJson['marketSaturation'] as num).toInt(),
        ipCollisionRisk: (scoresJson['ipCollisionRisk'] as num).toInt(),
        technicalFeasibility: (scoresJson['technicalFeasibility'] as num).toInt(),
        vcInvestability: (scoresJson['vcInvestability'] as num).toInt(),
      ),
      collisions: (json['collisions'] as List).map((e) => e.toString()).toList(),
      flaws: (json['flaws'] as List).map((e) => e.toString()).toList(),
      pivots: (json['pivots'] as List).map((p) {
        final map = Map<String, dynamic>.from(p as Map);
        return Pivot(
          vector: _vectorFromString(map['vector'].toString()),
          title: map['title'].toString(),
          description: map['description'].toString(),
        );
      }).toList(),
      verdict: json['verdict'].toString(),
      createdAt: DateTime.now(),
    );
  }

  factory AnalysisResultModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return AnalysisResultModel(
      id: docId,
      rawIdea: data['rawIdea'] as String,
      industry: data['industry'] as String,
      scores: ScoreMetrics(
        marketSaturation: (data['marketSaturation'] as num).toInt(),
        ipCollisionRisk: (data['ipCollisionRisk'] as num).toInt(),
        technicalFeasibility: (data['technicalFeasibility'] as num).toInt(),
        vcInvestability: (data['vcInvestability'] as num).toInt(),
      ),
      collisions: List<String>.from(data['collisions'] as List),
      flaws: List<String>.from(data['flaws'] as List),
      pivots: (data['pivots'] as List).map((p) {
        final map = Map<String, dynamic>.from(p as Map);
        return Pivot(
          vector: _vectorFromString(map['vector'].toString()),
          title: map['title'].toString(),
          description: map['description'].toString(),
        );
      }).toList(),
      verdict: data['verdict'] as String,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static PivotVector _vectorFromString(String value) {
    final v = value.toLowerCase();
    if (v.contains('b2b') || v.contains('enterprise')) return PivotVector.b2bEnterprise;
    if (v.contains('local') || v.contains('grassroots')) return PivotVector.hyperLocal;
    return PivotVector.contrarian;
  }

  AnalysisResultModel copyWith({String? id}) => AnalysisResultModel(
        id: id ?? this.id,
        rawIdea: rawIdea,
        industry: industry,
        scores: scores,
        collisions: collisions,
        flaws: flaws,
        pivots: pivots,
        verdict: verdict,
        createdAt: createdAt,
      );

  Map<String, dynamic> toFirestore() => {
        'rawIdea': rawIdea,
        'industry': industry,
        'marketSaturation': scores.marketSaturation,
        'ipCollisionRisk': scores.ipCollisionRisk,
        'technicalFeasibility': scores.technicalFeasibility,
        'vcInvestability': scores.vcInvestability,
        'collisions': collisions,
        'flaws': flaws,
        'pivots': pivots
            .map((p) => {
                  'vector': p.vector.label,
                  'title': p.title,
                  'description': p.description,
                })
            .toList(),
        'verdict': verdict,
        'createdAt': FieldValue.serverTimestamp(),
      };

  AnalysisResult toEntity() => AnalysisResult(
        id: id,
        rawIdea: rawIdea,
        industry: industry,
        scores: scores,
        collisions: collisions,
        flaws: flaws,
        pivots: pivots,
        verdict: verdict,
        createdAt: createdAt,
      );
}