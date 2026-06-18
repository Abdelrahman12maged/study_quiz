import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/theme/color_schemes.dart';
import 'package:study_quiz/core/widgets/primary_button.dart';
import 'package:study_quiz/features/quiz/presentation/cubit/quiz_state.dart';

import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/features/quiz/presentation/widgets/review_item.dart';

/// Results screen — score summary + per-question review list.
class ResultsScreen extends StatefulWidget {
  final QuizCompleted result;
  const ResultsScreen({super.key, required this.result});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scoreAnim;
  bool _showMistakesOnly = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnim = Tween<double>(begin: 0, end: widget.result.percentage)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _scoreColor(double pct, BuildContext context) {
    final sem = AppSemanticColors.of(context);
    if (pct >= 0.8) return sem.success;
    if (pct >= 0.5) return sem.warning;
    return sem.error;
  }

  String _scoreMessage(double pct, AppLocalizations l10n) {
    if (pct >= 0.9) return l10n.scoreOutstanding;
    if (pct >= 0.7) return l10n.scoreWellDone;
    if (pct >= 0.5) return l10n.scoreGoodEffort;
    return l10n.scoreKeepStudying;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    
    final result = widget.result;
    final pct = result.percentage;
    final scoreColor = _scoreColor(pct, context);

    final filteredQuestions = _showMistakesOnly
        ? result.session.questions
            .asMap()
            .entries
            .where((e) => result.answers[e.key] != e.value.correctIndex)
            .toList()
        : result.session.questions.asMap().entries.toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            leading: const SizedBox.shrink(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scoreColor.withValues(alpha: 0.15),
                      cs.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      // Animated score circle
                      AnimatedBuilder(
                        animation: _scoreAnim,
                        builder: (_, __) => Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: CircularProgressIndicator(
                                value: _scoreAnim.value,
                                strokeWidth: 8,
                                backgroundColor:
                                    cs.surfaceContainerHigh,
                                valueColor:
                                    AlwaysStoppedAnimation(scoreColor),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Text(
                              '${(pct * 100).round()}%',
                              style: tt.headlineMedium?.copyWith(
                                color: scoreColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.scoreCorrectOfTotal(result.score, result.totalQuestions),
                        style: tt.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _scoreMessage(pct, l10n),
                        style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Action buttons
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding, AppSpacing.lg,
                AppSpacing.pagePadding, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: l10n.backToHome,
                      icon: Icons.home_rounded,
                      isExpanded: true,
                      onPressed: () => context.go('/home'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PrimaryButton(
                      label: l10n.newSession,
                      icon: Icons.camera_alt_rounded,
                      onPressed: () => context.go('/capture'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter toggle
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding, AppSpacing.lg,
                AppSpacing.pagePadding, AppSpacing.sm),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(l10n.review, style: tt.titleMedium),
                  const Spacer(),
                  FilterChip(
                    label: Text(l10n.mistakesOnly),
                    selected: _showMistakesOnly,
                    onSelected: (v) => setState(() => _showMistakesOnly = v),
                    selectedColor: cs.errorContainer,
                    checkmarkColor: cs.error,
                  ),
                ],
              ),
            ),
          ),

          // Question review list
          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding),
            sliver: SliverList.separated(
              itemCount: filteredQuestions.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) {
                final entry = filteredQuestions[i];
                final qIndex = entry.key;
                final q = entry.value;
                final userAnswer = result.answers[qIndex];
                final isCorrect = userAnswer == q.correctIndex;
                return ReviewItem(
                    question: q,
                    questionNumber: qIndex + 1,
                    userAnswerIndex: userAnswer,
                    isCorrect: isCorrect);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
        ],
      ),
    );
  }
}
