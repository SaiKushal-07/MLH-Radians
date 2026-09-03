// lib/features/projects/presentation/pages/projects_screen.dart
import 'package:flutter/material.dart';
import 'package:startupapp/core/constants/app_colors.dart';

/// Phase 1 stub — Phase 2 will add real project cards, Firestore-backed
/// project list, and the "Create Project" flow.
class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const SafeArea(
        child: Center(
          child: Text(
            'My Projects\n(coming in Phase 2)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      ),
    );
  }
}