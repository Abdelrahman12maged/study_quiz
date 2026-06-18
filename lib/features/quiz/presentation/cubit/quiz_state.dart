import 'package:equatable/equatable.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

abstract class QuizState extends Equatable {
  const QuizState();
  @override
  List<Object?> get props => [];
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizActive extends QuizState {
  final QuizSession session;
  final int currentIndex;
  final Map<int, int> answers; // questionIndex → selectedOptionIndex
  final int? lastSelectedIndex; // current selection before confirming
  final bool? lastAnswerCorrect; // null = not yet answered
  final bool showExplanation;

  const QuizActive({
    required this.session,
    required this.currentIndex,
    this.answers = const {},
    this.lastSelectedIndex,
    this.lastAnswerCorrect,
    this.showExplanation = false,
  });

  Question get currentQuestion => session.questions[currentIndex];
  int get totalQuestions => session.questions.length;
  bool get isLastQuestion => currentIndex >= totalQuestions - 1;
  bool get hasAnswered => lastAnswerCorrect != null;

  int get correctCount => answers.entries
      .where((e) => session.questions[e.key].correctIndex == e.value)
      .length;

  @override
  List<Object?> get props => [
        session,
        currentIndex,
        answers,
        lastSelectedIndex,
        lastAnswerCorrect,
        showExplanation,
      ];
}

class QuizCompleted extends QuizState {
  final QuizSession session;
  final Map<int, int> answers;
  final int score;

  const QuizCompleted({
    required this.session,
    required this.answers,
    required this.score,
  });

  int get totalQuestions => session.questions.length;
  double get percentage => totalQuestions > 0 ? score / totalQuestions : 0;

  @override
  List<Object?> get props => [session, answers, score];
}

class QuizError extends QuizState {
  final String message;
  const QuizError(this.message);
  @override
  List<Object?> get props => [message];
}
