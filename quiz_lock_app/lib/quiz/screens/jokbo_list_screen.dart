import 'package:flutter/material.dart';

import '../data/jokbo_catalog.dart';
import 'jokbo_screen.dart';

/// 족보 바로가기 → 과목 선택 리스트
class JokboListScreen extends StatelessWidget {
  const JokboListScreen({super.key});

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
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              JokboCatalog.sectionTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          ...JokboCatalog.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                title: Text(
                  entry.title,
                  style: theme.textTheme.titleMedium,
                ),
                trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => JokboScreen(subject: entry.title),
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
