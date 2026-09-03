// lib/features/static_content/presentation/widgets/static_content_scaffold.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class StaticContentScaffold extends StatelessWidget {
  const StaticContentScaffold({super.key, required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(body, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
      ),
    );
  }
}