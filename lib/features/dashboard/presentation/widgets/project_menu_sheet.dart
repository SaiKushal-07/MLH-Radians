// lib/features/dashboard/presentation/widgets/project_menu_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';

class ProjectMenuSheet extends ConsumerWidget {
  const ProjectMenuSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).valueOrNull;

    Widget item(IconData icon, String label, VoidCallback onTap, {Color? color}) {
      return ListTile(
        leading: Icon(icon, color: color ?? Colors.white70),
        title: Text(label, style: TextStyle(color: color ?? Colors.white, fontSize: 15)),
        onTap: onTap,
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
            ),
            if (user != null && !user.isAnonymous)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  user.email ?? '',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            item(Icons.person_outline, 'Profile', () {
              Navigator.pop(context);
              // TODO Phase: profile screen
            }),
            item(Icons.swap_horiz_rounded, 'Switch Startup Project', () {
              Navigator.pop(context);
              ref.read(selectedProjectIdProvider.notifier).state = null;
              Navigator.of(context).popUntil((r) => r.isFirst);
            }),
            item(Icons.map_outlined, 'Entrepreneur Roadmap Guide', () {
              Navigator.pop(context);
              // TODO Phase: static guide screen
            }),
            item(Icons.help_outline_rounded, 'Instructions', () {
              Navigator.pop(context);
              // TODO Phase: instructions screen
            }),
            item(Icons.privacy_tip_outlined, 'Privacy Policy', () {
              Navigator.pop(context);
              // TODO Phase: privacy policy screen
            }),
            item(Icons.description_outlined, 'Terms & Conditions', () {
              Navigator.pop(context);
              // TODO Phase: terms screen
            }),
            const Divider(color: Colors.white12, height: 20),
            item(Icons.logout_rounded, 'Logout', () async {
              Navigator.pop(context);
              await ref.read(authRepositoryProvider).signOut();
            }, color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}