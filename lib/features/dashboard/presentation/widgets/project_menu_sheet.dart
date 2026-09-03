// lib/features/dashboard/presentation/widgets/project_menu_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../projects/presentation/pages/projects_screen.dart';
import '../../../notepad/presentation/pages/notepad_screen.dart';
import '../../../documents/presentation/pages/document_generator_screen.dart';
import '../../../static_content/presentation/pages/roadmap_guide_screen.dart';
import '../../../static_content/presentation/pages/instructions_screen.dart';
import '../../../static_content/presentation/pages/privacy_policy_screen.dart';
import '../../../static_content/presentation/pages/terms_screen.dart';

class ProjectMenuSheet extends ConsumerWidget {
  const ProjectMenuSheet({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MenuTile(icon: Icons.person_outline, label: 'Profile', onTap: () => _navigate(context, const ProfileScreen())),
            _MenuTile(icon: Icons.swap_horiz, label: 'Switch Project', onTap: () => _navigate(context, const ProjectsScreen())),
            _MenuTile(icon: Icons.note_alt_outlined, label: 'Notepad', onTap: () => _navigate(context, const NotepadScreen())),
            _MenuTile(icon: Icons.description_outlined, label: 'AI Document Generator', onTap: () => _navigate(context, const DocumentGeneratorScreen())),
            _MenuTile(icon: Icons.map_outlined, label: 'Roadmap Guide', onTap: () => _navigate(context, const RoadmapGuideScreen())),
            _MenuTile(icon: Icons.help_outline, label: 'Instructions', onTap: () => _navigate(context, const InstructionsScreen())),
            _MenuTile(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () => _navigate(context, const PrivacyPolicyScreen())),
            _MenuTile(icon: Icons.gavel_outlined, label: 'Terms & Conditions', onTap: () => _navigate(context, const TermsScreen())),
            const Divider(color: AppColors.divider, height: 24),
            _MenuTile(
              icon: Icons.logout,
              label: 'Logout',
              color: AppColors.danger,
              onTap: () async {
                Navigator.pop(context);
                await ref.read(authRepositoryProvider).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary),
      title: Text(label, style: TextStyle(color: color ?? AppColors.textPrimary)),
      onTap: onTap,
    );
  }
}