// lib/features/home/presentation/widgets/roadmap_widget.dart
import 'package:flutter/material.dart';
import 'package:startupapp/core/constants/app_colors.dart';
import 'package:startupapp/features/projects/domain/entities/project.dart';

class RoadmapWidget extends StatelessWidget {
  final Project project;
  const RoadmapWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Project.stages.length,
        itemBuilder: (context, i) {
          final stage = Project.stages[i];
          final isDone = i < project.stageIndex;
          final isCurrent = i == project.stageIndex;
          final color = isDone
              ? Colors.greenAccent
              : (isCurrent ? AppColors.accent : Colors.white24);
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (i != 0)
                      Container(width: 20, height: 2, color: isDone ? Colors.greenAccent : Colors.white12),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent ? AppColors.accent : AppColors.card,
                        border: Border.all(color: color, width: 2),
                      ),
                      child: Icon(
                        isDone ? Icons.check : Icons.circle,
                        size: isDone ? 16 : 8,
                        color: isDone ? Colors.black : (isCurrent ? Colors.black : Colors.white24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 66,
                  child: Text(
                    stage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isCurrent ? AppColors.accent : Colors.white54,
                      fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}