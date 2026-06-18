import 'package:flutter/material.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/app_card.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Icon(icon, color: cs.primary, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(value,
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          Text(subtitle,
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
