import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class CaptureState extends Equatable {
  const CaptureState();
  @override
  List<Object?> get props => [];
}

class CaptureInitial extends CaptureState {
  const CaptureInitial();
}

class CaptureImageSelected extends CaptureState {
  final File imageFile;
  const CaptureImageSelected(this.imageFile);
  @override
  List<Object?> get props => [imageFile.path];
}

class CaptureUploading extends CaptureState {
  final File imageFile;
  const CaptureUploading(this.imageFile);
  @override
  List<Object?> get props => [imageFile.path];
}

class CaptureSuccess extends CaptureState {
  final String sessionId;
  const CaptureSuccess(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class CaptureError extends CaptureState {
  final String message;
  final File? imageFile; // Keep the image so the user can retry
  const CaptureError(this.message, {this.imageFile});
  @override
  List<Object?> get props => [message, imageFile?.path];
}
