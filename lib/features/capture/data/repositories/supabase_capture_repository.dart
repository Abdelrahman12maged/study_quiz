import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:study_quiz/core/error/failures.dart';
import 'package:study_quiz/features/capture/data/datasources/supabase_capture_datasource.dart';
import 'package:study_quiz/features/capture/domain/entities/capture_entity.dart';
import 'package:study_quiz/features/capture/domain/repositories/capture_repository.dart';

class SupabaseCaptureRepository implements CaptureRepository {
  final SupabaseCaptureDatasource _ds;
  SupabaseCaptureRepository(this._ds);

  @override
  Future<Either<Failure, String>> uploadImage(File imageFile) async {
    try {
      final sessionId = await _ds.uploadAndCreateSession(imageFile);
      return Right(sessionId);
    } on N8nWebhookException catch (e) {
      return Left(ServerFailure(e.message, e.error));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred during upload: $e'));
    }
  }

  @override
  Future<CaptureEntity> saveCapture(CaptureEntity capture) async {
    // With Supabase, the session is created as part of uploadImage.
    // This method returns the entity as-is for local tracking.
    return capture;
  }
}
