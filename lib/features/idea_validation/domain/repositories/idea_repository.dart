import '../entities/analysis_result.dart';

abstract class IdeaRepository {
  Future<AnalysisResult> analyzeIdea({
    required String rawIdea,
    required String industry,
  });

  Future<List<AnalysisResult>> getHistory();
}