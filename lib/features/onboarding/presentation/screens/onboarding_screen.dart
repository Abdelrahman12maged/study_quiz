import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:study_quiz/core/constants/app_constants.dart';
import 'package:study_quiz/core/routing/app_router.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/primary_button.dart';

import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/features/onboarding/presentation/widgets/onboarding_page_widget.dart';

/// Onboarding shown on first launch — 3 pages explaining the value prop.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  List<OnboardingPageModel> _getPages(AppLocalizations l10n) {
    return [
      OnboardingPageModel(
        icon: Icons.camera_alt_rounded,
        title: l10n.onboardingTitle1,
        subtitle: l10n.onboardingSubtitle1,
        gradient: const [Color(0xFF3B4FD8), Color(0xFF6C7BF0)],
      ),
      OnboardingPageModel(
        icon: Icons.auto_awesome_rounded,
        title: l10n.onboardingTitle2,
        subtitle: l10n.onboardingSubtitle2,
        gradient: const [Color(0xFF2BA89E), Color(0xFF5ECBC2)],
      ),
      OnboardingPageModel(
        icon: Icons.emoji_events_rounded,
        title: l10n.onboardingTitle3,
        subtitle: l10n.onboardingSubtitle3,
        gradient: const [Color(0xFFF5A623), Color(0xFFF7C26B)],
      ),
    ];
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingComplete, true);
    markOnboardingComplete(); // Update cached flag in router
    if (mounted) context.go('/sign-in');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final pages = _getPages(l10n);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: Text(l10n.skip, style: tt.labelLarge),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => OnboardingPageWidget(page: pages[i]),
              ),
            ),

            // Dots indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: SmoothPageIndicator(
                controller: _controller,
                count: pages.length,
                effect: WormEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  spacing: 12,
                  activeDotColor: cs.primary,
                  dotColor: cs.outlineVariant,
                ),
              ),
            ),

            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                0,
                AppSpacing.pagePadding,
                AppSpacing.xl,
              ),
              child: PrimaryButton(
                label: _currentPage == pages.length - 1
                    ? l10n.getStarted
                    : l10n.next,
                icon: _currentPage == pages.length - 1
                    ? Icons.arrow_forward_rounded
                    : null,
                onPressed: () {
                  if (_currentPage == pages.length - 1) {
                    _completeOnboarding();
                  } else {
                    _controller.nextPage(
                      duration: AppConstants.animMedium,
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
