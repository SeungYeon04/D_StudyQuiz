import 'package:flutter/material.dart';

import 'quiz/screens/quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '퀴즈 앱',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
        useMaterial3: true,
        fontFamily: 'Kkuk',
      ),
      home: const QuizScreen(),
    );
  }
}
