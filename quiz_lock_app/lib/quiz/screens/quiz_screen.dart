import 'package:flutter/material.dart';

import '../data/quiz_asset_loader.dart';
import '../models/quiz_question.dart';
import '../widgets/quiz_option_button.dart';
import '../widgets/quiz_fill_blank_widget.dart';
import '../widgets/quiz_result_card.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _loader = const QuizAssetLoader();

  int _currentIndex = 0;
  final Map<int, int> _selectedByIndex = <int, int>{}; // 객관식용
  final Map<int, String> _submittedAnswers = <int, String>{}; // 빈칸 채우기 제출된 답변만

  void _selectOption(int index, QuizQuestion q) {
    if (_selectedByIndex.containsKey(_currentIndex)) return;
    setState(() {
      _selectedByIndex[_currentIndex] = index;
    });
  }

  void _next(List<QuizQuestion> questions) {
    if (_currentIndex >= questions.length - 1) return;
    setState(() {
      _currentIndex++;
    });
  }

  void _prev() {
    if (_currentIndex <= 0) return;
    setState(() {
      _currentIndex--;
    });
  }

  void _retryCurrent() {
    setState(() {
      _selectedByIndex.remove(_currentIndex);
      _submittedAnswers.remove(_currentIndex);
    });
  }

  bool _isAnswered(QuizQuestion q) {
    switch (q.type) {
      case QuizQuestionType.multipleChoice:
        return _selectedByIndex.containsKey(_currentIndex);
      case QuizQuestionType.fillBlank:
        // 제출된 답변만 확인 (입력 중인 텍스트는 제외)
        return _submittedAnswers.containsKey(_currentIndex) &&
            (_submittedAnswers[_currentIndex]?.trim().isNotEmpty ?? false);
    }
  }

  bool _isCorrect(QuizQuestion q) {
    if (!_isAnswered(q)) return false;
    
    switch (q.type) {
      case QuizQuestionType.multipleChoice:
        final selectedIndex = _selectedByIndex[_currentIndex];
        return selectedIndex == q.answerIndex;
      case QuizQuestionType.fillBlank:
        // 제출된 답변으로 정답 확인
        final userAnswer = _submittedAnswers[_currentIndex]?.trim().toLowerCase() ?? '';
        final correctAnswer = q.correctAnswer?.trim().toLowerCase() ?? '';
        return userAnswer == correctAnswer;
    }
  }

  void _submitFillBlank(String answer) {
    if (answer.trim().isEmpty || _submittedAnswers.containsKey(_currentIndex)) return;
    setState(() {
      _submittedAnswers[_currentIndex] = answer.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizQuestion>>(
      future: _loader.loadQuestions('assets/quizzes/sample_quiz.json'),
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        Widget body;
        if (snapshot.connectionState != ConnectionState.done) {
          body = const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          body = Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('퀴즈 로딩 실패', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(snapshot.error.toString()),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => setState(() {}),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        } else {
          final questions = snapshot.data ?? const <QuizQuestion>[];
          if (questions.isEmpty) {
            body = const Center(child: Text('퀴즈 데이터가 비어있어요.'));
          } else {
            final q = questions[_currentIndex];
            final progressText = '${_currentIndex + 1} / ${questions.length}';
            final answered = _isAnswered(q);
            final correct = _isCorrect(q);
            final isLast = _currentIndex == questions.length - 1;

            body = ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        progressText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (answered)
                      TextButton(
                        onPressed: _retryCurrent,
                        child: const Text('다시풀기'),
                      )
                    else if (isLast)
                      Text('마지막', style: theme.textTheme.labelLarge),
                  ],
                ),
                const SizedBox(height: 14),
                // 문제 타입에 따라 다른 UI 표시
                if (q.type == QuizQuestionType.multipleChoice) ...[
                  Card(
                    elevation: 0,
                    color: colorScheme.surfaceContainerHighest,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        q.question,
                        style: theme.textTheme.titleLarge?.copyWith(height: 1.25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(q.options!.length, (i) {
                    final state = _optionStateFor(i, q);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: QuizOptionButton(
                        text: q.options![i],
                        state: state,
                        onPressed: answered ? null : () => _selectOption(i, q),
                      ),
                    );
                  }),
                ] else if (q.type == QuizQuestionType.fillBlank) ...[
                  QuizFillBlankWidget(
                    question: q.question,
                    correctAnswer: q.correctAnswer ?? '',
                    blankPositions: q.blankPositions,
                    onSubmit: _submitFillBlank,
                    answered: answered,
                    userAnswer: _submittedAnswers[_currentIndex],
                  ),
                ],
                const SizedBox(height: 6),
                if (answered)
                  QuizResultCard(
                    isCorrect: correct,
                    questionType: q.type == QuizQuestionType.multipleChoice ? 'multipleChoice' : 'fillBlank',
                    correctAnswer: q.type == QuizQuestionType.multipleChoice
                        ? q.options![q.answerIndex!]
                        : (q.correctAnswer ?? ''),
                    explanation: q.explanation,
                  ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _currentIndex > 0 ? _prev : null,
                      child: const Text('이전'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: !isLast ? () => _next(questions) : null,
                      child: const Text('다음'),
                    ),
                  ],
                ),
              ],
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('퀴즈 앱'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: body,
        );
      },
    );
  }

  QuizOptionState _optionStateFor(int optionIndex, QuizQuestion q) {
    final selectedIndex = _selectedByIndex[_currentIndex];
    final answered = _isAnswered(q);

    if (!answered) {
      if (selectedIndex == optionIndex) return QuizOptionState.selected;
      return QuizOptionState.idle;
    }

    if (optionIndex == q.answerIndex) return QuizOptionState.correct;
    if (selectedIndex == optionIndex && optionIndex != q.answerIndex) return QuizOptionState.wrong;
    return QuizOptionState.disabled;
  }
}

