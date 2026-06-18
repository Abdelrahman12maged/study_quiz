import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/features/quiz/domain/repositories/quiz_repository.dart';
import 'history_state.dart';

/// History cubit — loads and filters all past sessions from Supabase.
class HistoryCubit extends Cubit<HistoryState> {
  final QuizRepository _repo;

  HistoryCubit(this._repo) : super(const HistoryLoading());

  Future<void> loadHistory() async {
    emit(const HistoryLoading());

    try {
      final sessions = await _repo.getAllSessions();
      emit(HistoryLoaded(sessions: sessions));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  void filterBySubject(String? subject) {
    final s = state;
    if (s is! HistoryLoaded) return;

    emit(HistoryLoaded(
      sessions: s.sessions,
      filterSubject: subject,
    ));
  }
}
