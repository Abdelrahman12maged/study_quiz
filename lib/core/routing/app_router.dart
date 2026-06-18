import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:study_quiz/core/constants/app_constants.dart';
import 'package:study_quiz/core/routing/app_shell.dart';
import 'package:study_quiz/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:study_quiz/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:study_quiz/features/capture/presentation/screens/capture_screen.dart';
import 'package:study_quiz/features/history/presentation/screens/history_screen.dart';
import 'package:study_quiz/features/home/presentation/screens/home_screen.dart';
import 'package:study_quiz/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:study_quiz/features/processing/presentation/screens/processing_screen.dart';
import 'package:study_quiz/features/quiz/presentation/cubit/quiz_state.dart';
import 'package:study_quiz/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:study_quiz/features/quiz/presentation/screens/results_screen.dart';
import 'package:study_quiz/features/settings/presentation/screens/settings_screen.dart';

/// Named route constants — use these instead of raw strings.
class AppRoutes {
  static const onboarding = '/onboarding';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const home = '/home';
  static const capture = '/capture';
  static const processing = '/processing/:sessionId';
  static const quiz = '/quiz/:sessionId';
  static const results = '/results/:sessionId';
  static const history = '/history';
  static const settings = '/settings';
}

/// Listenable that notifies GoRouter when auth state changes.
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }
}

final _authNotifier = _AuthNotifier();

/// Cached onboarding flag — loaded once at first redirect.
bool? _onboardingDone;

/// The app router. Redirects based on auth + onboarding state.
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  refreshListenable: _authNotifier,
  redirect: (context, state) async {
    // Cache onboarding flag on first check only
    _onboardingDone ??=
        (await SharedPreferences.getInstance())
            .getBool(AppConstants.keyOnboardingComplete) ??
        false;

    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final path = state.fullPath ?? '';

    // Auth-related paths that don't require login
    const publicPaths = [
      AppRoutes.onboarding,
      AppRoutes.signIn,
      AppRoutes.signUp,
    ];
    final isPublicPath = publicPaths.contains(path);

    // 1. Onboarding not done → go to onboarding
    if (!_onboardingDone! && path != AppRoutes.onboarding) {
      return AppRoutes.onboarding;
    }

    // 2. Not logged in and trying to access protected route → sign-in
    if (!isLoggedIn && !isPublicPath) {
      return AppRoutes.signIn;
    }

    // 3. Logged in but on auth page → send to home
    if (isLoggedIn && isPublicPath && path != AppRoutes.onboarding) {
      return AppRoutes.home;
    }

    return null;
  },
  routes: [
    // ── Auth-adjacent flows (no shell) ──────────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (_, __) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (_, __) => const SignUpScreen(),
    ),

    // ── Capture flow (no shell — full screen) ───────────────
    GoRoute(
      path: AppRoutes.capture,
      builder: (_, __) => const CaptureScreen(),
    ),
    GoRoute(
      path: AppRoutes.processing,
      builder: (_, state) => ProcessingScreen(
        sessionId: state.pathParameters['sessionId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.quiz,
      builder: (_, state) => QuizScreen(
        sessionId: state.pathParameters['sessionId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.results,
      builder: (context, state) {
        // Results state is passed as `extra` from QuizCubit
        final result = state.extra as QuizCompleted?;
        if (result == null) {
          // Fallback: push back to home if state is missing (e.g., deep link)
          return const _ResultsPlaceholder();
        }
        return ResultsScreen(result: result);
      },
    ),

    // ── Main shell with bottom nav / rail ───────────────────
    ShellRoute(
      builder: (context, state, child) => AppShell(
        currentLocation: state.fullPath ?? AppRoutes.home,
        child: child,
      ),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (_, __) => const HistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (_, __) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

/// Marks onboarding as complete so the cached flag updates.
void markOnboardingComplete() {
  _onboardingDone = true;
}

/// Shown when navigating to results without state (e.g., cold deep link).
class _ResultsPlaceholder extends StatelessWidget {
  const _ResultsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 64),
            const SizedBox(height: 16),
            const Text('Session not found'),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
