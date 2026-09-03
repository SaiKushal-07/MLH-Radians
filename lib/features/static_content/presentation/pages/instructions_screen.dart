// lib/features/static_content/presentation/pages/instructions_screen.dart
import 'package:flutter/material.dart';
import '../widgets/static_content_scaffold.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScaffold(
      title: 'Instructions',
      body: '''
Getting Started:
- Create a startup project from the Projects screen.
- Use the Home tab to see your roadmap, edit your idea, and track next actions.
- Use the Calendar tab to schedule and manage tasks.
- Use the Expenses tab to track your startup's spending and income.
- Use the Notifications tab to discover AI-curated grants, incubators, and competitions relevant to your stage.
- Use the AI Mentor tab to chat with an AI advisor about your specific startup.
- Use the Notepad (from this menu) to jot down free-form notes for your project.
- Use the AI Document Generator to auto-draft your Business Plan, Executive Summary, Pitch Content, or Grant Application.

You can switch between multiple startup projects at any time from your Profile screen.
''',
    );
  }
}