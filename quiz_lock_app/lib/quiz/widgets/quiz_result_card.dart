import 'package:flutter/material.dart';

class QuizResultCard extends StatelessWidget {
  const QuizResultCard({
    super.key,
    required this.isCorrect,
    required this.questionType,
    required this.correctAnswer,
    this.explanation,
  });

  final bool isCorrect;
  final String questionType;
  final String correctAnswer;
  final String? explanation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCorrect ? '정답!' : '오답!',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 6),
            Text('정답: $correctAnswer'),
            if ((explanation ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('해설: $explanation'),
            ],
          ],
        ),
      ),
    );
  }
}
