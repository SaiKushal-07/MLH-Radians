// lib/features/projects/presentation/pages/projects_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:startupapp/features/projects/presentation/pages/create_project_screen.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';
import 'package:startupapp/features/projects/presentation/widgets/project_card.dart';
import 'package:startupapp/features/dashboard/presentation/pages/project_dashboard_screen.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Startup Companion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('My Projects', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white54),
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
                  ),
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: const Text(
                    'Create Startup Project',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: projectsAsync.when(
                data: (projects) {
                  if (projects.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No startup projects yet.\nTap "Create Startup Project" to begin.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: projects.length,
                    itemBuilder: (context, i) {
                      final project = projects[i];
                      return ProjectCard(
                        project: project,
                        onOpen: () {
                          ref.read(selectedProjectIdProvider.notifier).state = project.id;
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ProjectDashboardScreen()),
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                error: (_, __) => const Center(
                  child: Text('Failed to load projects.', style: TextStyle(color: Colors.white54)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}