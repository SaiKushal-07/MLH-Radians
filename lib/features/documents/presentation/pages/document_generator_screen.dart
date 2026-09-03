// lib/features/documents/presentation/pages/document_generator_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/generated_document.dart';
import '../providers/document_providers.dart';
import 'document_detail_screen.dart';

class DocumentGeneratorScreen extends ConsumerWidget {
  const DocumentGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docsAsync = ref.watch(documentsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('AI Document Generator', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: docsAsync.when(
        data: (docs) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: DocumentType.values.map((type) {
              final existing = docs.where((d) => d.type == type).toList();
              final hasDoc = existing.isNotEmpty;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type.label,
                              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(type.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          if (hasDoc) ...[
                            const SizedBox(height: 6),
                            const Text('Generated', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: hasDoc ? AppColors.card : AppColors.accent,
                        side: hasDoc ? const BorderSide(color: AppColors.divider) : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DocumentDetailScreen(
                              type: type,
                              existing: hasDoc ? existing.first : null,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        hasDoc ? 'View' : 'Generate',
                        style: TextStyle(color: hasDoc ? AppColors.textPrimary : Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.textSecondary))),
      ),
    );
  }
}