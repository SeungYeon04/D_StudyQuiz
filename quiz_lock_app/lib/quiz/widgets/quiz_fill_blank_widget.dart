import 'package:flutter/material.dart';

class QuizFillBlankWidget extends StatefulWidget {
  const QuizFillBlankWidget({
    super.key,
    required this.question,
    required this.correctAnswer,
    required this.onSubmit,
    this.blankPositions,
    this.answered = false,
    this.userAnswer,
  });

  final String question;
  final String correctAnswer;
  final List<int>? blankPositions;
  /// 제출 시에만 호출 (입력한 문자열 전달). 타이핑 중에는 호출 안 함.
  final ValueChanged<String> onSubmit;
  final bool answered;
  final String? userAnswer;

  @override
  State<QuizFillBlankWidget> createState() => _QuizFillBlankWidgetState();
}

class _QuizFillBlankWidgetState extends State<QuizFillBlankWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    final initialText = widget.userAnswer ?? '';
    _controller = TextEditingController(text: initialText);
    _focusNode = FocusNode();
    // 타이핑 중에는 부모로 콜백 안 함 → 깜빡임/느림 제거
    
    // 위젯이 처음 생성될 때만 키보드 포커스
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.answered && !_isInitialized && mounted) {
        _focusNode.requestFocus();
        _isInitialized = true;
      }
    });
  }

  @override
  void didUpdateWidget(QuizFillBlankWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // 문제가 바뀌었을 때만 텍스트 초기화
    if (oldWidget.question != widget.question) {
      _controller.text = '';
      _isInitialized = false;
      
      if (!widget.answered && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !widget.answered) {
            _focusNode.requestFocus();
            _isInitialized = true;
          }
        });
      }
    } else if (oldWidget.userAnswer != widget.userAnswer) {
      // 외부에서 userAnswer가 변경된 경우에만 업데이트 (제출된 답변 표시용)
      final newText = widget.userAnswer ?? '';
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
    
    // 답변 완료되면 키보드 닫기
    if (!oldWidget.answered && widget.answered && mounted) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.trim().isNotEmpty && !widget.answered) {
      widget.onSubmit(_controller.text.trim());
      _focusNode.unfocus();
    }
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
    bool _isCorrectText(String? user, String correct) {
      String normalize(String s) => s.toLowerCase().replaceAll(RegExp(r'\s+'), '');
      return normalize(user ?? '') == normalize(correct);
    }

    final isCorrect = widget.answered && _isCorrectText(widget.userAnswer, widget.correctAnswer);

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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: !widget.answered,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        enableSuggestions: true,
                        autocorrect: true,
                        enableInteractiveSelection: true,
                        onSubmitted: (_) => _handleSubmit(),
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: widget.answered ? null : _handleSubmit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('입력'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
