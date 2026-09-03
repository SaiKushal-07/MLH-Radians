// lib/features/calendar/presentation/pages/calendar_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/calendar/presentation/widgets/add_task_sheet.dart';
import 'package:startupapp/features/calendar/presentation/widgets/month_grid.dart';
import 'package:startupapp/features/tasks/presentation/providers/task_providers.dart';

class CalendarTab extends ConsumerWidget {
  const CalendarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(selectedCalendarMonthProvider);
    final selectedDate = ref.watch(selectedCalendarDateProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    final tasks = tasksAsync.valueOrNull ?? [];
    final markedDates = tasks.map((t) => t.date).toSet();
    final dayTasks = tasks.where((t) =>
        t.date.year == selectedDate.year && t.date.month == selectedDate.month && t.date.day == selectedDate.day).toList();

    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Startup Calendar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white70),
                      onPressed: () => ref.read(selectedCalendarMonthProvider.notifier).state =
                          DateTime(month.year, month.month - 1, 1),
                    ),
                    Text('${monthNames[month.month - 1]} ${month.year}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white70),
                      onPressed: () => ref.read(selectedCalendarMonthProvider.notifier).state =
                          DateTime(month.year, month.month + 1, 1),
                    ),
                  ],
                ),
                MonthGrid(
                  month: month,
                  selectedDate: selectedDate,
                  markedDates: markedDates,
                  onSelect: (d) => ref.read(selectedCalendarDateProvider.notifier).state = d,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              TextButton.icon(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => AddTaskSheet(initialDate: selectedDate),
                ),
                icon: const Icon(Icons.add, color: AppColors.accent, size: 18),
                label: const Text('Create Task', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (dayTasks.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No tasks for this day.', style: TextStyle(color: Colors.white38)),
            )
          else
            ...dayTasks.map((t) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      Checkbox(
                        value: t.completed,
                        activeColor: AppColors.accent,
                        onChanged: (v) => ref.read(taskRepositoryProvider)?.toggleComplete(t.id, v ?? false),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  decoration: t.completed ? TextDecoration.lineThrough : null,
                                  decorationColor: Colors.white38,
                                )),
                            if (t.time != null || t.category.isNotEmpty)
                              Text('${t.time ?? ''} · ${t.category} · ${t.priority}',
                                  style: const TextStyle(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 20),
                        onPressed: () => ref.read(taskRepositoryProvider)?.delete(t.id),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}