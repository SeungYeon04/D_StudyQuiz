import 'package:flutter/material.dart';

class QuizOptionButton extends StatelessWidget {
  const QuizOptionButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.state,
  });

  final String text;
  final VoidCallback? onPressed;
  final QuizOptionState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color? background;
    Color? foreground;
    Color? border;

    switch (state) {
      case QuizOptionState.idle:
        background = colorScheme.surface;
        foreground = colorScheme.onSurface;
        border = colorScheme.outlineVariant;
        break;
      case QuizOptionState.selected:
        background = colorScheme.primaryContainer;
        foreground = colorScheme.onPrimaryContainer;
        border = colorScheme.primary;
        break;
      case QuizOptionState.correct:
        background = Colors.green.shade100;
        foreground = Colors.green.shade900;
        border = Colors.green.shade600;
        break;
      case QuizOptionState.wrong:
        background = Colors.red.shade100;
        foreground = Colors.red.shade900;
        border = Colors.red.shade600;
        break;
      case QuizOptionState.disabled:
        background = colorScheme.surfaceVariant;
        foreground = colorScheme.onSurfaceVariant;
        border = colorScheme.outlineVariant;
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          side: BorderSide(color: border ?? colorScheme.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: Theme.of(context).textTheme.titleMedium,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(text),
        ),
      ),
    );
  }
}

enum QuizOptionState { idle, selected, correct, wrong, disabled }

