import 'package:flutter/material.dart';

/// 질문 텍스트와 선택적 코드 블록을 회색 카드로 표시.
class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.question,
    this.codeLines,
    this.footer,
  });

  final String question;
  final List<String>? codeLines;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasCode = codeLines != null && codeLines!.isNotEmpty;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: theme.textTheme.titleLarge?.copyWith(height: 1.25),
            ),
            if (hasCode) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.35),
                  ),
                ),
                child: SelectableText(
                  codeLines!.join('\n'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    height: 1.45,
                  ),
                ),
              ),
            ],
            if (footer != null) ...[
              const SizedBox(height: 16),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}
