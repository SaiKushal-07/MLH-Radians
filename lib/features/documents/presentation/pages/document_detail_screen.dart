// lib/features/documents/presentation/pages/document_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/generated_document.dart';
import '../providers/document_providers.dart';

class DocumentDetailScreen extends ConsumerStatefulWidget {
  const DocumentDetailScreen({super.key, required this.type, this.existing});
  final DocumentType type;
  final GeneratedDocument? existing;

  @override
  ConsumerState<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends ConsumerState<DocumentDetailScreen> {
  late TextEditingController _controller;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.existing?.content ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    await ref.read(documentControllerProvider.notifier).generate(widget.type);
    final docs = ref.read(documentsStreamProvider).value ?? [];
    final match = docs.where((d) => d.type == widget.type).toList();
    if (match.isNotEmpty) {
      setState(() => _controller.text = match.first.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentControllerProvider);
    ref.listen(documentsStreamProvider, (previous, next) {
      final docs = next.value ?? [];
      final match = docs.where((d) => d.type == widget.type).toList();
      if (match.isNotEmpty && !_editing) {
        _controller.text = match.first.content;
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(widget.type.label, style: const TextStyle(color: AppColors.textPrimary)),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: Icon(_editing ? Icons.check : Icons.edit_outlined, color: AppColors.accent),
              onPressed: () async {
                if (_editing) {
                  await ref.read(documentControllerProvider.notifier).saveEdit(widget.type, _controller.text);
                }
                setState(() => _editing = !_editing);
              },
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            tooltip: 'Regenerate',
            onPressed: state.isLoading ? null : _generate,
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.accent),
                  SizedBox(height: 12),
                  Text('Generating with AI...', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            )
          : _controller.text.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('No ${widget.type.label} yet', style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(widget.type.description, style: const TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _generate,
                          child: const Text('Generate with AI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: _editing
                      ? TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.card,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            contentPadding: const EdgeInsets.all(14),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(14)),
                            child: Text(_controller.text, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.5)),
                          ),
                        ),
                ),
    );
  }
}