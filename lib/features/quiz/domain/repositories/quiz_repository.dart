import '../entities/quiz_entities.dart';

abstract class QuizRepository {
  /// Fetch a quiz session by ID from Supabase.
  Future<QuizSession> getSession(String sessionId);

  /// Submit an answer for a question. Returns true if correct.
  Future<bool> submitAnswer(String questionId, int answerIndex);

  /// Submit a full answer with all context needed for persistence.
  Future<bool> submitAnswerFull({
    required String sessionId,
    required String questionId,
    required int selectedIndex,
    required int correctIndex,
  });

  /// Get all historical sessions for the current user.
  Future<List<QuizSession>> getAllSessions();

  /// Get dashboard stats: questionsThisWeek, weeklyAccuracy, streakDays, totalSessions.
  Future<Map<String, dynamic>> getDashboardStats();
}
