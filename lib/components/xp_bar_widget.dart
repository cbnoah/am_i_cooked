import 'package:flutter/material.dart';

/// Usage: XpBar(level: 5, currentXP: 350, maxXP: 500)
class XpBar extends StatelessWidget {
  final int level;
  final int currentXP;
  final int maxXP;
  final double height;

  const XpBar({
    super.key,
    this.level = 1,
    this.currentXP = 0,
    this.maxXP = 100,
    this.height = 12.0,
  });

  double get _progress {
    if (maxXP <= 0) return 0.0;
    return (currentXP / maxXP).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: color,
                  child: Text(
                    level.toString(),
                    style: TextStyle(
                      color: onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Niveau'),
              ],
            ),
            Text('$currentXP / $maxXP XP'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: height,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            semanticsLabel: 'XP progress',
          ),
        ),
      ],
    );
  }
}
