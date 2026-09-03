// lib/features/dashboard/presentation/pages/project_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';

/// Phase 2 stub — Phase 3 will add the 5-tab bottom nav (Home, AI Mentor,
/// Calendar, Notifications, Expenses) and the top-right project menu.
class ProjectDashboardScreen extends ConsumerWidget {
  const ProjectDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(project?.name ?? 'Dashboard', style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Text(
          '${project?.name ?? ''}\nDashboard coming in Phase 3',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}