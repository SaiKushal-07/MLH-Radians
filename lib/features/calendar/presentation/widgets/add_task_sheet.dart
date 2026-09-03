// lib/features/calendar/presentation/widgets/add_task_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/tasks/domain/entities/task.dart';
import 'package:startupapp/features/tasks/presentation/providers/task_providers.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  final DateTime initialDate;
  const AddTaskSheet({super.key, required this.initialDate});
  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _time = TextEditingController();
  String _priority = 'Medium';
  String _category = Task.categories.first;
  bool _reminder = false;
  bool _addToNextActions = false;
  bool _saving = false;

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      );

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final repo = ref.read(taskRepositoryProvider);
    await repo?.add(
      title: _title.text.trim(),
      description: _description.text.trim(),
      date: widget.initialDate,
      time: _time.text.trim().isEmpty ? null : _time.text.trim(),
      priority: _priority,
      category: _category,
      reminder: _reminder,
      isNextAction: _addToNextActions,
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('New Task', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextField(controller: _title, style: const TextStyle(color: Colors.white), decoration: _decoration('Task title')),
            const SizedBox(height: 12),
            TextField(controller: _description, maxLines: 2, style: const TextStyle(color: Colors.white), decoration: _decoration('Description (optional)')),
            const SizedBox(height: 12),
            TextField(controller: _time, style: const TextStyle(color: Colors.white), decoration: _decoration('Time e.g. 10:00 AM (optional)')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _priority,
                    dropdownColor: AppColors.card,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: _decoration('Priority'),
                    items: Task.priorities.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (v) => setState(() => _priority = v ?? _priority),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    dropdownColor: AppColors.card,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: _decoration('Category'),
                    items: Task.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => setState(() => _category = v ?? _category),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              value: _reminder,
              onChanged: (v) => setState(() => _reminder = v),
              activeColor: AppColors.accent,
              contentPadding: EdgeInsets.zero,
              title: const Text('Set reminder', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            SwitchListTile(
              value: _addToNextActions,
              onChanged: (v) => setState(() => _addToNextActions = v),
              activeColor: AppColors.accent,
              contentPadding: EdgeInsets.zero,
              title: const Text('Add to Home next actions', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5))
                    : const Text('Add Task', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}