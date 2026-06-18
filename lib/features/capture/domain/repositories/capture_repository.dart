import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:study_quiz/core/error/failures.dart';
import '../entities/capture_entity.dart';

abstract class CaptureRepository {
  /// Uploads [imageFile] to the backend (n8n webhook).
  /// Returns the [sessionId] assigned by the backend.
  Future<Either<Failure, String>> uploadImage(File imageFile);

  Future<CaptureEntity> saveCapture(CaptureEntity capture);
}
