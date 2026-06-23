import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'quiz/screens/quiz_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web에서 한글이 잠깐 깨져 보이는 현상 방지: 앱 시작 전 폰트 로드
  await GoogleFonts.pendingFonts([GoogleFonts.notoSansKr()]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
      useMaterial3: true,
    );
    return MaterialApp(
      title: '퀴즈 앱',
      theme: base.copyWith(textTheme: GoogleFonts.notoSansKrTextTheme(base.textTheme)),
      home: const QuizScreen(),
    );
  }
}
