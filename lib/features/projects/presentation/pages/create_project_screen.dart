// lib/features/projects/presentation/pages/create_project_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/projects/domain/entities/project.dart';
import 'package:startupapp/features/projects/presentation/providers/project_providers.dart';

class CreateProjectScreen extends ConsumerStatefulWidget {
  const CreateProjectScreen({super.key});
  @override
  ConsumerState<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends ConsumerState<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _problem = TextEditingController();
  final _solution = TextEditingController();
  final _targetCustomers = TextEditingController();
  final _industry = TextEditingController();
  String _stage = Project.stages.first;

  @override
  void dispose() {
    _name.dispose();
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final id = await ref.read(createProjectControllerProvider.notifier).create(
          name: _name.text.trim(),
          problem: _problem.text.trim(),
          solution: _solution.text.trim(),
          targetCustomers: _targetCustomers.text.trim(),
          industry: _industry.text.trim(),
          stage: _stage,
          description: _description.text.trim(),
        );
    if (id != null && mounted) {
      ref.read(selectedProjectIdProvider.notifier).state = id;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createProjectControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('New Startup Project', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Startup name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _description,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: _decoration('Short description'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _problem,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: _decoration('Problem you are solving'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _solution,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: _decoration('Proposed solution'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _targetCustomers,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Target customers'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _industry,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Industry / category'),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _stage,
                  dropdownColor: AppColors.card,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Current stage'),
                  items: Project.stages
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _stage = v ?? _stage),
                ),
                if (state.error != null) ...[
                  const SizedBox(height: 12),
                  Text(state.error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 26),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Create Project',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}