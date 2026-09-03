// lib/features/profile/presentation/pages/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../projects/presentation/providers/project_providers.dart';
import '../../../projects/domain/entities/project.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    final projectsAsync = ref.watch(projectsStreamProvider);
    final selectedProjectId = ref.watch(selectedProjectIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    (user?.email?.isNotEmpty == true) ? user!.email![0].toUpperCase() : 'G',
                    style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.isAnonymous == true ? 'Guest User' : (user?.email ?? 'Unknown'),
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                if (user?.isAnonymous != true && user?.email != null) ...[
                  const SizedBox(height: 4),
                  const Text('Signed in with email', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('My Startup Projects',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          projectsAsync.when(
            data: (projects) {
              if (projects.isEmpty) {
                return const Text('No projects yet.', style: TextStyle(color: AppColors.textSecondary));
              }
              return Column(
                children: projects.map((Project p) {
                  final isSelected = p.id == selectedProjectId;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? Border.all(color: AppColors.accent, width: 1.5) : null,
                    ),
                    child: ListTile(
                      title: Text(p.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                      subtitle: Text(p.stage, style: const TextStyle(color: AppColors.textSecondary)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.accent)
                          : TextButton(
                              onPressed: () {
                                ref.read(selectedProjectIdProvider.notifier).state = p.id;
                                Navigator.pop(context);
                              },
                              child: const Text('Switch'),
                            ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
            error: (e, _) => Text('Error: $e', style: const TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}