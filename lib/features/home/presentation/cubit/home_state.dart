import 'package:equatable/equatable.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<QuizSession> recentSessions;
  final int questionsThisWeek;
  final double weeklyAccuracy;
  final int streakDays;

  const HomeLoaded({
    required this.recentSessions,
    required this.questionsThisWeek,
    required this.weeklyAccuracy,
    required this.streakDays,
  });

  @override
  List<Object?> get props => [recentSessions, questionsThisWeek, weeklyAccuracy, streakDays];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
