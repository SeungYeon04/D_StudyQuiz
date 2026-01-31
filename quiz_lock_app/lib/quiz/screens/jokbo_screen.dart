import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// 족보 페이지 - 과목별 로컬 마크다운 로드 후 렌더링
class JokboScreen extends StatelessWidget {
  const JokboScreen({super.key, required this.subject});

  /// 과목별 마크다운 파일 경로 (assets/jokbo/*.md)
  static const Map<String, String> _subjectAssetPaths = {
    '프로그래밍구현': 'assets/jokbo/programming.md',
    '데이터베이스구축': 'assets/jokbo/database.md',
    '운영체제 네트워크 보안': 'assets/jokbo/network.md',
    '시스템분석설계': 'assets/jokbo/system.md',
    'IT 신기술 동향': 'assets/jokbo/trend.md',
  };

  /// 과목명 (리스트에서 선택 시 전달, 해당 과목 md 로드)
  final String subject;

  String get _assetPath =>
      _subjectAssetPaths[subject] ?? 'assets/jokbo/programming.md';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(_assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.hasError
                      ? '로드 실패: ${snapshot.error}'
                      : '내용이 없습니다.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Align(
              alignment: Alignment.centerLeft,
              child: MarkdownBody(
                data: snapshot.data!,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  tableHead: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  tableBody: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  tableBorder: TableBorder.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
