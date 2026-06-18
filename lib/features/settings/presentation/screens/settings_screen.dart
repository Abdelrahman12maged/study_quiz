import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/core/constants/app_constants.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:study_quiz/features/auth/presentation/cubit/auth_state.dart';
import 'package:study_quiz/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:study_quiz/features/settings/presentation/cubit/settings_state.dart';

import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/features/settings/presentation/widgets/section_header.dart';
import 'package:study_quiz/features/settings/presentation/widgets/settings_card.dart';
import 'package:study_quiz/features/settings/presentation/widgets/theme_selector.dart';
import 'package:study_quiz/features/settings/presentation/widgets/language_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        
        return Scaffold(
          appBar: AppBar(title: Text(l10n.settingsTitle)),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            children: [
              // ── Appearance ───────────────────────────────────
              SectionHeader(title: l10n.appearance),
              SettingsCard(children: [
                ThemeSelector(current: state.themeMode),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // ── Language ─────────────────────────────────────
              SectionHeader(title: l10n.language),
              SettingsCard(children: [
                LanguageTile(locale: state.locale),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // ── Account ──────────────────────────────────────
              SectionHeader(title: l10n.account),
              SettingsCard(children: [
                Builder(builder: (context) {
                  final authState = context.watch<AuthCubit>().state;
                  final email = authState is AuthSuccess
                      ? authState.user.email
                      : l10n.notSignedIn;
                  return ListTile(
                    leading: const Icon(Icons.person_outline_rounded),
                    title: Text(l10n.accountInfo),
                    subtitle: Text(email),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  );
                }),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout_rounded, color: cs.error),
                  title: Text(l10n.signOut,
                      style: TextStyle(color: cs.error)),
                  onTap: () => _confirmSignOut(context, l10n),
                ),
              ]),
              const SizedBox(height: AppSpacing.lg),

              // ── About ────────────────────────────────────────
              SectionHeader(title: l10n.about),
              SettingsCard(children: [
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: Text(l10n.appVersion),
                  trailing: Text(AppConstants.appVersion,
                      style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant)),
                ),
              ]),
              const SizedBox(height: AppSpacing.xxl),

              // Footer
              Center(
                child: Text(
                  AppConstants.appName,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.signOut),
        content: Text(l10n.signOutConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<AuthCubit>().signOut();
              context.go('/sign-in');
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}
