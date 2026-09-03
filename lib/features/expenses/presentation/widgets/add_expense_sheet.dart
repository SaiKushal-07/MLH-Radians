// lib/features/expenses/presentation/widgets/add_expense_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/expenses/domain/entities/expense.dart';
import 'package:startupapp/features/expenses/presentation/providers/expense_providers.dart';

class AddExpenseSheet extends ConsumerStatefulWidget {
  const AddExpenseSheet({super.key});
  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  String _category = Expense.categories.first;
  bool _isIncome = false;
  bool _saving = false;

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      );

  Future<void> _save() async {
    final amount = double.tryParse(_amount.text.trim());
    if (_name.text.trim().isEmpty || amount == null) return;
    setState(() => _saving = true);
    await ref.read(expenseRepositoryProvider)?.add(
          name: _name.text.trim(),
          amount: amount,
          category: _category,
          date: DateTime.now(),
          description: _description.text.trim(),
          isIncome: _isIncome,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: !_isIncome,
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(color: !_isIncome ? Colors.black : Colors.white70),
                  onSelected: (_) => setState(() => _isIncome = false),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _isIncome,
                  selectedColor: AppColors.accent,
                  labelStyle: TextStyle(color: _isIncome ? Colors.black : Colors.white70),
                  onSelected: (_) => setState(() => _isIncome = true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(controller: _name, style: const TextStyle(color: Colors.white), decoration: _decoration('Name')),
            const SizedBox(height: 12),
            TextField(controller: _amount, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white), decoration: _decoration('Amount (₹)')),
            const SizedBox(height: 12),
            if (!_isIncome)
              DropdownButtonFormField<String>(
                value: _category,
                dropdownColor: AppColors.card,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: _decoration('Category'),
                items: Expense.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
              ),
            const SizedBox(height: 12),
            TextField(controller: _description, maxLines: 2, style: const TextStyle(color: Colors.white), decoration: _decoration('Description (optional)')),
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5))
                    : const Text('Add', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}