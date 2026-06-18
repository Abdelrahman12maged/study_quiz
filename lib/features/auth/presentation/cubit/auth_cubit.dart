import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/features/auth/domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Auth cubit — manages sign in / sign up / sign out via Supabase.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;

  AuthCubit(this._repo) : super(const AuthInitial()) {
    _checkCurrentUser();
  }

  /// Check if there's already a logged-in user (persisted session).
  Future<void> _checkCurrentUser() async {
    try {
      final user = await _repo.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      }
    } catch (_) {
      // No current session — stay in AuthInitial
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(const AuthLoading());

    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError('Email and password are required'));
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      emit(const AuthError('Please enter a valid email address'));
      return;
    }

    if (password.length < 6) {
      emit(const AuthError('Password must be at least 6 characters'));
      return;
    }

    try {
      final user = await _repo.signIn(email: email, password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(_parseError(e)));
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    emit(const AuthLoading());

    // Bug fix: add same validation as signIn
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError('Email and password are required'));
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
      emit(const AuthError('Please enter a valid email address'));
      return;
    }

    if (password.length < 6) {
      emit(const AuthError('Password must be at least 6 characters'));
      return;
    }

    try {
      final user = await _repo.signUp(email: email, password: password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(_parseError(e)));
    }
  }

  Future<void> signOut() async {
    try {
      await _repo.signOut();
    } catch (_) {
      // Sign out locally even if remote call fails
    }
    emit(const AuthInitial());
  }

  String _parseError(dynamic e) {
    final msg = e.toString();
    if (msg.contains('Invalid login credentials')) {
      return 'Incorrect email or password';
    }
    if (msg.contains('User already registered')) {
      return 'An account with this email already exists';
    }
    if (msg.contains('Email not confirmed')) {
      return 'Please check your email to confirm your account';
    }
    return 'Something went wrong. Please try again.';
  }
}
