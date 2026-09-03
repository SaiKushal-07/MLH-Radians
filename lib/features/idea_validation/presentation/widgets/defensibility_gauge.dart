import 'package:flutter/material.dart';
import '../../domain/entities/analysis_result.dart';
import '../../../../core/constants/app_colors.dart';

class DefensibilityGauge extends StatelessWidget {
  const DefensibilityGauge({super.key, required this.scores});

  final ScoreMetrics scores;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricRing(
                label: 'Market\nSaturation',
                value: scores.marketSaturation,
                invert: true,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _MetricRing(
                label: 'IP Collision\nRisk',
                value: scores.ipCollisionRisk,
                invert: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricRing(
                label: 'Technical\nFeasibility',
                value: scores.technicalFeasibility,
                invert: false,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _MetricRing(
                label: 'VC\nInvestability',
                value: scores.vcInvestability,
                invert: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricRing extends StatelessWidget {
  const _MetricRing({required this.label, required this.value, required this.invert});

  final String label;
  final int value;
  final bool invert;

  Color get _color {
    final effective = invert ? 100 - value : value;
    if (effective >= 70) return AppColors.successGreen;
    if (effective >= 40) return AppColors.flawAmber;
    return AppColors.collisionRed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value / 100),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, _) => CircularProgressIndicator(
                    value: v,
                    strokeWidth: 7,
                    backgroundColor: AppColors.divider,
                    valueColor: AlwaysStoppedAnimation(_color),
                  ),
                ),
                Text('$value', style: TextStyle(color: _color, fontSize: 17, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              height: 1.3,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}