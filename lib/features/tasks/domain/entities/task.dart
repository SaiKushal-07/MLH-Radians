// lib/features/tasks/domain/entities/task.dart
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? time;
  final String priority; // Low, Medium, High
  final String category;
  final bool reminder;
  final bool completed;
  final bool isNextAction;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.time,
    required this.priority,
    required this.category,
    required this.reminder,
    required this.completed,
    required this.isNextAction,
    required this.createdAt,
  });

  static const priorities = ['Low', 'Medium', 'High'];
  static const categories = ['Product', 'Marketing', 'Legal', 'Research', 'Funding', 'Operations', 'Other'];

  Task copyWith({
    String? title,
    String? description,
    DateTime? date,
    String? time,
    String? priority,
    String? category,
    bool? reminder,
    bool? completed,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      reminder: reminder ?? this.reminder,
      completed: completed ?? this.completed,
      isNextAction: isNextAction,
      createdAt: createdAt,
    );
  }
}