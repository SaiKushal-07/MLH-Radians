// lib/features/home/presentation/pages/edit_idea_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/projects/domain/entities/project.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';

class EditIdeaScreen extends ConsumerStatefulWidget {
  final Project project;
  const EditIdeaScreen({super.key, required this.project});
  @override
  ConsumerState<EditIdeaScreen> createState() => _EditIdeaScreenState();
}

class _EditIdeaScreenState extends ConsumerState<EditIdeaScreen> {
  late final TextEditingController _description;
  late final TextEditingController _problem;
  late final TextEditingController _solution;
  late final TextEditingController _targetCustomers;
  late final TextEditingController _industry;
  late String _stage;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _description = TextEditingController(text: widget.project.description);
    _problem = TextEditingController(text: widget.project.problem);
    _solution = TextEditingController(text: widget.project.solution);
    _targetCustomers = TextEditingController(text: widget.project.targetCustomers);
    _industry = TextEditingController(text: widget.project.industry);
    _stage = widget.project.stage;
  }

  @override
  void dispose() {
    _description.dispose();
    _problem.dispose();
    _solution.dispose();
    _targetCustomers.dispose();
    _industry.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      );

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(projectRepositoryProvider);
    if (repo != null) {
      await repo.updateProject(widget.project.copyWith(
        description: _description.text.trim(),
        problem: _problem.text.trim(),
        solution: _solution.text.trim(),
        targetCustomers: _targetCustomers.text.trim(),
        industry: _industry.text.trim(),
        stage: _stage,
      ));
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Startup Idea', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _description,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Short description'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _problem,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Problem'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _solution,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Solution'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _targetCustomers,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Target customers'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _industry,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Industry'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: _stage,
                dropdownColor: AppColors.card,
                style: const TextStyle(color: Colors.white),
                decoration: _decoration('Current stage'),
                items: Project.stages.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _stage = v ?? _stage),
              ),
              const SizedBox(height: 26),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 22, width: 22,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                        )
                      : const Text('Save Changes',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}