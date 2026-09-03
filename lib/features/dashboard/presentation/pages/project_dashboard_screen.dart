// lib/features/dashboard/presentation/pages/project_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';
import 'package:startupapp/features/dashboard/presentation/widgets/project_menu_sheet.dart';
import 'package:startupapp/features/home/presentation/pages/home_tab.dart';
import 'package:startupapp/features/ai_mentor/presentation/pages/ai_mentor_tab.dart';
import 'package:startupapp/features/calendar/presentation/pages/calendar_tab.dart';
import 'package:startupapp/features/notifications/presentation/pages/notifications_tab.dart';
import 'package:startupapp/features/expenses/presentation/pages/expenses_tab.dart';

final dashboardTabIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class ProjectDashboardScreen extends ConsumerWidget {
  const ProjectDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(selectedProjectProvider);
    final tabIndex = ref.watch(dashboardTabIndexProvider);

    if (project == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('No project selected.', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    final tabs = const [
      HomeTab(),
      AiMentorTab(),
      CalendarTab(),
      NotificationsTab(),
      ExpensesTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Startup Companion',
              style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.w500),
            ),
            Text(
              project.name,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white70),
            onPressed: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (_) => const ProjectMenuSheet(),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: tabIndex, children: tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: tabIndex,
            onTap: (i) => ref.read(dashboardTabIndexProvider.notifier).state = i,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.card,
            selectedItemColor: AppColors.accent,
            unselectedItemColor: Colors.white38,
            selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            showUnselectedLabels: true,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_rounded), label: 'AI Mentor'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'Calendar'),
              BottomNavigationBarItem(icon: Icon(Icons.notifications_rounded), label: 'Notifications'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Expenses'),
            ],
          ),
        ),
      ),
    );
  }
}