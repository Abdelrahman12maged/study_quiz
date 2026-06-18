import 'package:equatable/equatable.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final List<QuizSession> sessions;
  final String? filterSubject;

  const HistoryLoaded({required this.sessions, this.filterSubject});

  List<QuizSession> get filteredSessions =>
      filterSubject == null || filterSubject!.isEmpty
          ? sessions
          : sessions.where((s) => s.subject == filterSubject).toList();

  List<String> get availableSubjects =>
      sessions.map((s) => s.subject).toSet().toList()..sort();

  @override
  List<Object?> get props => [sessions, filterSubject];
}

class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);
  @override
  List<Object?> get props => [message];
}
