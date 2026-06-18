import 'package:study_quiz/features/quiz/data/models/question_model.dart';
import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

class QuizSessionModel extends QuizSession {
  const QuizSessionModel({
    required super.id,
    required super.subject,
    required super.questions,
    required super.status,
    required super.createdAt,
    super.thumbnailUrl,
  });

  factory QuizSessionModel.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'processing';
    final status = switch (statusStr) {
      'ready' => QuizSessionStatus.ready,
      'failed' => QuizSessionStatus.failed,
      _ => QuizSessionStatus.processing,
    };

    final rawQuestions = json['questions'] as List<dynamic>? ?? [];
    final questions = rawQuestions
        .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
        .toList();

    return QuizSessionModel(
      id: json['id'] as String,
      subject: json['subject'] as String? ?? 'Untitled',
      status: status,
      createdAt: DateTime.parse(json['created_at'] as String),
      thumbnailUrl: json['thumbnail_url'] as String?,
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'status': switch (status) {
          QuizSessionStatus.ready => 'ready',
          QuizSessionStatus.failed => 'failed',
          QuizSessionStatus.processing => 'processing',
        },
        'thumbnail_url': thumbnailUrl,
      };
}
