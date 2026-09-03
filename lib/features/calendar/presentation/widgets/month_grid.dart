// lib/features/calendar/presentation/widgets/month_grid.dart
import 'package:flutter/material.dart';
import 'package:startupapp/core/constants/app_colors.dart';

class MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final Set<DateTime> markedDates;
  final ValueChanged<DateTime> onSelect;

  const MonthGrid({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.markedDates,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday % 7; // Sunday-start grid

    final cells = <Widget>[];
    for (int i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox());
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(month.year, month.month, d);
      final isSelected = date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
      final isMarked = markedDates.any((m) => m.year == date.year && m.month == date.month && m.day == date.day);
      final isToday = _isSameDay(date, DateTime.now());

      cells.add(
        GestureDetector(
          onTap: () => onSelect(date),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : (isToday ? AppColors.accent.withOpacity(0.15) : Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$d',
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
                if (isMarked && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    const weekLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Column(
      children: [
        Row(
          children: weekLabels
              .map((w) => Expanded(
                    child: Center(
                      child: Text(w, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 4),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          children: cells,
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
}