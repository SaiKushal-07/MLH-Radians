// lib/features/projects/domain/entities/project.dart
class Project {
  final String id;
  final String name;
  final String description;
  final String problem;
  final String solution;
  final String targetCustomers;
  final String industry;
  final String stage;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.problem,
    required this.solution,
    required this.targetCustomers,
    required this.industry,
    required this.stage,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
  });

  static const stages = [
    'Idea',
    'Validation',
    'Business Planning',
    'Registration',
    'MVP',
    'Funding',
    'Launch',
    'Growth',
  ];

  int get stageIndex => stages.indexOf(stage).clamp(0, stages.length - 1);

  Project copyWith({
    String? name,
    String? description,
    String? problem,
    String? solution,
    String? targetCustomers,
    String? industry,
    String? stage,
    double? progress,
    DateTime? updatedAt,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      problem: problem ?? this.problem,
      solution: solution ?? this.solution,
      targetCustomers: targetCustomers ?? this.targetCustomers,
      industry: industry ?? this.industry,
      stage: stage ?? this.stage,
      progress: progress ?? this.progress,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}