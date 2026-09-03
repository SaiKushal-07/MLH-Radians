import 'package:flutter/material.dart';
import '../../domain/entities/analysis_result.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/defensibility_gauge.dart';
import '../widgets/collision_tag.dart';
import '../widgets/flaw_card.dart';
import '../widgets/pivot_badge.dart';
import '../utils/export_markdown.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.result});

  final AnalysisResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(context),
                  const SizedBox(height: 20),
                  _buildVerdictCard(),
                  const SizedBox(height: 24),
                  _sectionTitle('DEFENSIBILITY INDEX'),
                  const SizedBox(height: 14),
                  DefensibilityGauge(scores: result.scores),
                  const SizedBox(height: 28),
                  _sectionTitle('MARKET COLLISIONS', color: AppColors.collisionRed),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: result.collisions.map((c) => CollisionTag(label: c)).toList(),
                  ),
                  const SizedBox(height: 28),
                  _sectionTitle('CRITICAL FLAWS', color: AppColors.flawAmber),
                  const SizedBox(height: 12),
                  ...result.flaws.map(
                    (f) => Padding(padding: const EdgeInsets.only(bottom: 10), child: FlawCard(text: f)),
                  ),
                  const SizedBox(height: 28),
                  _sectionTitle('3-VECTOR PIVOTS', color: AppColors.pivotGold),
                  const SizedBox(height: 12),
                  ...result.pivots.map(
                    (p) => Padding(padding: const EdgeInsets.only(bottom: 10), child: PivotBadge(pivot: p)),
                  ),
                  const SizedBox(height: 28),
                  _buildExportButton(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
        ),
        const SizedBox(width: 4),
        const Text(
          'VC VERDICT',
          style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 0.6),
        ),
      ],
    );
  }

  Widget _buildVerdictCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accentGold.withOpacity(0.18), AppColors.surfaceCard],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded, color: AppColors.accentGold, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result.verdict,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {Color color = AppColors.textPrimary}) {
    return Row(
      children: [
        Container(width: 4, height: 16, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      ],
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => exportPitchDeckMarkdown(context, result),
        icon: const Icon(Icons.ios_share_rounded),
        label: const Text('EXPORT ONE-PAGE PITCH DECK'),
      ),
    );
  }
}