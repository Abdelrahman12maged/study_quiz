import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final dynamic error;

  const Failure(this.message, [this.error]);

  @override
  List<Object?> get props => [message, error];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.error]);
}

class ImageCaptureFailure extends Failure {
  const ImageCaptureFailure(super.message, [super.error]);
}
