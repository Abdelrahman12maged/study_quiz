import 'package:study_quiz/features/quiz/data/datasources/supabase_quiz_datasource.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';
import 'package:study_quiz/features/quiz/domain/repositories/quiz_repository.dart';

class SupabaseQuizRepository implements QuizRepository {
  final SupabaseQuizDatasource _ds;
  SupabaseQuizRepository(this._ds);

  @override
  Future<QuizSession> getSession(String sessionId) =>
      _ds.getSession(sessionId);

  @override
  Future<bool> submitAnswer(String questionId, int answerIndex) {
    // This overload is kept for interface compatibility.
    // Use submitAnswerFull for real calls (needs sessionId + correctIndex).
    throw UnimplementedError('Use submitAnswerFull instead.');
  }

  @override
  Future<bool> submitAnswerFull({
    required String sessionId,
    required String questionId,
    required int selectedIndex,
    required int correctIndex,
  }) =>
      _ds.submitAnswer(
        sessionId: sessionId,
        questionId: questionId,
        selectedIndex: selectedIndex,
        correctIndex: correctIndex,
      );

  @override
  Future<List<QuizSession>> getAllSessions() => _ds.getAllSessions();

  @override
  Future<Map<String, dynamic>> getDashboardStats() => _ds.getDashboardStats();
}
