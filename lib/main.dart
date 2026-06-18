import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:study_quiz/core/constants/app_constants.dart';
import 'package:study_quiz/core/di/service_locator.dart';
import 'package:study_quiz/core/routing/app_router.dart';
import 'package:study_quiz/core/supabase/supabase_config.dart';
import 'package:study_quiz/core/theme/app_theme.dart';
import 'package:study_quiz/features/auth/domain/repositories/auth_repository.dart';
import 'package:study_quiz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:study_quiz/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:study_quiz/features/settings/presentation/cubit/settings_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  // Register all DI singletons
  setupServiceLocator();

  runApp(const StudyBuddyApp());
}

class StudyBuddyApp extends StatelessWidget {
  const StudyBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // SettingsCubit is app-level — controls theme and locale
        BlocProvider(create: (_) => SettingsCubit()),
        // AuthCubit is app-level — persists sign-in state across navigation
        BlocProvider(create: (_) => AuthCubit(sl<AuthRepository>())),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // ── Routing ───────────────────────────────────────
            routerConfig: appRouter,

            // ── Theming ───────────────────────────────────────
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,

            // ── Localization / RTL ────────────────────────────
            locale: Locale(settings.locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            builder: (context, child) {
              // Enforce Directionality based on locale so RTL mirrors correctly
              return Directionality(
                textDirection: settings.locale == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
