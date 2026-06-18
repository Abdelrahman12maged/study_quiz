import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:study_quiz/l10n/app_localizations.dart';
import 'package:study_quiz/core/theme/app_spacing.dart';
import 'package:study_quiz/core/widgets/primary_button.dart';
import 'package:study_quiz/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:study_quiz/features/auth/presentation/cubit/auth_state.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.emailLabel,
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.emailRequired;
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v)) {
                return l10n.invalidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: l10n.passwordLabel,
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.passwordRequired;
              if (v.length < 6) return l10n.passwordTooShort;
              return null;
            },
          ),

          // Forgot password
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () {}, // TODO: implement forgot password
              child: Text(l10n.forgotPassword),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Sign in button
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return PrimaryButton(
                label: l10n.signIn,
                isLoading: state is AuthLoading,
                onPressed: _submit,
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Sign up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.dontHaveAccount, style: tt.bodyMedium),
              TextButton(
                onPressed: () => context.go('/sign-up'),
                child: Text(l10n.signUp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
