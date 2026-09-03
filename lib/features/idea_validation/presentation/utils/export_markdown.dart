import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/analysis_result.dart';
import '../../../../core/constants/app_colors.dart';

String buildPitchDeckMarkdown(AnalysisResult result) {
  final topPivot = result.pivots.isNotEmpty ? result.pivots.first : null;
  final buffer = StringBuffer();
  buffer.writeln('# ${result.industry} — Pitch Summary');
  buffer.writeln();
  buffer.writeln('**Original Idea:** ${result.rawIdea}');
  buffer.writeln();
  buffer.writeln('**VC Verdict:** _${result.verdict}_');
  buffer.writeln();
  buffer.writeln('## Defensibility Scores');
  buffer.writeln('- Market Saturation: ${result.scores.marketSaturation}/100');
  buffer.writeln('- IP Collision Risk: ${result.scores.ipCollisionRisk}/100');
  buffer.writeln('- Technical Feasibility: ${result.scores.technicalFeasibility}/100');
  buffer.writeln('- VC Investability: ${result.scores.vcInvestability}/100');
  buffer.writeln();
  buffer.writeln('## Flaw Mitigations');
  for (final f in result.flaws) {
    buffer.writeln('- $f');
  }
  buffer.writeln();
  if (topPivot != null) {
    buffer.writeln('## Recommended Pivot: ${topPivot.vector.label}');
    buffer.writeln('**${topPivot.title}**');
    buffer.writeln();
    buffer.writeln(topPivot.description);
  }
  return buffer.toString();
}

void exportPitchDeckMarkdown(BuildContext context, AnalysisResult result) {
  final markdown = buildPitchDeckMarkdown(result);
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Pitch Deck (Markdown)', style: TextStyle(color: AppColors.textPrimary)),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: SelectableText(
            markdown,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: markdown));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard!')),
            );
          },
          child: const Text('COPY', style: TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w700)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE', style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    ),
  );
}