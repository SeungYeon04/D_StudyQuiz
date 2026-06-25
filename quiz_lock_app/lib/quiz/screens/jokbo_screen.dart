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
    final muted = onSurface.withValues(alpha: 0.72);
    final border = colorScheme.outlineVariant.withValues(alpha: 0.55);

    return MarkdownStyleSheet(
      p: theme.textTheme.bodyMedium?.copyWith(
        color: onSurface.withValues(alpha: 0.92),
        height: 1.65,
      ),
      pPadding: const EdgeInsets.only(bottom: 10),
      strong: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      h3: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
        height: 1.3,
      ),
      h3Padding: const EdgeInsets.only(top: 8, bottom: 12),
      h4: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: onSurface,
        height: 1.35,
      ),
      h4Padding: const EdgeInsets.only(top: 22, bottom: 8),
      listBullet: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
      listIndent: 22,
      listBulletPadding: const EdgeInsets.only(right: 6),
      blockquote: theme.textTheme.bodyMedium?.copyWith(
        color: muted,
        height: 1.5,
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      blockquoteDecoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      tableHead: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: onSurface,
      ),
      tableBody: theme.textTheme.bodyMedium?.copyWith(
        color: onSurface.withValues(alpha: 0.9),
        height: 1.45,
      ),
      tableCellsPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      tableBorder: TableBorder.all(color: border, width: 1),
      tableColumnWidth: const FlexColumnWidth(),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: border, width: 1),
        ),
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
