// lib/features/tasks/data/repositories/task_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startupapp/features/tasks/data/models/task_model.dart';
import 'package:startupapp/features/tasks/domain/entities/task.dart';

class TaskRepository {
  final FirebaseFirestore _db;
  final String uid;
  final String projectId;
  TaskRepository(this._db, this.uid, this.projectId);

  CollectionReference<Map<String, dynamic>> get _col => _db
      .collection('users')
      .doc(uid)
      .collection('projects')
      .doc(projectId)
      .collection('tasks');

  Stream<List<Task>> watchAll() {
    return _col.orderBy('date').snapshots().map(
          (s) => s.docs.map((d) => TaskModel.fromDoc(d)).toList(),
        );
  }

  Future<void> add({
    required String title,
    required String description,
    required DateTime date,
    String? time,
    required String priority,
    required String category,
    required bool reminder,
    bool isNextAction = false,
  }) async {
    final model = TaskModel(
      id: '',
      title: title,
      description: description,
      date: date,
      time: time,
      priority: priority,
      category: category,
      reminder: reminder,
      completed: false,
      isNextAction: isNextAction,
      createdAt: DateTime.now(),
    );
    await _col.add(model.toMap());
  }

  Future<void> toggleComplete(String taskId, bool value) =>
      _col.doc(taskId).update({'completed': value});

  Future<void> delete(String taskId) => _col.doc(taskId).delete();

  Future<int> countAll() async => (await _col.limit(1).get()).docs.length;
}