class QuizQuestion {
  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    this.explanation,
  });

  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String? explanation;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final optionsDynamic = json['options'];
    if (optionsDynamic is! List) {
      throw FormatException('options must be a List', optionsDynamic);
    }

    final options = optionsDynamic.map((e) => e.toString()).toList(growable: false);
    final answerIndex = (json['answerIndex'] as num).toInt();

    return QuizQuestion(
      id: (json['id'] ?? '').toString(),
      question: (json['question'] ?? '').toString(),
      options: options,
      answerIndex: answerIndex,
      explanation: json['explanation']?.toString(),
    );
  }
}

