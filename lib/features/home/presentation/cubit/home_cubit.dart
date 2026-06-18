import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/features/quiz/domain/repositories/quiz_repository.dart';
import 'home_state.dart';

/// Home cubit — loads recent sessions and stats from Supabase.
class HomeCubit extends Cubit<HomeState> {
  final QuizRepository _repo;

  HomeCubit(this._repo) : super(const HomeLoading());

  Future<void> loadDashboard() async {
    emit(const HomeLoading());

    try {
      final results = await Future.wait([
        _repo.getAllSessions(),
        _repo.getDashboardStats(),
      ]);

      final sessions = results[0] as List;
      final stats = results[1] as Map<String, dynamic>;

      emit(HomeLoaded(
        recentSessions: List.from(sessions),
        questionsThisWeek: stats['questionsThisWeek'] as int? ?? 0,
        weeklyAccuracy: (stats['weeklyAccuracy'] as num?)?.toDouble() ?? 0.0,
        streakDays: stats['streakDays'] as int? ?? 0,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
