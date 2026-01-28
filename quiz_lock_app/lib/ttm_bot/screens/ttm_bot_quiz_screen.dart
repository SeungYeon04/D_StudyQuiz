import 'package:flutter/material.dart';

import '../data/quiz_asset_loader.dart';
import '../models/quiz_question.dart';
import '../widgets/quiz_option_button.dart';

class TtmmBotQuizScreen extends StatefulWidget {
  const TtmmBotQuizScreen({super.key});

  @override
  State<TtmmBotQuizScreen> createState() => _TtmmBotQuizScreenState();
}

class _TtmmBotQuizScreenState extends State<TtmmBotQuizScreen> {
  final _loader = const QuizAssetLoader();

  int _currentIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  int _correctCount = 0;

  void _selectOption(int index, QuizQuestion q) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (index == q.answerIndex) _correctCount++;
    });
  }

  void _next(List<QuizQuestion> questions) {
    if (_currentIndex >= questions.length - 1) {
      _showDoneDialog(questions.length);
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedIndex = null;
      _answered = false;
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _selectedIndex = null;
      _answered = false;
      _correctCount = 0;
    });
  }

  Future<void> _showDoneDialog(int total) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('퀴즈 끝!'),
        content: Text('점수: $_correctCount / $total'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restart();
            },
            child: const Text('다시하기'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
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
            final answered = _answered;
            final correct = (_selectedIndex == q.answerIndex);

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
                    Text(
                      '정답 ${_correctCount}',
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
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
                ...List.generate(q.options.length, (i) {
                  final state = _optionStateFor(i, q);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: QuizOptionButton(
                      text: q.options[i],
                      state: state,
                      onPressed: answered ? null : () => _selectOption(i, q),
                    ),
                  );
                }),
                const SizedBox(height: 6),
                if (answered)
                  Card(
                    elevation: 0,
                    color: correct ? Colors.green.shade50 : Colors.red.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            correct ? '정답!' : '오답!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: correct ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('정답: ${q.options[q.answerIndex]}'),
                          if ((q.explanation ?? '').trim().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text('해설: ${q.explanation}'),
                          ],
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: _restart,
                      child: const Text('처음부터'),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: answered ? () => _next(questions) : null,
                      child: Text(_currentIndex == questions.length - 1 ? '결과 보기' : '다음'),
                    ),
                  ],
                ),
              ],
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('틈틈봇 퀴즈'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: body,
        );
      },
    );
  }

  QuizOptionState _optionStateFor(int optionIndex, QuizQuestion q) {
    if (!_answered) {
      if (_selectedIndex == optionIndex) return QuizOptionState.selected;
      return QuizOptionState.idle;
    }

    if (optionIndex == q.answerIndex) return QuizOptionState.correct;
    if (_selectedIndex == optionIndex && optionIndex != q.answerIndex) return QuizOptionState.wrong;
    return QuizOptionState.disabled;
  }
}

