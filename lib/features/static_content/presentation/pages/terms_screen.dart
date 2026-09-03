// lib/features/static_content/presentation/pages/terms_screen.dart
import 'package:flutter/material.dart';
import '../widgets/static_content_scaffold.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScaffold(
      title: 'Terms & Conditions',
      body: '''
By using this app, you agree to use it for lawful purposes related to planning and managing your startup venture.

AI-generated content (mentor advice, opportunity listings, document drafts) is provided for informational purposes only and should not be treated as legal, financial, or professional advice. Always verify grant, funding, and legal information independently before acting on it.

This app is provided "as is" without warranty of any kind. We are not liable for business decisions made based on content generated within the app.

We may update these terms as the app evolves; continued use constitutes acceptance of any changes.
''',
    );
  }
}