import 'package:flutter/material.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/empty_state_view.dart';
import 'package:study_quiz/features/history/presentation/cubit/history_state.dart';
import 'package:study_quiz/features/history/presentation/widgets/history_header.dart';
import 'package:study_quiz/features/history/presentation/widgets/history_session_card.dart';

class HistoryGridLayout extends StatelessWidget {
  final HistoryLoaded state;
  const HistoryGridLayout({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessions = state.filteredSessions;

    return CustomScrollView(
      slivers: [
        SliverAppBar(floating: true, title: Text(l10n.history)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.md,
              AppSpacing.xl, 0),
          sliver: SliverToBoxAdapter(child: HistoryHeader(state: state)),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        if (sessions.isEmpty)
          SliverToBoxAdapter(
            child: EmptyStateView(
              icon: Icons.history_rounded,
              headline: l10n.noSessionsFound,
              subtitle: l10n.tryDifferentFilter,
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverGrid.builder(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 2.5,
              ),
              itemCount: sessions.length,
              itemBuilder: (_, i) => HistorySessionCard(session: sessions[i]),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
      ],
    );
  }
}
