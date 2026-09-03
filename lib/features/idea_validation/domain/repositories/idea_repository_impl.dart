import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/analysis_result.dart';
import '../../domain/repositories/idea_repository.dart';
import '../datasources/gemini_service.dart';
import '../models/analysis_result_model.dart';

class IdeaRepositoryImpl implements IdeaRepository {
  IdeaRepositoryImpl({
    required this.geminiService,
    required this.firestore,
    required this.auth,
  });

  final GeminiService geminiService;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('analyses');

  Future<String> _ensureUserId() async {
    final current = auth.currentUser;
    if (current != null) return current.uid;
    final cred = await auth.signInAnonymously();
    return cred.user!.uid;
  }

  @override
  Future<AnalysisResult> analyzeIdea({
    required String rawIdea,
    required String industry,
  }) async {
    final userId = await _ensureUserId();
    final model = await geminiService.analyze(rawIdea: rawIdea, industry: industry);
    final docRef = _collection.doc();
    final withId = model.copyWith(id: docRef.id);
    await docRef.set({...withId.toFirestore(), 'userId': userId});
    return withId.toEntity();
  }

  @override
  Future<List<AnalysisResult>> getHistory() async {
    final userId = await _ensureUserId();
    final snap = await _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();
    return snap.docs
        .map((d) => AnalysisResultModel.fromFirestore(d.data(), d.id).toEntity())
        .toList();
  }
}