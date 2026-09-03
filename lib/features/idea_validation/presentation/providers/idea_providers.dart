import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/gemini_service.dart';
import '../../data/repositories/idea_repository_impl.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/idea_repository.dart';

// Pass at build time: flutter run --dart-define=GEMINI_API_KEY=your_key_here
const String kGeminiApiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: 'YOUR_GEMINI_API_KEY_HERE',
);

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(apiKey: kGeminiApiKey);
});

final ideaRepositoryProvider = Provider<IdeaRepository>((ref) {
  return IdeaRepositoryImpl(
    geminiService: ref.watch(geminiServiceProvider),
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

enum AnalysisStatus { idle, loading, success, error }

class AnalysisState {
  final AnalysisStatus status;
  final AnalysisResult? result;
  final String? errorMessage;

  const AnalysisState({
    this.status = AnalysisStatus.idle,
    this.result,
    this.errorMessage,
  });

  AnalysisState copyWith({
    AnalysisStatus? status,
    AnalysisResult? result,
    String? errorMessage,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }
}

class AnalysisController extends StateNotifier<AnalysisState> {
  AnalysisController(this._repository) : super(const AnalysisState());

  final IdeaRepository _repository;

  Future<void> submitIdea({required String rawIdea, required String industry}) async {
    if (rawIdea.trim().isEmpty) {
      state = state.copyWith(
        status: AnalysisStatus.error,
        errorMessage: 'Please describe your idea first.',
      );
      return;
    }
    state = state.copyWith(status: AnalysisStatus.loading, errorMessage: null);
    try {
      final result = await _repository.analyzeIdea(rawIdea: rawIdea, industry: industry);
      state = state.copyWith(status: AnalysisStatus.success, result: result);
    } catch (e) {
      state = state.copyWith(status: AnalysisStatus.error, errorMessage: e.toString());
    }
  }

  void reset() => state = const AnalysisState();
}

final analysisControllerProvider =
    StateNotifierProvider<AnalysisController, AnalysisState>((ref) {
  return AnalysisController(ref.watch(ideaRepositoryProvider));
});