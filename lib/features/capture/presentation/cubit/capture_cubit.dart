import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/features/capture/domain/repositories/capture_repository.dart';
import 'capture_state.dart';

/// Manages the capture flow: pick image → preview → confirm → upload to Supabase.
class CaptureCubit extends Cubit<CaptureState> {
  final CaptureRepository _repo;

  CaptureCubit(this._repo) : super(const CaptureInitial());

  void selectImage(File imageFile) {
    emit(CaptureImageSelected(imageFile));
  }

  void clearSelection() {
    emit(const CaptureInitial());
  }

  /// Upload the image to Supabase Storage and create a processing session.
  Future<void> uploadImage() async {
    final currentState = state;
    if (currentState is! CaptureImageSelected) return;

    emit(CaptureUploading(currentState.imageFile));

    final result = await _repo.uploadImage(currentState.imageFile);

    result.fold(
      (failure) {
        emit(CaptureError(
          failure.message,
          imageFile: currentState.imageFile,
        ));
      },
      (sessionId) {
        emit(CaptureSuccess(sessionId));
      },
    );
  }

  void reset() {
    emit(const CaptureInitial());
  }
}
