// lib/features/expenses/data/repositories/expense_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:startupapp/features/expenses/domain/entities/expense.dart';

class ExpenseRepository {
  final FirebaseFirestore _db;
  final String uid;
  final String projectId;
  ExpenseRepository(this._db, this.uid, this.projectId);

  CollectionReference<Map<String, dynamic>> get _col => _db
      .collection('users')
      .doc(uid)
      .collection('projects')
      .doc(projectId)
      .collection('expenses');

  Stream<List<Expense>> watchAll() {
    return _col.orderBy('date', descending: true).snapshots().map((s) => s.docs.map((d) {
          final m = d.data();
          return Expense(
            id: d.id,
            name: m['name'] ?? '',
            amount: (m['amount'] ?? 0).toDouble(),
            category: m['category'] ?? 'Other',
            date: (m['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
            description: m['description'] ?? '',
            isIncome: m['isIncome'] ?? false,
          );
        }).toList());
  }

  Future<void> add({
    required String name,
    required double amount,
    required String category,
    required DateTime date,
    required String description,
    required bool isIncome,
  }) async {
    await _col.add({
      'name': name,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'description': description,
      'isIncome': isIncome,
    });
  }

  Future<void> delete(String id) => _col.doc(id).delete();
}