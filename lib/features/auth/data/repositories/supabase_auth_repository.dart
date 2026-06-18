import 'package:study_quiz/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:study_quiz/features/auth/domain/entities/user_entity.dart';
import 'package:study_quiz/features/auth/domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseAuthDatasource _ds;
  SupabaseAuthRepository(this._ds);

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) =>
      _ds.signIn(email: email, password: password);

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
  }) =>
      _ds.signUp(email: email, password: password);

  @override
  Future<void> signOut() => _ds.signOut();

  @override
  Future<UserEntity?> getCurrentUser() async => _ds.getCurrentUser();
}
