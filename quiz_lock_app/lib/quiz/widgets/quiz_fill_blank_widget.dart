import 'package:flutter/material.dart';

class QuizFillBlankWidget extends StatefulWidget {
  const QuizFillBlankWidget({
    super.key,
    required this.question,
    required this.correctAnswer,
    required this.onAnswerChanged,
    this.blankPositions,
    this.answered = false,
    this.userAnswer,
  });

  final String question;
  final String correctAnswer;
  final List<int>? blankPositions;
  final ValueChanged<String> onAnswerChanged;
  final bool answered;
  final String? userAnswer;

  @override
  State<QuizFillBlankWidget> createState() => _QuizFillBlankWidgetState();
}

class _QuizFillBlankWidgetState extends State<QuizFillBlankWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userAnswer ?? '');
    _controller.addListener(() {
      widget.onAnswerChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(QuizFillBlankWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userAnswer != widget.userAnswer && widget.userAnswer != _controller.text) {
      _controller.text = widget.userAnswer ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _buildQuestionWithBlanks() {
    // 질문 텍스트에서 [ ] 또는 ___ 같은 패턴을 빈칸으로 표시
    return widget.question.replaceAllMapped(
      RegExp(r'\[.*?\]|___+|\(.*?\)'),
      (match) => '______',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isCorrect = widget.answered && 
        widget.userAnswer?.trim().toLowerCase() == widget.correctAnswer.trim().toLowerCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _buildQuestionWithBlanks(),
                  style: theme.textTheme.titleLarge?.copyWith(height: 1.25),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  enabled: !widget.answered,
                  decoration: InputDecoration(
                    hintText: '정답을 입력하세요',
                    filled: true,
                    fillColor: widget.answered
                        ? (isCorrect ? Colors.green.shade50 : Colors.red.shade50)
                        : colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.answered
                            ? (isCorrect ? Colors.green.shade600 : Colors.red.shade600)
                            : colorScheme.outline,
                        width: widget.answered ? 2 : 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.answered
                            ? (isCorrect ? Colors.green.shade600 : Colors.red.shade600)
                            : colorScheme.outline,
                        width: widget.answered ? 2 : 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
