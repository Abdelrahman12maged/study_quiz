import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/features/quiz/domain/repositories/quiz_repository.dart';
import 'quiz_state.dart';

/// Quiz cubit — drives the one-question-at-a-time quiz flow using Supabase data.
class QuizCubit extends Cubit<QuizState> {
  final QuizRepository _repo;

  QuizCubit(this._repo) : super(const QuizLoading());

  Future<void> loadQuiz(String sessionId) async {
    emit(const QuizLoading());

    try {
      final session = await _repo.getSession(sessionId);

      if (session.questions.isEmpty) {
        emit(const QuizError('No questions available for this session'));
        return;
      }

      emit(QuizActive(session: session, currentIndex: 0));
    } catch (e) {
      emit(QuizError(e.toString()));
    }
  }

  /// User taps an answer option (before confirming).
  void selectAnswer(int optionIndex) {
    final s = state;
    if (s is! QuizActive || s.hasAnswered) return;

    emit(QuizActive(
      session: s.session,
      currentIndex: s.currentIndex,
      answers: s.answers,
      lastSelectedIndex: optionIndex,
      lastAnswerCorrect: null,
      showExplanation: false,
    ));
  }

  /// Confirm the selected answer — triggers feedback display and persists to Supabase.
  Future<void> confirmAnswer() async {
    final s = state;
    if (s is! QuizActive || s.lastSelectedIndex == null) return;

    final question = s.currentQuestion;
    final correct = question.correctIndex == s.lastSelectedIndex;
    final updatedAnswers = Map<int, int>.from(s.answers)
      ..[s.currentIndex] = s.lastSelectedIndex!;

    emit(QuizActive(
      session: s.session,
      currentIndex: s.currentIndex,
      answers: updatedAnswers,
      lastSelectedIndex: s.lastSelectedIndex,
      lastAnswerCorrect: correct,
      showExplanation: true,
    ));

    // Persist answer to Supabase (fire-and-forget)
    try {
      await _repo.submitAnswerFull(
        sessionId: s.session.id,
        questionId: question.id,
        selectedIndex: s.lastSelectedIndex!,
        correctIndex: question.correctIndex,
      );
    } catch (_) {
      // Don't break the quiz flow if persistence fails
    }
  }

  /// Move to the next question or complete the quiz.
  void nextQuestion() {
    final s = state;
    if (s is! QuizActive) return;

    if (s.isLastQuestion) {
      emit(QuizCompleted(
        session: s.session,
        answers: s.answers,
        score: s.correctCount,
      ));
      return;
    }

    emit(QuizActive(
      session: s.session,
      currentIndex: s.currentIndex + 1,
      answers: s.answers,
    ));
  }
}
