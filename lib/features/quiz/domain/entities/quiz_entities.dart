import 'package:equatable/equatable.dart';

/// Represents a quiz question entity in the domain layer.
enum QuestionType { mcq, trueFalse }

class Question extends Equatable {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;   // For MCQ: 4 options; TF: ['True', 'False']
  final int correctIndex;        // 0-based index into [options]
  final String explanation;
  final String? sourceUrl;
  final String? sourceTitle;

  const Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    this.sourceUrl,
    this.sourceTitle,
  });

  @override
  List<Object?> get props => [id, text, type, options, correctIndex, explanation, sourceUrl, sourceTitle];
}

/// Represents a full quiz session (one captured page → set of questions).
enum QuizSessionStatus { processing, ready, failed }

class QuizSession extends Equatable {
  final String id;
  final String subject;
  final List<Question> questions;
  final QuizSessionStatus status;
  final DateTime createdAt;
  final String? thumbnailUrl;  // The captured image URL

  const QuizSession({
    required this.id,
    required this.subject,
    required this.questions,
    required this.status,
    required this.createdAt,
    this.thumbnailUrl,
  });

  int get totalQuestions => questions.length;

  @override
  List<Object?> get props => [id, subject, questions, status, createdAt, thumbnailUrl];
}
