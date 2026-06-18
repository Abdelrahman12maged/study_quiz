import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/empty_state_view.dart';
import 'package:study_quiz/features/home/presentation/cubit/home_state.dart';
import 'package:study_quiz/features/home/presentation/widgets/capture_cta.dart';
import 'package:study_quiz/features/home/presentation/widgets/session_list_item.dart';
import 'package:study_quiz/features/home/presentation/widgets/stats_row.dart';

class MobileHomeLayout extends StatelessWidget {
  final HomeLoaded state;
  const MobileHomeLayout({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomScrollView(
      slivers: [
        // App bar
        SliverAppBar(
          floating: true,
          title: Text(l10n.appName),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          sliver: SliverList.list(
            children: [
              // Stats cards row
              StatsRow(state: state),
              const SizedBox(height: AppSpacing.lg),

              // Big CTA
              CaptureCTA(onTap: () => context.go('/capture')),
              const SizedBox(height: AppSpacing.lg),

              // Recent sessions header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.recentSessions,
                      style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () => context.go('/history'),
                    child: Text(l10n.seeAll),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Sessions list
              if (state.recentSessions.isEmpty)
                EmptyStateView(
                  icon: Icons.library_books_rounded,
                  headline: l10n.noSessionsYet,
                  subtitle: l10n.captureFirstPageSubtitle,
                )
              else
                ...state.recentSessions
                    .take(5)
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: SessionListItem(session: s),
                        )),
            ],
          ),
        ),
      ],
    );
  }
}
