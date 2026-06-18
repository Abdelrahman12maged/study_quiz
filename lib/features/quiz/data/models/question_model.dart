import 'package:study_quiz/features/quiz/domain/entities/quiz_entities.dart';

class QuestionModel extends Question {
  const QuestionModel({
    required super.id,
    required super.text,
    required super.type,
    required super.options,
    required super.correctIndex,
    required super.explanation,
    super.sourceUrl,
    super.sourceTitle,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final List<String> options;
    if (rawOptions is List) {
      options = rawOptions.map((e) => e.toString()).toList();
    } else {
      options = [];
    }

    final rawCorrectIndex = json['correct_index'];
    int correctIndex = 0;
    if (rawCorrectIndex is num) {
      correctIndex = rawCorrectIndex.toInt();
    } else if (rawCorrectIndex is String) {
      correctIndex = int.tryParse(rawCorrectIndex) ?? 0;
    }

    return QuestionModel(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      type: json['type']?.toString() == 'trueFalse'
          ? QuestionType.trueFalse
          : QuestionType.mcq,
      options: options,
      correctIndex: correctIndex,
      explanation: json['explanation']?.toString() ?? '',
      sourceUrl: json['source_url']?.toString(),
      sourceTitle: json['source_title']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'type': type == QuestionType.trueFalse ? 'trueFalse' : 'mcq',
        'options': options,
        'correct_index': correctIndex,
        'explanation': explanation,
        'source_url': sourceUrl,
        'source_title': sourceTitle,
      };
}
