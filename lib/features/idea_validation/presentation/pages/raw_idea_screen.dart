import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/idea_providers.dart';
import '../widgets/loading_analyzer.dart';
import 'results_screen.dart';

class RawIdeaScreen extends ConsumerStatefulWidget {
  const RawIdeaScreen({super.key});

  @override
  ConsumerState<RawIdeaScreen> createState() => _RawIdeaScreenState();
}

class _RawIdeaScreenState extends ConsumerState<RawIdeaScreen> {
  final _ideaController = TextEditingController();
  String _industry = 'Consumer / B2C';

  static const List<String> _industries = [
    'Consumer / B2C',
    'B2B / SaaS',
    'FinTech',
    'HealthTech',
    'EdTech',
    'AI / ML Tools',
    'E-commerce',
    'Climate / GreenTech',
    'Social / Community',
    'Other',
  ];

  @override
  void dispose() {
    _ideaController.dispose();
    super.dispose();
  }

  void _listenForResult() {
    ref.listen<AnalysisState>(analysisControllerProvider, (previous, next) {
      if (next.status == AnalysisStatus.success && next.result != null) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultsScreen(result: next.result!)),
        );
      }
      if (next.status == AnalysisStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.collisionRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listenForResult();
    final state = ref.watch(analysisControllerProvider);
    final isLoading = state.status == AnalysisStatus.loading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgPrimary, Color(0xFF0B1220)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: isLoading
                    ? const LoadingAnalyzer()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 36),
                          _buildIdeaCard(),
                          const SizedBox(height: 20),
                          _buildSubmitButton(),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.gavel_rounded, color: AppColors.accentGold, size: 26),
            ),
            const SizedBox(width: 14),
            const Text(
              'VETO',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Pitch your raw idea. Get torn apart before the market does it for you.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 15.5, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildIdeaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR IDEA',
            style: TextStyle(
              color: AppColors.accentGold,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _ideaController,
            maxLines: 6,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15.5, height: 1.5),
            decoration: const InputDecoration(
              hintText:
                  'e.g. An app that uses AI to match roommates based on cleanliness habits and sleep schedules...',
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'INDUSTRY',
            style: TextStyle(
              color: AppColors.accentGold,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgPrimary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _industry,
                isExpanded: true,
                dropdownColor: AppColors.surfaceCardElevated,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.accentGold),
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                borderRadius: BorderRadius.circular(16),
                items: _industries.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                onChanged: (v) => setState(() => _industry = v ?? _industry),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            ref.read(analysisControllerProvider.notifier).submitIdea(
                  rawIdea: _ideaController.text,
                  industry: _industry,
                );
          },
          icon: const Icon(Icons.local_fire_department_rounded),
          label: const Text('PITCH TO VC'),
        ),
      ),
    );
  }
}