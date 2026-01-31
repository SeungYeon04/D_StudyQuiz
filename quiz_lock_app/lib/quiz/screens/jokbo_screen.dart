import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// 족보 페이지 - 로컬 마크다운(assets/jokbo/jokbo.md) 로드 후 렌더링
class JokboScreen extends StatelessWidget {
  const JokboScreen({super.key});

  static const String _assetPath = 'assets/jokbo/jokbo.md';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('족보'),
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
