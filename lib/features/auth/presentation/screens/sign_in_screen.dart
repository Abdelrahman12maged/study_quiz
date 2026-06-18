import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:study_quiz/features/auth/presentation/cubit/auth_state.dart';

import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/features/auth/presentation/widgets/auth_header.dart';
import 'package:study_quiz/features/auth/presentation/widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeader(
                      title: l10n.welcomeBack,
                      subtitle: l10n.signInToContinue,
                    ),
                    const SignInForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
