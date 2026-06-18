import 'package:equatable/equatable.dart';

class CaptureEntity extends Equatable {
  final String id;
  final String imagePath;       // Local file path before upload
  final DateTime capturedAt;
  final String? sessionId;      // Populated after upload succeeds

  const CaptureEntity({
    required this.id,
    required this.imagePath,
    required this.capturedAt,
    this.sessionId,
  });

  CaptureEntity copyWith({String? sessionId}) => CaptureEntity(
        id: id,
        imagePath: imagePath,
        capturedAt: capturedAt,
        sessionId: sessionId ?? this.sessionId,
      );

  @override
  List<Object?> get props => [id, imagePath, capturedAt, sessionId];
}
