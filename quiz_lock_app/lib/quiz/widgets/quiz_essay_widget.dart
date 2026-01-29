import 'package:flutter/material.dart';

class QuizEssayWidget extends StatefulWidget {
  const QuizEssayWidget({
    super.key,
    required this.question,
    required this.correctAnswer,
    required this.onAnswerChanged,
    this.answered = false,
    this.userAnswer,
  });

  final String question;
  final String correctAnswer;
  final ValueChanged<String> onAnswerChanged;
  final bool answered;
  final String? userAnswer;

  @override
  State<QuizEssayWidget> createState() => _QuizEssayWidgetState();
}

class _QuizEssayWidgetState extends State<QuizEssayWidget> {
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
  void didUpdateWidget(QuizEssayWidget oldWidget) {
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

  bool _isAnswerSimilar(String userAnswer, String correctAnswer) {
    // 간단한 유사도 체크 (대소문자 무시, 공백 제거)
    final user = userAnswer.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    final correct = correctAnswer.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    
    // 완전 일치
    if (user == correct) return true;
    
    // 키워드 포함 체크 (정답의 주요 단어들이 포함되어 있는지)
    final correctWords = correct.split(' ').where((w) => w.length > 2).toSet();
    final userWords = user.split(' ').where((w) => w.length > 2).toSet();
    
    if (correctWords.isEmpty) return false;
    final matchCount = correctWords.where((w) => userWords.contains(w)).length;
    return matchCount / correctWords.length >= 0.6; // 60% 이상 일치
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSimilar = widget.answered && widget.userAnswer != null &&
        _isAnswerSimilar(widget.userAnswer!, widget.correctAnswer);

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
                  widget.question,
                  style: theme.textTheme.titleLarge?.copyWith(height: 1.25),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  enabled: !widget.answered,
                  maxLines: 5,
                  minLines: 3,
                  decoration: InputDecoration(
                    hintText: '답변을 입력하세요',
                    filled: true,
                    fillColor: widget.answered
                        ? (isSimilar ? Colors.green.shade50 : Colors.orange.shade50)
                        : colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.answered
                            ? (isSimilar ? Colors.green.shade600 : Colors.orange.shade600)
                            : colorScheme.outline,
                        width: widget.answered ? 2 : 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.answered
                            ? (isSimilar ? Colors.green.shade600 : Colors.orange.shade600)
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
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
