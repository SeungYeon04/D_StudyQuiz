import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../data/jokbo_catalog.dart';

/// 족보 페이지 - 과목별 로컬 마크다운 로드 후 렌더링
class JokboScreen extends StatelessWidget {
  const JokboScreen({super.key, required this.subject});

  final String subject;

  String? get _assetPath => JokboCatalog.assetPathFor(subject);
  MarkdownStyleSheet _jokboStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;

    return MarkdownStyleSheet(
      h3: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
        height: 1.3,
      ),
      h3Padding: const EdgeInsets.only(top: 28, bottom: 10),
      h4: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface.withValues(alpha: 0.88),
        height: 1.35,
      ),
      h4Padding: const EdgeInsets.only(top: 18, bottom: 6),
      tableHead: TextStyle(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      tableBody: TextStyle(color: onSurface),
      tableBorder: TableBorder.all(
        color: colorScheme.outline.withValues(alpha: 0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _assetPath == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '아직 $subject 족보 파일이 없어요.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            )
          : FutureBuilder<String>(
        future: rootBundle.loadString(_assetPath!),
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
                styleSheet: _jokboStyleSheet(context),
              ),
            ),
          );
        },
      ),
    );
  }
}
