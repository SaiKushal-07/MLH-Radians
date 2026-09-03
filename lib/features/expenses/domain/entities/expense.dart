// lib/features/expenses/domain/entities/expense.dart
class Expense {
  final String id;
  final String name;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final bool isIncome;

  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
    required this.isIncome,
  });

  static const categories = ['Development', 'Marketing', 'Operations', 'Equipment', 'Legal', 'Registration', 'Other'];
}