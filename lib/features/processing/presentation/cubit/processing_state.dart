import 'package:equatable/equatable.dart';

abstract class ProcessingState extends Equatable {
  const ProcessingState();
  @override
  List<Object?> get props => [];
}

class ProcessingInProgress extends ProcessingState {
  final String stageLabel;
  final int stageIndex;
  final int totalStages;
  final double progress; // 0.0 to 1.0

  const ProcessingInProgress({
    required this.stageLabel,
    required this.stageIndex,
    required this.totalStages,
    required this.progress,
  });

  @override
  List<Object?> get props => [stageLabel, stageIndex, totalStages, progress];
}

class ProcessingComplete extends ProcessingState {
  final String sessionId;
  const ProcessingComplete(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class ProcessingFailed extends ProcessingState {
  final String message;
  const ProcessingFailed(this.message);
  @override
  List<Object?> get props => [message];
}
