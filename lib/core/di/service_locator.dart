import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:study_quiz/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:study_quiz/features/auth/data/repositories/supabase_auth_repository.dart';
import 'package:study_quiz/features/auth/domain/repositories/auth_repository.dart';

import 'package:study_quiz/features/quiz/data/datasources/supabase_quiz_datasource.dart';
import 'package:study_quiz/features/quiz/data/repositories/supabase_quiz_repository.dart';
import 'package:study_quiz/features/quiz/domain/repositories/quiz_repository.dart';

import 'package:study_quiz/features/capture/data/datasources/supabase_capture_datasource.dart';
import 'package:study_quiz/features/capture/data/repositories/supabase_capture_repository.dart';
import 'package:study_quiz/features/capture/domain/repositories/capture_repository.dart';

final sl = GetIt.instance;

/// Registers all app-wide singletons.
/// Call once after Supabase.initialize() completes.
void setupServiceLocator() {
  final client = Supabase.instance.client;

  // ── Core ──
  sl.registerLazySingleton<SupabaseClient>(() => client);

  // ── Auth ──
  sl.registerLazySingleton(() => SupabaseAuthDatasource(client));
  sl.registerLazySingleton<AuthRepository>(
    () => SupabaseAuthRepository(sl<SupabaseAuthDatasource>()),
  );

  // ── Quiz / Sessions ──
  sl.registerLazySingleton(() => SupabaseQuizDatasource(client));
  sl.registerLazySingleton<QuizRepository>(
    () => SupabaseQuizRepository(sl<SupabaseQuizDatasource>()),
  );

  // ── Capture ──
  sl.registerLazySingleton(() => SupabaseCaptureDatasource(client));
  sl.registerLazySingleton<CaptureRepository>(
    () => SupabaseCaptureRepository(sl<SupabaseCaptureDatasource>()),
  );
}
