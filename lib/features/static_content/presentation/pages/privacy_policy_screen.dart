// lib/features/static_content/presentation/pages/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import '../widgets/static_content_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScaffold(
      title: 'Privacy Policy',
      body: '''
We store the information you provide about your startup projects, tasks, expenses, and notes securely in Firebase, scoped to your account only.

Data you enter is only accessible to you and is never shared with other users. AI-generated content (mentor chats, opportunity suggestions, document drafts) is generated using your project details and is stored under your account.

We do not sell or share your personal data with third parties beyond the infrastructure providers (Firebase, Google Gemini API) necessary to run this app.

You may delete your projects and associated data at any time from within the app.
''',
    );
  }
}