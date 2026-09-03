// lib/features/home/presentation/pages/home_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/dashboard/presentation/pages/project_dashboard_screen.dart';
import 'package:startupapp/features/home/domain/stage_suggestions.dart';
import 'package:startupapp/features/home/presentation/pages/edit_idea_screen.dart';
import 'package:startupapp/features/home/presentation/widgets/roadmap_widget.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';
import 'package:startupapp/features/tasks/presentation/providers/task_providers.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});
  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  bool _seedChecked = false;

  Future<void> _seedDefaultsIfEmpty() async {
    if (_seedChecked) return;
    _seedChecked = true;
    final repo = ref.read(taskRepositoryProvider);
    final project = ref.read(selectedProjectProvider);
    if (repo == null || project == null) return;
    final count = await repo.countAll();
    if (count == 0) {
      final defaults = kStageDefaultActions[project.stage] ?? [];
      for (final title in defaults) {
        await repo.add(
          title: title,
          description: '',
          date: DateTime.now(),
          priority: 'Medium',
          category: 'Product',
          reminder: false,
          isNextAction: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(selectedProjectProvider);
    final nextActions = ref.watch(nextActionsProvider);
    final taskRepo = ref.watch(taskRepositoryProvider);

    if (project == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.accent));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _seedDefaultsIfEmpty());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(project.description.isEmpty ? 'No description yet' : project.description,
                    style: const TextStyle(color: Colors.white60, fontSize: 13.5)),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _statPill('Current Stage', project.stage),
                    const SizedBox(width: 10),
                    _statPill('Progress', '${project.progress.toInt()}%'),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (project.progress / 100).clamp(0, 1),
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Idea card
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditIdeaScreen(project: project)),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 18),
                      SizedBox(width: 8),
                      Text('Your Startup Idea',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                      Spacer(),
                      Icon(Icons.chevron_right, color: Colors.white38),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.solution.isEmpty ? 'Tap to add your solution details' : project.solution,
                    style: const TextStyle(color: Colors.white70, fontSize: 13.5, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text('Your Startup Journey',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          RoadmapWidget(project: project),
          const SizedBox(height: 24),

          const Text('Recommended Next Actions',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          if (nextActions.isEmpty)
            const Text('No pending actions — nice work!', style: TextStyle(color: Colors.white38))
          else
            ...nextActions.map((task) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: task.completed,
                        activeColor: AppColors.accent,
                        onChanged: (v) => taskRepo?.toggleComplete(task.id, v ?? false),
                      ),
                      Expanded(
                        child: Text(task.title, style: const TextStyle(color: Colors.white, fontSize: 13.5)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month_outlined, color: Colors.white38, size: 20),
                        onPressed: () {
                          ref.read(selectedCalendarDateProvider.notifier).state = task.date;
                          ref.read(dashboardTabIndexProvider.notifier).state = 2;
                        },
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _statPill(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}