// lib/features/projects/data/models/project_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startupapp/features/projects/domain/entities/project.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.problem,
    required super.solution,
    required super.targetCustomers,
    required super.industry,
    required super.stage,
    required super.progress,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromMap(String id, Map<String, dynamic> map) {
    return ProjectModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      problem: map['problem'] ?? '',
      solution: map['solution'] ?? '',
      targetCustomers: map['targetCustomers'] ?? '',
      industry: map['industry'] ?? '',
      stage: map['stage'] ?? Project.stages.first,
      progress: (map['progress'] ?? 0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory ProjectModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ProjectModel.fromMap(doc.id, doc.data() ?? {});

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'problem': problem,
        'solution': solution,
        'targetCustomers': targetCustomers,
        'industry': industry,
        'stage': stage,
        'progress': progress,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  factory ProjectModel.fromEntity(Project p) => ProjectModel(
        id: p.id,
        name: p.name,
        description: p.description,
        problem: p.problem,
        solution: p.solution,
        targetCustomers: p.targetCustomers,
        industry: p.industry,
        stage: p.stage,
        progress: p.progress,
        createdAt: p.createdAt,
        updatedAt: p.updatedAt,
      );
}