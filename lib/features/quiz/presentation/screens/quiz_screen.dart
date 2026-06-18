import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/core/di/service_locator.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/loading_indicator.dart';
import 'package:study_quiz/core/widgets/error_state_view.dart';
import 'package:study_quiz/core/widgets/primary_button.dart';
import 'package:study_quiz/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:study_quiz/features/quiz/presentation/cubit/quiz_cubit.dart';
import 'package:study_quiz/features/quiz/presentation/cubit/quiz_state.dart';

import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/features/quiz/presentation/widgets/answer_option.dart';
import 'package:study_quiz/features/quiz/presentation/widgets/question_type_badge.dart';
import 'package:study_quiz/features/quiz/presentation/widgets/explanation_card.dart';

class QuizScreen extends StatelessWidget {
  final String sessionId;
  const QuizScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizCubit(sl<QuizRepository>())..loadQuiz(sessionId),
      child: const _QuizBody(),
    );
  }
}

class _QuizBody extends StatelessWidget {
  const _QuizBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state is QuizCompleted) {
          context.go(
            '/results/${state.session.id}',
            extra: state,
          );
        }
      },
      builder: (context, state) {
        if (state is QuizLoading) {
          return const Scaffold(body: Center(child: LoadingIndicator()));
        }
        if (state is QuizError) {
          return Scaffold(
            body: ErrorStateView(message: state.message, onRetry: () => context.pop()),
          );
        }
        if (state is QuizActive) {
          return _QuizActiveView(state: state);
        }
        return const Scaffold(body: SizedBox.shrink());
      },
    );
  }
}

class _QuizActiveView extends StatelessWidget {
  final QuizActive state;
  const _QuizActiveView({required this.state});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.session.subject),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/home'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0,
              end: (state.currentIndex + 1) / state.totalQuestions,
            ),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            builder: (_, value, __) => LinearProgressIndicator(
              value: value,
              minHeight: 4,
              backgroundColor: cs.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation(cs.primary),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question count + type badge
                    Row(
                      children: [
                        Text(
                          l10n.questionOfTotal(state.currentIndex + 1, state.totalQuestions),
                          style: tt.labelMedium,
                        ),
                        const Spacer(),
                        QuestionTypeBadge(type: state.currentQuestion.type),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Question text
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        state.currentQuestion.text,
                        key: ValueKey(state.currentIndex),
                        style: tt.titleMedium?.copyWith(height: 1.5),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Answer options
                    ...List.generate(
                      state.currentQuestion.options.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: AnswerOption(
                          label: state.currentQuestion.options[i],
                          index: i,
                          state: state,
                          onTap: state.hasAnswered
                              ? null
                              : () => context.read<QuizCubit>().selectAnswer(i),
                        ),
                      ),
                    ),

                    // Explanation card (revealed after answering)
                    if (state.showExplanation) ...[
                      const SizedBox(height: AppSpacing.lg),
                      ExplanationCard(question: state.currentQuestion),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom action area
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.lg,
              ),
              child: state.hasAnswered
                  ? PrimaryButton(
                      label: state.isLastQuestion ? l10n.seeResults : l10n.nextQuestion,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: () => context.read<QuizCubit>().nextQuestion(),
                    )
                  : PrimaryButton(
                      label: l10n.confirmAnswer,
                      onPressed: state.lastSelectedIndex != null
                          ? () => context.read<QuizCubit>().confirmAnswer()
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
