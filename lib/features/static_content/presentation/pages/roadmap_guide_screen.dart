// lib/features/static_content/presentation/pages/roadmap_guide_screen.dart
import 'package:flutter/material.dart';
import '../widgets/static_content_scaffold.dart';

class RoadmapGuideScreen extends StatelessWidget {
  const RoadmapGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const StaticContentScaffold(
      title: 'Entrepreneur Roadmap Guide',
      body: '''
Every startup on this platform follows an 8-stage roadmap:

1. Idea — Define the problem you're solving and who it affects.
2. Validation — Talk to potential customers, test assumptions, validate demand.
3. Business Planning — Define your business model, pricing, and go-to-market plan.
4. Registration — Register your company legally and set up compliance basics.
5. MVP — Build a minimum viable product to test with real users.
6. Funding — Explore grants, angel investors, or bootstrapping to fuel growth.
7. Launch — Bring your product to market publicly.
8. Growth — Scale acquisition, retention, and revenue.

Use the Home tab to track your current stage, and the AI Mentor to get advice tailored to wherever you are on this journey. The Notifications tab surfaces grants, incubators, and competitions relevant to your stage automatically.
''',
    );
  }
}