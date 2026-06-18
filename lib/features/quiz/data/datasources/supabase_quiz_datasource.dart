import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:study_quiz/features/quiz/data/models/quiz_session_model.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

/// Datasource for quiz data using Supabase PostgREST and user_answers table.
class SupabaseQuizDatasource {
  final SupabaseClient _client;
  SupabaseQuizDatasource(this._client);

  /// Fetch a single session with its questions (ordered by sort_order).
  Future<QuizSession> getSession(String sessionId) async {
    final data = await _client
        .from('quiz_sessions')
        .select('*, questions(*)')
        .eq('id', sessionId)
        .single();

    // Sort questions by sort_order
    if (data['questions'] is List) {
      (data['questions'] as List).sort(
        (a, b) => ((a['sort_order'] as num?) ?? 0)
            .compareTo((b['sort_order'] as num?) ?? 0),
      );
    }

    return QuizSessionModel.fromJson(data);
  }

  /// Fetch all sessions for the current user (newest first), with question counts.
  Future<List<QuizSession>> getAllSessions() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _client
        .from('quiz_sessions')
        .select('*, questions(id)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((row) => QuizSessionModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// Submit a user's answer and persist it.
  Future<bool> submitAnswer({
    required String sessionId,
    required String questionId,
    required int selectedIndex,
    required int correctIndex,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return false;

    final isCorrect = selectedIndex == correctIndex;

    await _client.from('user_answers').insert({
      'user_id': userId,
      'session_id': sessionId,
      'question_id': questionId,
      'selected_index': selectedIndex,
      'is_correct': isCorrect,
    });

    return isCorrect;
  }

  /// Calculate dashboard stats for the current user.
  /// Returns: { questionsThisWeek, weeklyAccuracy, streakDays, totalSessions }
  Future<Map<String, dynamic>> getDashboardStats() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return {
        'questionsThisWeek': 0,
        'weeklyAccuracy': 0.0,
        'streakDays': 0,
        'totalSessions': 0,
      };
    }

    final weekAgo = DateTime.now().subtract(const Duration(days: 7));

    // Fetch this week's answers
    final weekAnswers = await _client
        .from('user_answers')
        .select('is_correct, answered_at')
        .eq('user_id', userId)
        .gte('answered_at', weekAgo.toIso8601String());

    final totalThisWeek = (weekAnswers as List).length;
    final correctThisWeek =
        weekAnswers.where((a) => a['is_correct'] == true).length;
    final weeklyAccuracy =
        totalThisWeek > 0 ? correctThisWeek / totalThisWeek : 0.0;

    // Count total sessions
    final sessions = await _client
        .from('quiz_sessions')
        .select('id')
        .eq('user_id', userId)
        .eq('status', 'ready');
    final totalSessions = (sessions as List).length;

    // Compute streak: count consecutive days with at least one answer
    final allAnswers = await _client
        .from('user_answers')
        .select('answered_at')
        .eq('user_id', userId)
        .order('answered_at', ascending: false);

    final streakDays = _computeStreak(allAnswers as List);

    return {
      'questionsThisWeek': totalThisWeek,
      'weeklyAccuracy': weeklyAccuracy,
      'streakDays': streakDays,
      'totalSessions': totalSessions,
    };
  }

  int _computeStreak(List<dynamic> answers) {
    if (answers.isEmpty) return 0;

    final days = answers
        .map((a) {
          final dt = DateTime.parse(a['answered_at'] as String).toLocal();
          return DateTime(dt.year, dt.month, dt.day);
        })
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // newest first

    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    int streak = 0;
    DateTime expected = todayNorm;

    for (final day in days) {
      if (day == expected || day == expected.subtract(const Duration(days: 1))) {
        streak++;
        expected = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  /// Subscribe to realtime changes on a specific session's status.
  RealtimeChannel subscribeToSession({
    required String sessionId,
    required void Function(String status) onStatusChange,
  }) {
    return _client
        .channel('session_$sessionId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'quiz_sessions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'id',
            value: sessionId,
          ),
          callback: (payload) {
            final newStatus = payload.newRecord['status'] as String?;
            if (newStatus != null) onStatusChange(newStatus);
          },
        )
        .subscribe();
  }
}
