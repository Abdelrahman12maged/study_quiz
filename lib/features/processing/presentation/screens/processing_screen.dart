import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/core/di/service_locator.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/error_state_view.dart';
import 'package:study_quiz/features/processing/presentation/cubit/processing_cubit.dart';
import 'package:study_quiz/features/processing/presentation/cubit/processing_state.dart';
import 'package:study_quiz/features/quiz/data/datasources/supabase_quiz_datasource.dart';

import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/features/processing/presentation/widgets/animated_progress_indicator.dart';
import 'package:study_quiz/features/processing/presentation/widgets/processing_stage_checklist.dart';

/// Processing screen — shows animated pipeline stages while the backend
/// processes the captured image. Uses Supabase Realtime for status updates.
class ProcessingScreen extends StatelessWidget {
  final String sessionId;
  const ProcessingScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProcessingCubit(
        sessionId: sessionId,
        ds: sl<SupabaseQuizDatasource>(),
      )..startProcessing(),
      child: const _ProcessingBody(),
    );
  }
}

class _ProcessingBody extends StatelessWidget {
  const _ProcessingBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProcessingCubit, ProcessingState>(
        listener: (context, state) {
          if (state is ProcessingComplete) {
            context.go('/quiz/${state.sessionId}');
          }
        },
        builder: (context, state) {
          if (state is ProcessingFailed) {
            // Using localized failure message here
            final l10n = AppLocalizations.of(context)!;
            return ErrorStateView(
              message: l10n.processingFailed,
              onRetry: () => context.pop(),
            );
          }
          if (state is ProcessingInProgress) {
            final l10n = AppLocalizations.of(context)!;
            final localizedStages = [
              l10n.stageReadingNotes,
              l10n.stageExtractingConcepts,
              l10n.stageGeneratingQuestions,
              l10n.stageFindingSources,
              l10n.stageAlmostReady,
            ];
            final currentStageLabel = state.stageIndex < localizedStages.length
                ? localizedStages[state.stageIndex]
                : state.stageLabel;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedProgressIndicator(
                      state: state,
                      localizedStageLabel: currentStageLabel,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ProcessingStageChecklist(
                      state: state,
                      localizedStages: localizedStages,
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
