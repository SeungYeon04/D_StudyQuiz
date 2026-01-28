import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/quiz_question.dart';

class QuizAssetLoader {
  const QuizAssetLoader();

  Future<List<QuizQuestion>> loadQuestions(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);

    if (decoded is Map<String, dynamic>) {
      final questions = decoded['questions'];
      if (questions is! List) {
        throw const FormatException('JSON must contain a "questions" list');
      }
      return questions
          .cast<dynamic>()
          .map((e) => QuizQuestion.fromJson((e as Map).cast<String, dynamic>()))
          .toList(growable: false);
    }

    if (decoded is List) {
      return decoded
          .cast<dynamic>()
          .map((e) => QuizQuestion.fromJson((e as Map).cast<String, dynamic>()))
          .toList(growable: false);
    }

    throw const FormatException('Unsupported JSON format for quiz');
  }
}

