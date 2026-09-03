// lib/features/expenses/presentation/pages/expenses_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/expenses/presentation/providers/expense_providers.dart';
import 'package:startupapp/features/expenses/presentation/widgets/add_expense_sheet.dart';

class ExpensesTab extends ConsumerWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesStreamProvider);
    final expenses = expensesAsync.valueOrNull ?? [];

    final totalIncome = expenses.where((e) => e.isIncome).fold(0.0, (s, e) => s + e.amount);
    final totalExpense = expenses.where((e) => !e.isIncome).fold(0.0, (s, e) => s + e.amount);
    final balance = totalIncome - totalExpense;
    final now = DateTime.now();
    final monthlySpend = expenses
        .where((e) => !e.isIncome && e.date.month == now.month && e.date.year == now.year)
        .fold(0.0, (s, e) => s + e.amount);

    final categoryTotals = <String, double>{};
    for (final e in expenses.where((e) => !e.isIncome)) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }
    final maxCategory = categoryTotals.values.isEmpty ? 1.0 : categoryTotals.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const AddExpenseSheet(),
        ),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _statCard('Balance', balance, balance >= 0 ? Colors.greenAccent : Colors.redAccent),
                const SizedBox(width: 10),
                _statCard('Total Income', totalIncome, Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _statCard('Total Expenses', totalExpense, Colors.redAccent),
                const SizedBox(width: 10),
                _statCard('This Month', monthlySpend, AppColors.accent),
              ],
            ),
            const SizedBox(height: 24),
            if (categoryTotals.isNotEmpty) ...[
              const Text('Spending by Category', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ...categoryTotals.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key, style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                            Text('₹${entry.value.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: entry.value / maxCategory,
                            minHeight: 8,
                            backgroundColor: Colors.white12,
                            valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
            ],
            const Text('Recent Transactions', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (expenses.isEmpty)
              const Text('No transactions yet.', style: TextStyle(color: Colors.white38))
            else
              ...expenses.map((e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      children: [
                        Icon(e.isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                            color: e.isIncome ? Colors.greenAccent : Colors.redAccent, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.name, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
                              Text('${e.category} · ${e.date.day}/${e.date.month}/${e.date.year}',
                                  style: const TextStyle(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ),
                        Text(
                          '${e.isIncome ? '+' : '-'}₹${e.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: e.isIncome ? Colors.greenAccent : Colors.redAccent,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white24, size: 16),
                          onPressed: () => ref.read(expenseRepositoryProvider)?.delete(e.id),
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, double value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 4),
            Text('₹${value.toStringAsFixed(0)}', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}