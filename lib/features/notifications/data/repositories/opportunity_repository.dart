// lib/features/notifications/data/repositories/opportunity_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startupapp/features/notifications/data/datasources/opportunities_gemini_service.dart';

class OpportunityRepository {
  final FirebaseFirestore _db;
  final String uid;
  final String projectId;
  final OpportunitiesGeminiService _gemini = OpportunitiesGeminiService();

  OpportunityRepository(this._db, this.uid, this.projectId);

  CollectionReference<Map<String, dynamic>> get _col => _db
      .collection('users')
      .doc(uid)
      .collection('projects')
      .doc(projectId)
      .collection('opportunities');

  Stream<List<Map<String, dynamic>>> watchAll() {
    return _col.orderBy('createdAt', descending: true).snapshots().map(
          (s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList(),
        );
  }

  Future<int> countAll() async => (await _col.limit(1).get()).docs.length;

  Future<void> refresh({required String industry, required String stage}) async {
    final existing = await _col.get();
    for (final doc in existing.docs) {
      await doc.reference.delete();
    }
    final items = await _gemini.generate(industry: industry.isEmpty ? 'General' : industry, stage: stage);
    for (final item in items) {
      await _col.add({...item, 'createdAt': FieldValue.serverTimestamp()});
    }
  }
}