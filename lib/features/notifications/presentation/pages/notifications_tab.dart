// lib/features/notifications/presentation/pages/notifications_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/notifications/presentation/providers/opportunity_providers.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';

class NotificationsTab extends ConsumerStatefulWidget {
  const NotificationsTab({super.key});
  @override
  ConsumerState<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends ConsumerState<NotificationsTab> {
  bool _seedChecked = false;
  bool _loading = false;

  Future<void> _seedIfEmpty() async {
    if (_seedChecked) return;
    _seedChecked = true;
    final repo = ref.read(opportunityRepositoryProvider);
    final project = ref.read(selectedProjectProvider);
    if (repo == null || project == null) return;
    final count = await repo.countAll();
    if (count == 0) {
      setState(() => _loading = true);
      await repo.refresh(industry: project.industry, stage: project.stage);
      if (mounted) setState(() => _loading = false);
    }
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Government Scheme':
        return Colors.blueAccent;
      case 'Grant':
        return Colors.greenAccent;
      case 'Incubator':
      case 'Accelerator':
        return Colors.purpleAccent;
      case 'Competition':
      case 'Hackathon':
        return Colors.orangeAccent;
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);
    final opportunities = opportunitiesAsync.valueOrNull ?? [];
    final project = ref.watch(selectedProjectProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) => _seedIfEmpty());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Opportunities', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
              TextButton.icon(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() => _loading = true);
                        await ref.read(opportunityRepositoryProvider)?.refresh(
                              industry: project?.industry ?? '',
                              stage: project?.stage ?? 'Idea',
                            );
                        if (mounted) setState(() => _loading = false);
                      },
                icon: const Icon(Icons.refresh, color: AppColors.accent, size: 18),
                label: const Text('Refresh', style: TextStyle(color: AppColors.accent)),
              ),
            ],
          ),
          const Text(
            'AI-curated suggestions based on your industry & stage — verify details before applying.',
            style: TextStyle(color: Colors.white38, fontSize: 11.5),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator(color: AppColors.accent)),
            )
          else if (opportunities.isEmpty)
            const Text('No opportunities yet. Tap Refresh.', style: TextStyle(color: Colors.white38))
          else
            ...opportunities.map((o) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _categoryColor(o['category'] ?? '').withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(o['category'] ?? '',
                                style: TextStyle(color: _categoryColor(o['category'] ?? ''), fontSize: 10.5, fontWeight: FontWeight.w600)),
                          ),
                          const Spacer(),
                          Text('Deadline: ${o['deadline'] ?? 'N/A'}',
                              style: const TextStyle(color: Colors.white38, fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(o['title'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(o['description'] ?? '', style: const TextStyle(color: Colors.white60, fontSize: 12.5)),
                      const SizedBox(height: 6),
                      Text('Source: ${o['source'] ?? ''}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}