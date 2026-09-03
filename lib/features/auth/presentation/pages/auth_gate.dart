// lib/features/auth/presentation/pages/auth_gate.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/auth/presentation/pages/login_screen.dart';
import 'package:startupapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:startupapp/features/projects/presentation/pages/projects_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.when(
      data: (user) => user == null ? const LoginScreen() : const ProjectsScreen(),
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      ),
      error: (_, __) => const LoginScreen(),
    );
  }
}