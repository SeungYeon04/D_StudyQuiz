import 'package:flutter/material.dart';

import 'jokbo_screen.dart';

/// 족보 바로가기 → 먼저 보이는 과목 선택 리스트 (세로 스크롤)
class JokboListScreen extends StatelessWidget {
  const JokboListScreen({super.key});

  static const String _title = '정보처리산업기사';

  static const List<String> _subjects = [
    '프로그래밍구현',
    '데이터베이스구축',
    '운영체제 네트워크 보안',
    '시스템분석설계',
    'IT 신기술 동향',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('족보'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          // 맨 위 타이틀
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              _title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // 과목 버튼 리스트 (세로 스크롤)
          ..._subjects.map((subject) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                title: Text(
                  subject,
                  style: theme.textTheme.titleMedium,
                ),
                trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JokboScreen(subject: subject),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
