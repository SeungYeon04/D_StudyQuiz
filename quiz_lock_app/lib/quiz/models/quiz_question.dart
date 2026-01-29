enum QuizQuestionType {
  multipleChoice, // 객관식
  fillBlank,      // 빈칸 채우기
}

class QuizQuestion {
  QuizQuestion({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    this.answerIndex,
    this.correctAnswer, // 빈칸 채우기나 서술형의 정답
    this.explanation,
    this.blankPositions, // 빈칸 채우기에서 빈칸 위치 (예: [5, 10] = 5번째와 10번째 문자 뒤에 빈칸)
  });

  final String id;
  final QuizQuestionType type;
  final String question;
  final List<String>? options; // 객관식용
  final int? answerIndex; // 객관식용
  final String? correctAnswer; // 빈칸 채우기/서술형용
  final String? explanation;
  final List<int>? blankPositions; // 빈칸 채우기용

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final typeStr = (json['type'] ?? 'multipleChoice').toString();
    QuizQuestionType type;
    switch (typeStr.toLowerCase()) {
      case 'fillblank':
      case 'fill_blank':
      case 'fill-blank':
        type = QuizQuestionType.fillBlank;
        break;
      default:
        type = QuizQuestionType.multipleChoice;
    }

    List<String>? options;
    int? answerIndex;
    if (type == QuizQuestionType.multipleChoice) {
      final optionsDynamic = json['options'];
      if (optionsDynamic is! List) {
        throw FormatException('options must be a List for multiple choice', optionsDynamic);
      }
      options = optionsDynamic.map((e) => e.toString()).toList(growable: false);
      answerIndex = (json['answerIndex'] as num).toInt();
    }

    String? correctAnswer;
    if (type == QuizQuestionType.fillBlank) {
      correctAnswer = json['correctAnswer']?.toString();
    }

    List<int>? blankPositions;
    if (type == QuizQuestionType.fillBlank && json['blankPositions'] != null) {
      final blankPositionsDynamic = json['blankPositions'];
      if (blankPositionsDynamic is List) {
        blankPositions = blankPositionsDynamic.map((e) => (e as num).toInt()).toList();
      }
    }

    return QuizQuestion(
      id: (json['id'] ?? '').toString(),
      type: type,
      question: (json['question'] ?? '').toString(),
      options: options,
      answerIndex: answerIndex,
      correctAnswer: correctAnswer,
      explanation: json['explanation']?.toString(),
      blankPositions: blankPositions,
    );
  }
}

