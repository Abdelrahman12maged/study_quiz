import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:study_quiz/features/auth/domain/entities/user_entity.dart';

/// Direct calls to Supabase Auth API.
class SupabaseAuthDatasource {
  final SupabaseClient _client;
  SupabaseAuthDatasource(this._client);

  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return _mapUser(response.user!);
  }

  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    return _mapUser(response.user!);
  }

  Future<void> signOut() => _client.auth.signOut();

  UserEntity? getCurrentUser() {
    final user = _client.auth.currentUser;
    return user != null ? _mapUser(user) : null;
  }

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  UserEntity _mapUser(User user) => UserEntity(
        id: user.id,
        email: user.email ?? '',
        displayName: user.userMetadata?['display_name'] as String? ??
            (user.email?.split('@').first),
      );
}
