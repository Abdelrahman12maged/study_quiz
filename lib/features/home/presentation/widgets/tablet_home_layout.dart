import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/empty_state_view.dart';
import 'package:study_quiz/features/home/presentation/cubit/home_state.dart';
import 'package:study_quiz/features/home/presentation/widgets/capture_cta.dart';
import 'package:study_quiz/features/home/presentation/widgets/session_list_item.dart';
import 'package:study_quiz/features/home/presentation/widgets/stats_row.dart';

class TabletHomeLayout extends StatelessWidget {
  final HomeLoaded state;
  const TabletHomeLayout({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text(l10n.appName),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          sliver: SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column: CTA + Stats
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CaptureCTA(onTap: () => context.go('/capture')),
                      const SizedBox(height: AppSpacing.lg),
                      StatsRow(state: state),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Right column: sessions
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.recentSessions, style: tt.titleMedium),
                          TextButton(
                            onPressed: () => context.go('/history'),
                            child: Text(l10n.seeAll),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (state.recentSessions.isEmpty)
                        EmptyStateView(
                          icon: Icons.library_books_rounded,
                          headline: l10n.noSessionsYet,
                          subtitle: l10n.capturePageSubtitle,
                        )
                      else
                        ...state.recentSessions
                            .take(5)
                            .map((s) => Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm),
                                  child: SessionListItem(session: s),
                                )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
