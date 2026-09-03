// lib/features/tasks/data/models/task_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startupapp/features/tasks/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.date,
    super.time,
    required super.priority,
    required super.category,
    required super.reminder,
    required super.completed,
    required super.isNextAction,
    required super.createdAt,
  });

  factory TaskModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final m = doc.data() ?? {};
    return TaskModel(
      id: doc.id,
      title: m['title'] ?? '',
      description: m['description'] ?? '',
      date: (m['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      time: m['time'],
      priority: m['priority'] ?? 'Medium',
      category: m['category'] ?? 'Other',
      reminder: m['reminder'] ?? false,
      completed: m['completed'] ?? false,
      isNextAction: m['isNextAction'] ?? false,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)),
        'time': time,
        'priority': priority,
        'category': category,
        'reminder': reminder,
        'completed': completed,
        'isNextAction': isNextAction,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}