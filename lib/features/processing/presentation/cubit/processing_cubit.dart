import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:study_quiz/core/constants/app_constants.dart';
import 'package:study_quiz/features/quiz/data/datasources/supabase_quiz_datasource.dart';
import 'processing_state.dart';

/// Subscribes to Supabase Realtime for session status updates.
/// Shows a client-side progress animation while waiting for the backend
/// pipeline to finish processing.
class ProcessingCubit extends Cubit<ProcessingState> {
  Timer? _stageTimer;
  Timer? _pollingTimer;
  RealtimeChannel? _channel;
  int _currentStage = 0;
  final String sessionId;
  final SupabaseQuizDatasource _ds;

  ProcessingCubit({required this.sessionId, required SupabaseQuizDatasource ds})
      : _ds = ds,
        super(ProcessingInProgress(
          stageLabel: AppConstants.processingStages[0],
          stageIndex: 0,
          totalStages: AppConstants.processingStages.length,
          progress: 0.0,
        ));

  /// Start realtime subscription + client-side stage animation.
  void startProcessing() {
    _currentStage = 0;
    _emitStage();

    // 1. Subscribe to Realtime updates on this session
    _channel = _ds.subscribeToSession(
      sessionId: sessionId,
      onStatusChange: _onStatusChange,
    );

    // 2. Animate through stages on the client side (visual only)
    _stageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentStage++;

      if (_currentStage >= AppConstants.processingStages.length - 1) {
        // Stay on the last "Almost ready…" stage until status changes
        timer.cancel();
        _emitStage();
        return;
      }

      _emitStage();
    });

    // 3. Polling fallback: check status every 5 seconds in case Realtime fails/is disabled
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final session = await _ds.getSession(sessionId);
        print('Polled session status: ${session.status} (raw: ${session.status.name}), questions count: ${session.questions.length}');
        
        // Transition if status is ready OR if questions have been successfully inserted
        if (session.status == QuizSessionStatus.ready || session.questions.isNotEmpty) {
          _pollingTimer?.cancel();
          _stageTimer?.cancel();
          _channel?.unsubscribe();
          emit(ProcessingComplete(sessionId));
        } else if (session.status == QuizSessionStatus.failed) {
          _pollingTimer?.cancel();
          _stageTimer?.cancel();
          _channel?.unsubscribe();
          emit(const ProcessingFailed(
            'Processing failed. Please try capturing again.',
          ));
        }
      } catch (e, stack) {
        print('Error during session status polling: $e');
        print(stack);
      }
    });
  }

  void _onStatusChange(String status) {
    _stageTimer?.cancel();
    _pollingTimer?.cancel();

    if (status == 'ready') {
      emit(ProcessingComplete(sessionId));
    } else if (status == 'failed') {
      emit(const ProcessingFailed(
          'Processing failed. Please try capturing again.'));
    }
  }

  void _emitStage() {
    final total = AppConstants.processingStages.length;
    final clampedIndex =
        _currentStage.clamp(0, total - 1);
    emit(ProcessingInProgress(
      stageLabel: AppConstants.processingStages[clampedIndex],
      stageIndex: clampedIndex,
      totalStages: total,
      progress: (clampedIndex + 1) / total,
    ));
  }

  @override
  Future<void> close() {
    _stageTimer?.cancel();
    _pollingTimer?.cancel();
    _channel?.unsubscribe();
    return super.close();
  }
}
