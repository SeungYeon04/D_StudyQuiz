/// 족보 과목 목록 — 이름·md 경로는 여기만 수정하면 됨.
class JokboEntry {
  const JokboEntry({required this.title, required this.assetPath});

  final String title;
  final String assetPath;
}

class JokboCatalog {
  JokboCatalog._();

  static const sectionTitle = '자격증 공부 족보';

  static const List<JokboEntry> entries = [
    JokboEntry(title: '정보처리기사', assetPath: 'assets/jokbo/database.md'),
    JokboEntry(title: 'JLPT 일본어', assetPath: 'assets/jokbo/network.md'),
  ];

  static List<String> get titles =>
      entries.map((entry) => entry.title).toList(growable: false);

  static String? assetPathFor(String title) {
    for (final entry in entries) {
      if (entry.title == title) return entry.assetPath;
    }
    return null;
  }
}
