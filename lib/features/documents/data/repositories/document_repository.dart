// lib/features/documents/data/repositories/document_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/generated_document.dart';

class DocumentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _docsCollection(String uid, String projectId) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('projects')
        .doc(projectId)
        .collection('documents');
  }

  Stream<List<GeneratedDocument>> watchDocuments(String uid, String projectId) {
    return _docsCollection(uid, projectId).snapshots().map((snap) => snap.docs.map((d) {
          final data = d.data();
          return GeneratedDocument(
            id: d.id,
            type: DocumentType.values.firstWhere((t) => t.name == data['type'], orElse: () => DocumentType.businessPlan),
            content: data['content'] as String? ?? '',
            generatedAt: (data['generatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
        }).toList());
  }

  Future<void> saveDocument(String uid, String projectId, DocumentType type, String content) async {
    await _docsCollection(uid, projectId).doc(type.name).set({
      'type': type.name,
      'content': content,
      'generatedAt': Timestamp.now(),
    });
  }
}