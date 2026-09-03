// lib/features/projects/data/repositories/project_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startupapp/features/projects/data/models/project_model.dart';
import 'package:startupapp/features/projects/domain/entities/project.dart';

class ProjectRepository {
  final FirebaseFirestore _db;
  final String uid;
  ProjectRepository(this._db, this.uid);

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('users').doc(uid).collection('projects');

  Stream<List<Project>> watchProjects() {
    return _col.orderBy('updatedAt', descending: true).snapshots().map(
          (snap) => snap.docs.map((d) => ProjectModel.fromDoc(d)).toList(),
        );
  }

  Future<Project> createProject({
    required String name,
    required String problem,
    required String solution,
    required String targetCustomers,
    required String industry,
    required String stage,
    required String description,
  }) async {
    final now = DateTime.now();
    final docRef = _col.doc();
    final model = ProjectModel(
      id: docRef.id,
      name: name,
      description: description,
      problem: problem,
      solution: solution,
      targetCustomers: targetCustomers,
      industry: industry,
      stage: stage,
      progress: 0,
      createdAt: now,
      updatedAt: now,
    );
    await docRef.set(model.toMap());
    return model;
  }

  Future<void> updateProject(Project project) async {
    final model = ProjectModel.fromEntity(project.copyWith(updatedAt: DateTime.now()));
    await _col.doc(project.id).update(model.toMap());
  }

  Future<void> deleteProject(String projectId) => _col.doc(projectId).delete();
}