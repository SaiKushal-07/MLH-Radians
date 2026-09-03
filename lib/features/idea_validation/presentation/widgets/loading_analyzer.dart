import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class LoadingAnalyzer extends StatefulWidget {
  const LoadingAnalyzer({super.key});

  @override
  State<LoadingAnalyzer> createState() => _LoadingAnalyzerState();
}

class _LoadingAnalyzerState extends State<LoadingAnalyzer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _messageIndex = 0;
  bool _alive = true;

  static const List<String> _messages = [
    'Scanning for market collisions...',
    'Interrogating your business model...',
    'Calculating defensibility index...',
    'Drafting brutal but useful pivots...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _cycleMessages();
  }

  void _cycleMessages() async {
    while (_alive) {
      await Future.delayed(const Duration(milliseconds: 1800));
      if (!_alive) return;
      setState(() => _messageIndex = (_messageIndex + 1) % _messages.length);
    }
  }

  @override
  void dispose() {
    _alive = false;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120),
      child: Column(
        children: [
          RotationTransition(
            turns: _controller,
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [AppColors.accentGold, Colors.transparent, AppColors.accentGold],
                ),
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.bgPrimary),
                  child: const Icon(Icons.gavel_rounded, color: AppColors.accentGold, size: 30),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              _messages[_messageIndex],
              key: ValueKey(_messageIndex),
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}