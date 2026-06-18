import 'package:flutter/material.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';

class OnboardingPageModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const OnboardingPageModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPageModel page;
  
  const OnboardingPageWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gradient icon circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: page.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: page.gradient.first.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(page.icon, size: 56, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            page.title,
            style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            page.subtitle,
            style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
